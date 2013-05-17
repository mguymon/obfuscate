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
require 'obfuscate/obfuscatable'

describe Obfuscate::Obfuscatable do

  it "should give a hoot and not pollute" do
    ActiveRecord::Base.method_defined?( :find_by_obfuscated_id ).should be_false
    ActiveRecord::Base.method_defined?( :find_obfuscated ).should be_false
  end

  it "should have appended salt" do
    Message.obfuscatable_config.salt.should eql "Test Salt--Message--"
  end

  it "should have crypt" do
    Message.obfuscatable_crypt.is_a?( Obfuscate::Crypt ).should be_true
  end

  it "should obfuscate text" do
    obfuscated = Message.obfuscate( "blah blah blah blah blah blah blah" )
    Message.clarify( obfuscated ).should eql "blah blah blah blah blah blah blah"
  end

  describe "instance" do

    let(:model) do
      model = Message.new
      model.text = "Test"
      model.save

      model
    end

    it "should obfuscated id" do
      model.obfuscated_id.should_not be nil
    end

    it "should clarify id" do
      model.clarify_id( model.obfuscated_id ).to_i.should eql model.id
    end

    it "should ignore bad obfuscated id" do
      model.clarify_id( 7 ).should be_nil
      model.clarify_id( "!@#$@%@#%@^%" ).should be_nil
    end

    it "should find_by_obfuscated_id" do
      Message.find_by_obfuscated_id( model.obfuscated_id ).should eql model
    end

    it "should find_obfuscated" do
      Message.find_obfuscated(model.obfuscated_id).should eql model
    end

    it "raises ActiveRecord::RecordNotFound retreiving a not existing model" do
      expect { Message.find_obfuscated('NOT_EXIST') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end

Obfuscate.config.salt = "Test Salt"
class Message < ActiveRecord::Base
  obfuscatable :append_salt => "--Message--"
end