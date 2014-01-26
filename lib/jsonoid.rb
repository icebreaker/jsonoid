require 'jsonoid/object_id'
require 'jsonoid/errors'
require 'jsonoid/callbacks'
require 'jsonoid/fields'
require 'jsonoid/collection'
require 'jsonoid/document'
require 'jsonoid/timestamps'

module Jsonoid
  class << self
    attr_accessor :db

    def configure
      yield self
    end
  end
end
