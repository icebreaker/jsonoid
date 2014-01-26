require 'json'

module Jsonoid
  module Document
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    def initialize(data={})
      @_data = {}
      update_attributes(data)
    end

    def id
      @_data[:_id]
    end

    def new_record?
      id.new?
    end

    def update_attributes(data)
      raise ArgumentError, 'Data must be a valid Hash' unless data.is_a? Hash

      data.keys.each do |k|
        data[k.to_sym] = data.delete(k)
      end

      self.class.fields.each do |(name, type, default)|
        value = data.delete(name)

        if value.nil?
          @_data[name] = default ? default.dup : nil
        elsif type < Document
          if value.is_a?(Array) and default.is_a?(Array)
            @_data[name] = value.map do |v|
              v.is_a?(Hash) ? type.new(v) : v
            end
          elsif value.is_a?(Hash)
            @_data[name] = type.new(value)
          else
            @_data[name] = value
          end
        else
          @_data[name] = type.respond_to?(:parse) ? type.parse(value) : value
        end
      end

      if @_data[:id].nil?
        @_data[:_id] = ObjectId.parse(data[:_id])
      else
        save
      end
    end

    def errors
      @errors ||= Errors.new
    end

    def save
      errors.clear!

      trigger(:validate)
      return false if errors.any?

      trigger(:before_save)
      self.class.collection.write(id, @_data.to_json)

      true
    rescue NotPersisted => e
      errors.add(:id, e.message)
      false
    end

    def destroy
      errors.clear!

      trigger(:before_destroy)
      self.class.collection.delete(id)

      true
    rescue NotFound => e
      errors.add(:id, e.message)
      false
    end

    def to_hash
      @_data.to_hash
    end

    def to_s
      @_data.to_s
    end

    def to_json(*args)
      @_data.to_json(*args)
    end

    class Scope
      def initialize(type, collection)
        @type = type
        @collection = collection
      end

      def each
        @collection.each do |data|
          yield @type.parse(data)
        end
      end
    end

    module ClassMethods
      def find(id)
        parse(collection.read(id))
      rescue NotFound
        nil
      end

      def all
        Scope.new(self, collection)
      end

      def parse(json)
        new(JSON.parse(json))
      end
    end
  end
end
