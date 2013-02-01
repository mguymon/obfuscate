require 'spec_helper'

require 'obfuscate'

describe Obfuscate do

  it "should set salt" do
    Obfuscate.salt = "test"
    Obfuscate.salt.should eql "test"
  end

end