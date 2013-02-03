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

require 'spec_helper'
require 'obfuscate/crypt'
require 'crypt/blowfish'
require 'base64'

describe Obfuscate::Crypt do

  describe "obfuscate block mode" do
    before(:each) do
      @config = Obfuscate::Config.new.tap do |config|
        config.salt = "salt-salt-salt"
        config.mode = :block
      end
    end

    it "should obfuscate" do
      crypt = Obfuscate::Crypt.new( @config )
      crypt.obfuscate("test123").should eql "R35tG3YxSQk"
    end

    it "should obfuscate including the equality" do
      crypt = Obfuscate::Crypt.new( @config.apply(:remove_trailing_equal => false) )
      crypt.obfuscate("test123").should eql "R35tG3YxSQk="
    end

    it "should obfuscate without encoding" do
      @config.encode.should be_true
      crypt = Obfuscate::Crypt.new( @config.apply(:encode => false ) )
      @config.encode.should be_true
      crypt.obfuscate("without encoding").should eql "\x8F\xC7\xE4\n,2\xA2\xA7"
    end

    it "should be able to override mode" do
      crypt = Obfuscate::Crypt.new( @config.apply( :mode => :string ) )
      crypt.obfuscate("test123", :block).should eql "R35tG3YxSQk"
    end
  end

  describe "obfuscate string mode" do
    before(:each) do
      @config = Obfuscate::Config.new.tap do |config|
        config.salt = "salt-salt-salt"
        config.mode = :string
      end
    end

    it "should obfuscate" do
      crypt = Obfuscate::Crypt.new( @config )
      #crypt.obfuscate("test12345678").should eql ""
      crypt.clarify( crypt.obfuscate("test12345678") ).should eql "test12345678"
    end

    it "should clarify previously obfuscated text" do
      crypt = Obfuscate::Crypt.new( @config )
      crypt.clarify( "j65H1jCTYh2uw/lsHweLXMw50aaENXYI" ).should eql "test12345678"
      crypt.clarify( "4bxm/ijHwq1ekPBYEGFsr+LuJ8EZVa57" ).should eql "test12345678"
      crypt.clarify( "y2D0gT8x3llEToou6PPbKRagVYX1NeVc" ).should eql "test12345678"
      crypt.clarify( "T/graYvZiWE585V9fkJ5HAj1wyOothyo" ).should eql "test12345678"
    end


    it "should be able to override mode" do
      crypt = Obfuscate::Crypt.new( @config.apply( :mode => :block ) )

      # such a weak spec, but the encrypted string will not be the same every time
      crypt.obfuscate("test123", :string).should_not eql "3NINgAbOhPc"
    end
  end

  describe "clarify" do
    before(:each) do
      @config = Obfuscate.setup do |config|
        config.salt = "salt-salt-salt"
        config.mode = :string
      end
    end

    it "should clarify" do
      crypt = Obfuscate::Crypt.new( @config )
      enc = crypt.obfuscate("test123456test123456test123456test123456")
      crypt.clarify(enc).should eql "test123456test123456test123456test123456"
    end

    it "should be able to override mode" do
      crypt = Obfuscate::Crypt.new( @config )
      crypt.clarify( crypt.obfuscate("test123", :block), :block ).should eql "test123"
    end

    describe "block mode" do
      it "will trim text larger than 8 characters" do
        crypt = Obfuscate::Crypt.new( @config.apply( :mode => :block ) )
        enc = crypt.obfuscate("1234567890")
        crypt.exec_config.mode.should eql :block

        crypt.clarify(enc).should eql "12345678"
      end
    end
  end
end