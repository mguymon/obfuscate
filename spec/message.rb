require 'obfuscate/obfuscatable'

Obfuscate.salt = "default salt"

class Message < ActiveRecord::Base
  obfuscatable
end