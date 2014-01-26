require 'fileutils'

module Jsonoid
  module Document
    class NotFound < StandardError; end
    class NotPersisted < StandardError; end

    module ClassMethods
      def store_in(name)
        raise ArgumentError, 'Name must be a Symbol' unless name.is_a? Symbol
        collection(name).exists?
      end

      def collection(name=nil)
        @_collection = nil unless name.nil?
        @_collection ||= Jsonoid::Collection.new(name || self.name.downcase + 's')
      end
    end
  end

  class Collection
    EXTENSION = 'json'

    def initialize(name)
      @collection = File.join(Jsonoid.db, name)
      FileUtils.mkdir_p(@collection)
    rescue Errno::ENOENT, Errno::EACCES
      # FIXME: add a warning message or abort?
    end

    def exists?
      File.directory?(@collection)
    end

    def each
      Dir.glob(document('*')) do |fname|
        yield File.read(fname)
      end
    rescue Errno::ENOENT, Errno::EACCES
      # FIXME
    end

    def write(id, data)
      open(document(id), 'w') { |f| f.write(data) }
    rescue Errno::ENOENT, Errno::EACCES
      raise Document::NotPersisted, "Document #{id} not persisted"
    end

    def read(id)
      File.read(document(id))
    rescue Errno::ENOENT, Errno::EACCES
      raise Document::NotFound, "Document #{id} not found"
    end

    def delete(id)
      File.delete(document(id))
    rescue Errno::ENOENT, Errno::EACCES
      raise Document::NotFound, "Document #{id} not found"
    end

    private

    def document(id)
      File.join(@collection, [id, EXTENSION].join('.'))
    end
  end
end
