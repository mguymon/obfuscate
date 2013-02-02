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
require 'obfuscate'

describe Obfuscate do


  it "should setup config by block" do
    Obfuscate.setup do |config|
      config.mode = :block
      config.salt = "salty salt"
    end

    Obfuscate.config.mode.should eql :block
    Obfuscate.config.salt.should eql "salty salt"
  end

  it "should setup config by hash" do
    Obfuscate.setup :salt => 'less salt', :mode => :string

    Obfuscate.config.mode.should eql :string
    Obfuscate.config.salt.should eql "less salt"
  end

  it "should setup config by hash and overriding block" do
    Obfuscate.setup :salt => 'less salt', :mode => :string do |config|
      config.salt = "mega salt"
      config.encode = false
    end

    Obfuscate.config.mode.should eql :string
    Obfuscate.config.salt.should eql "mega salt"
    Obfuscate.config.encode.should eql false
  end

  it "should create Crypt" do
    Obfuscate.setup :salt => 'obfuscate-salt', :mode => :string
    Obfuscate.cryptor.should_not be_nil
  end

  it "should obfuscate and clarify" do
    Obfuscate.setup :salt => 'obfuscate-salt', :mode => :string
    obfuscated = Obfuscate.obfuscate("test obfuscation")
    Obfuscate.clarify(obfuscated).should eql "test obfuscation"
  end

end