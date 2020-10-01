
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
module Choo
  class Aggregate

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
end