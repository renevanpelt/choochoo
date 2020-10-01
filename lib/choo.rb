require 'active_record'
require 'pusher'
require 'yaml'


AggregateRecord = ActiveRecord
EventRecord     = ActiveRecord

EventRecord::Base.establish_connection(adapter: 'sqlite3', database: 'THISNEEDSTOCHANGE.db')
AggregateRecord::Base.establish_connection(adapter: 'sqlite3', database: 'THISNEEDSTOCHANGE_2.db')

require 'choo/aggregate'
require 'choo/application'
require 'choo/base_command'
require 'choo/base_event'
require 'choo/event'
require 'choo/repository'
require 'choo/resource'
require 'choo/socket_manager'

module Choo

end


# The aggregate database config are part of app config now but
# will be managed by migrations later on.

require './config/aggregate_database.rb'

# The event database however doesn't have to be managed by the
# user using migrations. 

EventRecord::Schema.define do
  self.verbose = true

  create_table(:Choo_events, force: true) do |t|
    t.string      :event_type,       null: false
    t.text        :serialized_payload,          null: false
    t.string      :aggregate_id,     null: false
    t.datetime    :created_at,       null: false
    t.integer     :version,          null: false
    t.index [:aggregate_id, :version], unique: true
  end

end





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

