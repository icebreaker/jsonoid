module Jsonoid
  module Document
    def trigger(type)
      raise ArgumentError, 'Type must be a Symbol' unless type.is_a? Symbol

      self.class.send("_#{type}_callbacks".to_sym).each do |callback|
        send(callback)
      end
    end

    module ClassMethods
      def validate(callback)
        raise ArgumentError, 'Callback must be a Symbol' unless callback.is_a? Symbol
        self._validate_callbacks << callback
      end

      def validates_presence_of(name, opts={})
        raise ArgumentError, 'Name must be a Symbol' unless callback.is_a? Symbol

        mod = Module.new
        include mod

        callback = "_validates_presence_of_#{name}_callback"

        mod.class_eval <<-CODE, __FILE__, __LINE__+1
        def #{callback}
          errors.add(:field, ":#{name} can't be nil") if @_data[:#{name}].nil?
        end
        CODE

        validate callback.to_sym
      end

      def validates_numericality_of(name, opts={})
        raise ArgumentError, 'Name must be a Symbol' unless callback.is_a? Symbol

        mod = Module.new
        include mod

        callback = "_validates_numeracality_of_#{name}_callback"

        mod.class_eval <<-CODE, __FILE__, __LINE__+1
        def #{callback}
          errors.add(:field, ":#{name} must be numeric") unless @_data[:#{name}].is_a?(Numeric)
        end
        CODE

        validate callback.to_sym
      end

      def before_save(callback)
        raise ArgumentError, 'Callback must be a Symbol' unless callback.is_a? Symbol
        self._before_save_callbacks << callback
      end

      def before_destroy(callback)
        raise ArgumentError, 'Callback must be a Symbol' unless callback.is_a? Symbol
        self._before_destroy_callbacks << callback
      end

      def _validate_callbacks
        @_validate_callbacks ||= []
      end

      def _before_save_callbacks
        @_before_save_callbacks ||= []
      end

      def _before_destroy_callbacks
        @_before_destroy_callbacks ||= []
      end
    end
  end
end
