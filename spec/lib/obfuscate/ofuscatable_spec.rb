require 'spec_helper'
require 'obfuscate/obfuscatable'
require 'message'

describe Obfuscate::Obfuscatable do

  it "should have salt" do
    Message.obfuscatable_salt.should eql "default salt"
  end

  it "should have obfuscator" do
    Message.obfuscator.should_not be_nil
  end

  it "should obfuscate text" do
    obfuscated = Message.obfuscate( "blah blah blah blah blah blah blah" )
    obfuscated.clarify( obfuscate ).should eql "blah blah blah blah blah blah blah"
  end

  describe "instance" do

    let(:model) do
      model = Message.new
      model.text = "Test"
      model.save

      model
    end

    it "should obfuscate_id" do
      model.obfuscate_id.should_not be nil
    end

    it "should find_by_obfuscated_id" do
      Message.find_by_obfuscated_id( model.obfuscate_id ).should eql model
    end
  end
end