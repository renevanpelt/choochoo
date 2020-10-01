


# This is the activerecord (EventRecord) class that 
# we TEMPORARILY use to push events to websockets

# We need a system to standardize "what happens"
# when events are added to the history and how side
# effects are 1) initiated and 2) managed.
# Side effects should never be called more than once
# after all right?

module Choo
  class Event < EventRecord::Base

    self.table_name = "Choo_events"

    before_create :set_created_at
    after_create :push_event  

    def set_created_at
      self.created_at = Time.now
    end


    def push_event
      aggregate = event_type.constantize.new.perform(self)
      if event_type.constantize.publish_to

        SocketManager.make.trigger(aggregate.send(event_type.constantize.publish_to).to_param, event_type, {
          aggregate_id: aggregate_id,
          payload: payload,
        })
      end
    end

    def payload
      JSON.parse(serialized_payload)
    end

  end
end
