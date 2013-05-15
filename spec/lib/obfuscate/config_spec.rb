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
require 'obfuscate/config'

describe Obfuscate::Config do

  it "should have default mode" do
    Obfuscate::Config.new.mode.should eql :string
  end

  it "should have default encode" do
    Obfuscate::Config.new.encode.should be_true
  end

  it "should have default remove_trailing_equal" do
    Obfuscate::Config.new.remove_trailing_equal.should be_true
  end
end