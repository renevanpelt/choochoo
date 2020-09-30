require 'active_record'
require 'pusher'
require 'yaml'


# We load the user defined helper classes 
# from ./lib in the application folder

Dir.glob("./lib/*/") do |f|
  require f
end

AggregateRecord = ActiveRecord
EventRecord     = ActiveRecord

EventRecord::Base.establish_connection(adapter: 'sqlite3', database: 'THISNEEDSTOCHANGE.db')
AggregateRecord::Base.establish_connection(adapter: 'sqlite3', database: 'THISNEEDSTOCHANGE_2.db')

# The aggregate database config are part of app config now but
# will be managed by migrations later on.

require './config/aggregate_database.rb'

# The event database however doesn't have to be managed by the
# user using migrations. 

EventRecord::Schema.define do
  self.verbose = true

  create_table(:cqrs_events, force: true) do |t|
    t.string      :event_type,       null: false
    t.text        :serialized_payload,          null: false
    t.string      :aggregate_id,     null: false
    t.datetime    :created_at,       null: false
    t.integer     :version,          null: false
    t.index [:aggregate_id, :version], unique: true
  end

end

# As long as the use of the framework is still dev-only we
# will only support pusher. We will spin up a free alternative
# that compares to the free tier of pusher.

class SocketManager

  attr_accessor :pusher

  def self.make
    if File.exist?("./config/pusher.yml")
      puts YAML.load(File.read('./config/pusher.yml')).inspect
      return Pusher::Client.new(YAML.load(File.read('./config/pusher.yml')).transform_keys(&:to_sym))
    else
      puts "Please configure your Pusher credentials in config/pusher.yml"
      return false
    end
  end

end

SOCKETMANAGER = SocketManager.make




class AggregateRecord::Base


  # notify is a silly function that was needed in the 
  # very early stages of development of the framework
  # and might be handy for W-M to see what happens.
  # Can be removed.

  after_create :notify

  def notify
    puts "#{self.class} created"
  end

  def to_param
    uuid
  end
end


# Clearly the CQRS namespaced modules/classes can be
# placed into their own folders. But the structure still
# changes often and there are not many lines of code
# So yeah..

module CQRS

end

class CQRS::Application

  attr_accessor :resources


  def initialize

    self.resources = []


    # The folders in ./resources/ let the framework know 
    # about user defined resources (models)

    Dir.glob("./resources/*/") do |f|
      resource_name = f.split("/").last

      # Load the model file (AggregateRecord)

      require "./resources/#{resource_name}/#{resource_name.singularize}.rb"
      
      self.resources << resource_name.to_sym
      
      # Load the commands associated with this resource

      Dir.glob("./resources/#{resource_name}/commands/*.rb") do |command_file|
        require command_file
      end
      
      # Load the events associated with this resource
      
      Dir.glob("./resources/#{resource_name}/events/*.rb") do |event_file|
        require event_file
      end

    end




  end


  def render_template(view, locals = {}, layout= nil)
    locals = {application: self}.merge(locals)
    view =  Haml::Engine.new(open("#{view}.html.haml").read).render(Object.new,locals)
    if layout
      return Haml::Engine.new(open("#{layout}.html.haml").read).render(Object.new,{content: view}.merge(locals))
    else
      return view
    end
  end

end




module CQRS::Resource

end

# Note that the Aggregate class here does not represent
# the persisted AggregateRecord.

# This is an in-memory only representation of the resource
# data. 

# DISCUSSION: This means there are 2 places where event logic 
# is implemented. We need to decide whether this is needed. 

# Rene: I personally think this is important. We can standardize
# event types like "update one field" and stuff to allow DRY 
# code, but my intuition tells me we cannot/ don't want to 
# standardize the mapping between the in-memory state and the 
# read-model state

class CQRS::Aggregate

  attr_accessor :id
  attr_accessor :version
  attr_accessor :fields

  def initialize(id)
    self.id = id
    self.version = 0
    self.fields = {}
  end


  def self.build(id, events)
    aggregate = self.new(id)

    events.each do |event|

      aggregate = event.event_type.constantize.apply_to(aggregate, event.payload)
      aggregate.version = event.version
    end

    return aggregate
  end
end

# The in-memory aggregate state is managed by a repository.
# I'm not merried to the term 'repository', just copied 
# stuff I saw in examples and talks.

class CQRS::Repository

  attr_accessor :id
  attr_accessor :events
  attr_accessor :aggregate

  def initialize(id = nil)
    if id
      self.id = id
      self.events = CQRS::Event.where(aggregate_id: id).map{|a| a}.sort{|a,b| a.version <=> b.version }
      self.aggregate = CQRS::Aggregate.build(self.id, self.events)
    else
      self.id = SecureRandom.uuid
      self.events = []
      self.aggregate = CQRS::Aggregate.new(self.id)
    end
  end

  def self.get_aggregate_from_id(id)
    CQRS::Repository.new(id)
  end

  def self.build_aggregate
    CQRS::Repository.new
  end
end

# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.

class CQRS::BaseCommand

  attr_accessor :aggregate_id
  attr_accessor :payload
  attr_accessor :repository

  def initialize(aggregate_id, payload)
    self.payload = payload

    if aggregate_id
      self.repository = CQRS::Repository.get_aggregate_from_id(aggregate_id)
    else
      self.repository = CQRS::Repository.build_aggregate
    end

  end

  def apply!
    resolved = schema.resolve(payload)
    if resolved.errors
      return resolved
    else
      return new_version = event_type.apply_to(repository_aggregate, resolved)
    end
  end

  def repository_aggregate
    self.repository.aggregate
  end

  def event_type
    "CQRS::Resource::#{self.class.to_s.split('::')[2]}::Events::#{self.class.to_s.split('::')[4]}".constantize
  end

  def projected_aggregate
    new_version = event_type.apply_to(repository_aggregate, payload)
  end

  def handle

     CQRS::Event.create!(
       event_type: self.event_type,
       serialized_payload: payload.to_json,
       aggregate_id: repository_aggregate.id,
       version: projected_aggregate.version
     )
     return projected_aggregate

  end
  
end


# This is the activerecord (EventRecord) class that 
# we TEMPORARILY use to push events to websockets

# We need a system to standardize "what happens"
# when events are added to the history and how side
# effects are 1) initiated and 2) managed.
# Side effects should never be called more than once
# after all right?

class CQRS::Event < EventRecord::Base

  self.table_name = "cqrs_events"

  before_create :set_created_at
  after_create :push_event  

  def set_created_at
    self.created_at = Time.now
  end


  def push_event
    aggregate = event_type.constantize.new.perform(self)
    if event_type.constantize.publish_to

      SOCKETMANAGER.trigger(aggregate.send(event_type.constantize.publish_to).to_param, event_type, {
        aggregate_id: aggregate_id,
        payload: payload,
      })
    end
  end

  def payload
    JSON.parse(serialized_payload)
  end

end


module CQRS
  class BaseEvent
    def self.apply_to(aggregate, payload)
      copy = aggregate
      copy.version = copy.version + 1
      return apply_to_aggregate(copy, payload)
    end

    def self.publish_to
      nil
    end
  end
end
