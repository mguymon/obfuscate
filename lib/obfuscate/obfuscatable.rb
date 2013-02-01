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

    included do
    end

    module ClassMethods
      def obfuscatable(options = {})
        opts = Obfuscate.options.merge(options)

        cattr_accessor :obfuscatable_salt
        self.obfuscatable_salt = (opts.delete(:salt) || Obfuscate.salt ).to_s

        cattr_accessor :obfuscator
        self.obfuscator = Obfuscate::Crypt.new( self.obfuscatable_salt, opts )
      end

      def find_by_obfuscated_id( text )
         find_by_id( clarify_id( text ) )
      end

      def clarify_id( text )
        self.obfuscator.clarify( text, :block )
      end

      def clarify( text, mode = :string)
        self.obfuscator.clarify(text, mode)
      end

      def obfuscate( text, mode = :string)
        self.obfuscator.obfuscate(text, mode)
      end
    end

    def obfuscate_id
      self.obfuscator.obfuscate( self.id, :block )
    end

  end
end

ActiveRecord::Base.send :include, Obfuscate::Obfuscatable