

# The in-memory aggregate state is managed by a repository.
# I'm not merried to the term 'repository', just copied 
# stuff I saw in examples and talks.
module Choo
  class Repository

    attr_accessor :id
    attr_accessor :events
    attr_accessor :aggregate

    def initialize(id = nil)
      if id
        self.id = id
        self.events = Choo::Event.where(aggregate_id: id).map{|a| a}.sort{|a,b| a.version <=> b.version }
        self.aggregate = Choo::Aggregate.build(self.id, self.events)
      else
        self.id = SecureRandom.uuid
        self.events = []
        self.aggregate = Choo::Aggregate.new(self.id)
      end
    end

    def self.get_aggregate_from_id(id)
      Choo::Repository.new(id)
    end

    def self.build_aggregate
      Choo::Repository.new
    end
  end
end