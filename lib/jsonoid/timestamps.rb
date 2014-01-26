require 'date'

module Jsonoid
  module Timestamps
    def update_timestamps
      self.updated_at = Time.now.utc
      self.created_at = self.updated_at if new_record?
    end

    class << self
      def append_features(base)
        super

        base.field :created_at, :type => DateTime
        base.field :updated_at, :type => DateTime
        base.before_save :update_timestamps
      end
    end
  end
end
