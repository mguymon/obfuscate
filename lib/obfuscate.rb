# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements. See the NOTICE file distributed with this
# work for additional information regarding copyright ownership. The ASF
# licenses this file to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.


require 'obfuscate/version'
require 'obfuscate/crypt'
require 'obfuscate/config'

module Obfuscate

  class << self
    attr_accessor  :config

    # Obfuscate text. Depends on Obfuscate.setup to be called first
    #
    # @param [String] text to be obfuscated
    # @param [Hash] options overrides how obfuscation should be handled
    # @return [String]
    def obfuscate(text, options = {} )
      cryptor( options ).obfuscate( text )
    end

    # Clarify obfuscated text. Depends on Obfuscate.setup to be called first
    #
    # @param [String] text to be clarified
    # @param [Hash] options overrides how clarify should be handled
    # @return [String]
    def clarify(text, options = {} )
      cryptor( options ).clarify( text )
    end

    # Create instance of Obfuscate::Crypt. Depends on Obfuscate.setup to be called first
    #
    # @param [Hash] overrides how instance should be created
    # @return [Obfuscate::Crypt]
    def cryptor(options = {} )
      Obfuscate::Crypt.new( @config.apply( options ) )
    end

    # Setup Obfuscate passing in a hash and/or block
    #
    # @param [Hash] options of configurations
    # @option options [Symbol] :salt A Model specific salt
    # @option options [Symbol] :encode Enable Base64 and URL encoding for this Model. Enabled by default.
    # @option options [Symbol] :remove_trailing_equal When in :block mode, removes the trailing = from the
    #                                                 obfuscated text.
    # @param [block] blk of configuration, has precedence over options Hash.
    # @return [Obfuscate::Config]
    def setup(options ={}, &blk)
      @config = @config.apply(options, &blk)
    end
  end

  self.config = Obfuscate::Config.new
end