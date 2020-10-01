module Choo
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
