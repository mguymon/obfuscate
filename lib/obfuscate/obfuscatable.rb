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