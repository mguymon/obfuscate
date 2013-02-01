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
    Message.clarify( obfuscated ).should eql "blah blah blah blah blah blah blah"
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