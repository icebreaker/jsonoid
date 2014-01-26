module Jsonoid
  module Document
    module ClassMethods
      def field(name, opts={})
        raise ArgumentError, 'Name must be a Symbol' unless name.is_a? Symbol
        raise ArgumentError, 'Opts must be a Hash' unless opts.is_a? Hash

        self._register_field_accessors(name, opts.delete(:name))
        self.fields << [name, opts.delete(:type) || String, opts.delete(:default)]
      end

      def fields
        @_fields ||= []
      end

      def _register_field_accessors(name, accessor=nil)
        mod = Module.new
        include mod

        accessor = name if accessor.nil?

        mod.class_eval <<-CODE, __FILE__, __LINE__+1
        def #{accessor}
          @_data[:#{name}]
        end

        def #{accessor}?
          !@_data[:#{name}].nil?
        end

        def #{accessor}=(value)
          @_data[:#{name}] = value
        end
        CODE
      end
    end
  end
end
