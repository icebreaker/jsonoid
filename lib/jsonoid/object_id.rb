require 'securerandom'

module Jsonoid
  class ObjectId
    class << self
      def parse(id)
        self.new(id)
      end
    end

    def initialize(id=nil)
      if id
        @id = id.to_s
        @new = false

        raise ArgumentError, 'Invalid ObjectId' unless valid?
      else
        @id = SecureRandom.hex
        @new = true
      end
    end

    def valid?  
      @id =~ /[a-z0-9]{32}/
    end

    def new?
      @new
    end

    def ==(id)
      @id == id.to_s
    end

    def !=(id)
      @id != id.to_s
    end

    def <=>(id)
      @id <=> id.to_s
    end

    def to_s
      @id
    end
  end
end
