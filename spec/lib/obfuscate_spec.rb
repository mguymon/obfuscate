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

  it "should clarify existing obfuscated values" do
    Obfuscate.setup :salt => 'obfuscate-salt', :mode => :string
    vals = ["7a2b9e943dc32807285f4cc5e14dfb9f", "cda78d5b2ff68c1af37ed567940eaf47", "c4a175a114b3505761ffb7647e9ab5fd", "6fb25b22c552e9e0fcaa6608418de636", "f7fcbd31a844639edf16c349ce5f51f5", "a8f5535b956fea220a8cfa1127f1746f", "fef14ce49f1027ffcae3f0139e44b3f6", "17ce584c4beb2b05630970588aa296c0", "fd81080b3f5ee8b92f97c5a4ec8bba68", "fbea19fa974d59b3d3d2e8b76ee073ba"]
    obfuscated = ["1UcIzpT8OYg1DRp3U2KJhFc4G0MFlFgMQUy93DHsz2JpjHmqTGANUUt0G8tbao_a", "1UcIzpT8OYhDPRmTdlV55HIb6bqZcTYDdyaGqTLplNhTxmkEaO_5iDzjoDYt0l_O", "1UcIzpT8OYhGb9w6jFBCJsJHCyv94Dk4DNLIDRJ4A0mxpkBs_BqAPU2MgVNI5g1k", "1UcIzpT8OYheLeZhqOq4G5b4FAjmksim0z5oSuhroRq8AM-iEjiQ1-wS7Bk8layP", "1UcIzpT8OYj0bVYbRaDtV3BD56w9rBoxQK_Rqf-gPjZqh0t3mhSoxTQIjxPEsT9K", "1UcIzpT8OYhreXIwqINLguTO1fEWY23RbbaT3RRmLqTreZTIFBuOl0lFqijoDaUM", "1UcIzpT8OYisoIwsozOMRh4W7mvhWE_Mf5yUi2TO0OLn1MGxXnB5qR2B9sgIoKsk", "1UcIzpT8OYhX9QBNegug7SzXYbutpemeij-GonXITIHSGgO8yV1QkATuqegIkJZp", "1UcIzpT8OYjJkj8IJyYAm0bUsHDHt4xn3qSpPeVm_G2u9Ow9ZNkmUjHnegJOlOyZ", "yJKFWD2DdQIg7pZmVjrMZdcplGmqbU7iwmuY54X4nn-9fnGuEOg_9hjyqR7gPce8"]

    obfuscated.size.times.each do |x|
      Obfuscate.clarify(obfuscated[x]).should eql vals[x]
    end
  end

end