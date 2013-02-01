
require 'obfuscate/version'

module Obfuscate

  class << self
    attr_accessor :salt
    attr_accessor :options
  end

  self.options = {}
end