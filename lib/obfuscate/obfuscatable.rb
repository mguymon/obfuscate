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

require 'obfuscate/crypt'

module Obfuscate
  module Obfuscatable
    extend ActiveSupport::Concern

    module ClassMethods

      # Make this Model Obfuscatable. Adds method obfuscate_id which obfuscates the id to 11 characters.
      # Cavaet: Only supports id lengths up to 8 (e.g. 99,999,999) due to use of Blowfish block encryption.
      #
      # @params [Hash] options to override the default config
      # @option options [Symbol] :salt A Model specific salt
      # @option options [Symbol] :encode Enable Base64 and URL encoding for this Model. Enabled by default.
      # @option options [Symbol] :remove_trailing_equal When in :block mode, removes the trailing = from the
      #                                                 obfuscated text.
      def obfuscatable(options = {})
        config = Obfuscate.config.apply(options)

        cattr_accessor :obfuscatable_config
        self.obfuscatable_config = config

        cattr_accessor :obfuscatable_crypt
        self.obfuscatable_crypt = Obfuscate::Crypt.new( config )

        define_method :obfuscated_id do
          self.obfuscatable_crypt.obfuscate( self.id, :block )
        end

        define_method :clarify_id do |text|
          self.class.clarify_id( text )
        end

        class << self

          # Find by obfuscated_id
          #
          # @return [Object]
          def find_by_obfuscated_id( text )
            find_by_id( clarify_id( text ) )
          end

          # Clarifies obfuscated Model id
          # @return [String]
          def clarify_id( text )
            self.obfuscatable_crypt.clarify( text, :block )
          end

          # Clarify obfuscated text.
          #
          # @param [String] text to clarify
          # @param [Symbol] mode to clarify, defaults to :string
          def clarify( text, mode = :string)
            self.obfuscatable_crypt.clarify(text, mode)
          end

          #
          # @param [String] text to clarify
          # @param [Symbol] mode to clarify, defaults to :string
          def obfuscate( text, mode = :string)
            self.obfuscatable_crypt.obfuscate(text, mode)
          end
        end
      end
    end

  end
end

ActiveRecord::Base.send :include, Obfuscate::Obfuscatable