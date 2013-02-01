require 'obfuscate'
require 'crypt/blowfish'
require "base64"

class Obfuscate::Crypt
  def initialize( salt, opts = {} )
    @opts = { :remove_trailing_equal => true, :encode => true, :mode => :string }.merge( opts )
    @crypt = Crypt::Blowfish.new( salt )

    @mode =  @opts[:mode].to_sym
  end

  def obfuscate( text, mode = nil )

    mode = mode || @mode

    obfuscated = nil
    if mode == :string
      obfuscated = @crypt.encrypt_string(text)
    elsif mode == :block
      obfuscated = @crypt.encrypt_block(text.to_s.ljust(8))
    else
      raise "Unsupport Mode"
    end

    if @opts[:encode]
      obfuscated = URI.escape(Base64.strict_encode64(obfuscated).strip)
      obfuscated = obfuscated.chomp("=") if mode == :block && @opts[:remove_trailing_equal]
    end

    obfuscated
  end

  def clarify( text, mode = nil )

    mode = mode || @mode
    obfuscated = text.to_s


    if @opts[:encode]
      obfuscated << "=" if mode == :block && @opts[:remove_trailing_equal]
      obfuscated = Base64.strict_decode64( URI.unescape(obfuscated) )
    end

    if mode == :string
      @crypt.decrypt_string( obfuscated )
    elsif mode == :block
      @crypt.decrypt_block( obfuscated ).strip
    else
      raise "Unsupport Mode"
    end
  end
end