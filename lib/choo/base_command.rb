require 'choo/repository'
require 'choo/event'


# Every command inherits from BaseCommand. Might
# be expanded with CommandThatInitiatesMultipleEvents
# Bij wijze van spreken.
module Choo
  class BaseCommand

    attr_accessor :aggregate_id
    attr_accessor :payload
    attr_accessor :repository

    def self.resource
      self.to_s.split("::")[2]
    end


    def self.creation_command?
      false
    end

    def initialize(aggregate_id, payload)
      self.payload = self.class.schema.resolve(payload).output

      if aggregate_id
        self.repository = Choo::Repository.get_aggregate_from_id(aggregate_id)
      else
        self.repository = Choo::Repository.build_aggregate
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
      "Choo::Resource::#{self.class.to_s.split('::')[2]}::Events::#{self.class.to_s.split('::')[4]}".constantize
    end

    def projected_aggregate
      new_version = event_type.apply_to(repository_aggregate, payload)
    end

    def handle


       Choo::Event.create!(
         event_type: self.event_type,
         serialized_payload: payload.to_json,
         aggregate_id: repository_aggregate.id,
         version: projected_aggregate.version
       )
       return projected_aggregate

    end
    
  end
end