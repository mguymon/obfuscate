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

require 'obfuscate'
require 'crypt/blowfish'
require 'base64'

class Obfuscate::Crypt
  attr_reader :config
  attr_reader :exec_config

  # New instance of Obfuscate::Crypt
  #
  # @param [Obfuscate::Config]
  def initialize(config)
    @crypt = Crypt::Blowfish.new( config.salt )
    @config = config
  end

  # Obfuscate text
  #
  # @param [Symbol] override_mode to explicit set obfuscate mode to :string or :block
  # @return [String]
  def obfuscate(text, override_mode = nil)

    @exec_config = @config.apply(:mode => (override_mode || @config.mode) )

    obfuscated = nil
    if @exec_config.mode == :string
      obfuscated = @crypt.encrypt_string(text)
    elsif @exec_config.mode == :block
      obfuscated = @crypt.encrypt_block(text.to_s.ljust(8))
    else
      raise "Unsupport Mode"
    end

    if @exec_config.encode
      obfuscated = Base64.urlsafe_encode64(obfuscated).strip
      obfuscated = obfuscated.chomp("=") if @exec_config.remove_trailing_equal?
    end

    obfuscated
  end

  # Clarify text
  #
  # @param [Symbol] override_mode to explicit set clarify mode to :string or :block
  # @return [String]
  def clarify( text, override_mode = nil )

    @exec_config = @config.apply( :mode => (override_mode || @config.mode) )
    obfuscated = text.to_s


    if @exec_config.encode
      obfuscated << "=" if @exec_config.remove_trailing_equal?
      obfuscated = Base64.urlsafe_decode64( obfuscated )
    end

    if @exec_config.mode == :string
      @crypt.decrypt_string( obfuscated )
    elsif @exec_config.mode == :block
      @crypt.decrypt_block( obfuscated ).strip
    else
      raise "Unsupport Mode"
    end
  end
end