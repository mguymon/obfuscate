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

class Obfuscate::Config
  attr_accessor :salt, :mode, :encode, :remove_trailing_equal

  def initialize
    # defaults
    @remove_trailing_equal = true
    @encode = true
    @mode = :string
  end

  # Set the mode, enforces that mode should be a Symbol
  def mode=(mode)
    @mode = mode.to_sym
  end
  
  def salt=(salt)
    if salt.length == 0 || salt.length > 56
      raise "Obfuscate salt length must be between 1-56"
    else
      @salt = salt
    end
  end

  # Check if mode is :block and remove_trailing_equal is true
  # @return [Boolean]
  def remove_trailing_equal?
    self.mode == :block && self.remove_trailing_equal == true
  end

  # Creates a new instance of Config with applied changes. Does not change
  # the original Config.
  #
  # @param [Hash] options of configurations
  # @option options [Symbol] :salt A Model specific salt
  # @option options [Symbol] :encode Enable Base64 and URL encoding for this Model. Enabled by default.
  # @option options [Symbol] :remove_trailing_equal When in :block mode, removes the trailing = from the
  #                                                 obfuscated text.
  # @param [Block] blk of configuration, has precedence over options hash.
  # @return [Obfuscate::Config] new instance
  def apply(options = {}, &blk)
    config = self.class.new

    changes = self.to_hash.merge( options )

    config.salt = changes[:salt] unless changes[:salt].nil?
    config.mode = changes[:mode] unless changes[:mode].nil?
    config.encode = changes[:encode] unless changes[:encode].nil?
    config.remove_trailing_equal = changes[:remove_trailing_equal] unless changes[:remove_trailing_equal].nil?


    yield(config) if blk

    config
  end

  # Hash of Config
  # @return [Hash]
  def to_hash
    { :salt => salt, :mode => mode, :encode => encode, :remove_trailing_equal => remove_trailing_equal }
  end
end
