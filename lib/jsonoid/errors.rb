module Jsonoid
  module Document
    class Errors
      def initialize
        clear!
      end

      def blank?
        @errors.empty?
      end

      def add(type, message)
        @errors << [type, message]
      end

      def clear!
        @errors = []
      end

      def method_missing(name, *args, &block)
        if name =~ /^(any?|empty?|each|map|select|detect|find)/
          @errors.send(name, *args, &block)
        else
          super
        end
      end
    end
  end
end
