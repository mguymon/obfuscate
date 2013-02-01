require 'spec_helper'
require 'obfuscate/crypt'
require 'crypt/blowfish'
require "base64"

describe Obfuscate::Crypt do

  describe "obfuscate block mode" do
    it "should obfuscate" do
      crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :block,  :mode => :block)
      crypt.obfuscate("test123").should eql "3NINgAbOhPc"
    end

    it "should obfuscate including the equality" do
      crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :block, :remove_trailing_equal => false)
      crypt.obfuscate("test123").should eql "3NINgAbOhPc="
    end

    it "should obfuscate without encoding" do
      crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :block, :encode => false)
      crypt.obfuscate("test123").should eql "\xDC\xD2\r\x80\x06\xCE\x84\xF7"
    end

    it "should be able to override mode" do
      crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :string )
      crypt.obfuscate("test123", :block).should eql "3NINgAbOhPc"
    end
  end

  describe "obfuscate string mode" do
    it "should obfuscate" do
      crypt = Obfuscate::Crypt.new( "salt-salt-salt")
      #crypt.obfuscate("test12345678").should eql ""
      crypt.clarify( crypt.obfuscate("test12345678") ).should eql "test12345678"
    end

    it "should clarify previously obfuscated text" do
      crypt = Obfuscate::Crypt.new( "salt-salt-salt")
      crypt.clarify( "j65H1jCTYh2uw/lsHweLXMw50aaENXYI" ).should eql "test12345678"
      crypt.clarify( "4bxm/ijHwq1ekPBYEGFsr+LuJ8EZVa57" ).should eql "test12345678"
      crypt.clarify( "y2D0gT8x3llEToou6PPbKRagVYX1NeVc" ).should eql "test12345678"
      crypt.clarify( "T/graYvZiWE585V9fkJ5HAj1wyOothyo" ).should eql "test12345678"
    end


    it "should be able to override mode" do
      crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :block )

      # such a weak spec, but the encrypted string will not be the same every time
      crypt.obfuscate("test123", :string).should_not eql "3NINgAbOhPc"
    end
  end

  describe "clarify" do

    it "should clarify" do
      crypt = Obfuscate::Crypt.new( "salt-salt")
      enc = crypt.obfuscate("test123456test123456test123456test123456")
      crypt.clarify(enc).should eql "test123456test123456test123456test123456"
    end

    it "should be able to override mode" do
      crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :string )
      crypt.clarify( crypt.obfuscate("test123", :block), :block ).should eql "test123"
    end

    describe "block mode" do
      it "will trim text larger than 8 characters" do
        crypt = Obfuscate::Crypt.new( "salt-salt", :mode => :block)
        enc = crypt.obfuscate("1234567890")
        crypt.clarify(enc).should eql "12345678"
      end
    end
  end
end