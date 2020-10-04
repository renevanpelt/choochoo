require 'active_record'
require 'parametric'

AggregateRecord = ActiveRecord
EventRecord     = ActiveRecord

EventRecord::Base.establish_connection(adapter: 'sqlite3', database: 'THISNEEDSTOCHANGE.db')
AggregateRecord::Base.establish_connection(adapter: 'sqlite3', database: 'THISNEEDSTOCHANGE_2.db')

GEM_DIR = Gem.loaded_specs['choochoo'].gem_dir

require 'choo/aggregate'
require 'choo/application'
require 'choo/base_command'
require 'choo/base_event'
require 'choo/event'
require 'choo/repository'
require 'choo/resource'
require 'choo/socket_manager'

require 'choo/routing_controller'

require 'sinatra/base'

class AdminController < Sinatra::Base

  get "/admin" do 
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/home", {}, "#{GEM_DIR}/views/admin/layout")
  end

  get "/admin/events" do 
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/events", {}, "#{GEM_DIR}/views/admin/layout")
  end

  get "/admin/routes" do 
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/routes", {}, "#{GEM_DIR}/views/admin/layout")
  end

  get "/admin/resources" do 
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/resources", {}, "#{GEM_DIR}/views/admin/layout")
  end


  get "/admin/resources/:resource" do 
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/resource", {resource: params[:resource]}, "#{GEM_DIR}/views/admin/layout")
  end

  get "/admin/resources/:resource/commands/:command_name" do 
    command = "Choo::Resource::#{params[:resource].capitalize}::Command::#{params[:command_name].capitalize.singularize}".constantize
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/command", {resource: params[:resource], command_name: params[:command_name],command: command}, "#{GEM_DIR}/views/admin/layout")
  end

  get "/admin/resources/:resource/events/:event_name" do 
    event = "Choo::Resource::#{params[:resource].capitalize}::Events::#{params[:event_name].capitalize.singularize}".constantize
    Choo::Application.render_template( "#{GEM_DIR}/views/admin/event", {resource: params[:resource], event_name: params[:event_name],event: event}, "#{GEM_DIR}/views/admin/layout")
  end

  post "/admin/resources/:resource/commands/:command_name" do 
    command = "Choo::Resource::#{params[:resource].capitalize}::Command::#{params[:command_name].capitalize.singularize}".constantize
    if params[:aggregate_id]
      aggregate_id = params[:aggregate_id]
    else
      aggregate_id = nil
    end
    command.new(aggregate_id, params).handle.to_json
    # event = "Choo::Resource::#{params[:resource].capitalize}::Events::#{params[:event_name].capitalize.singularize}".constantize
    # Choo::Application.render_template( "#{GEM_DIR}/views/admin/event", {resource: params[:resource], event_name: params[:event_name],event: event}, "#{GEM_DIR}/views/admin/layout")
  end

end

# The aggregate database config are part of app config now but
# will be managed by migrations later on.

require './config/aggregate_database.rb'

# The event database however doesn't have to be managed by the
# user using migrations. 

EventRecord::Schema.define do
  self.verbose = true

  create_table(:choo_events, force: true) do |t|
    t.string      :event_type,       null: false
    t.text        :serialized_payload,          null: false
    t.string      :aggregate_id,     null: false
    t.datetime    :created_at,       null: false
    t.integer     :version,          null: false
    t.index [:aggregate_id, :version], unique: true
  end

end





class AggregateRecord::Base

  def to_param
    uuid
  end
end



module Choo
  class Schema < Parametric::Schema


  end
end