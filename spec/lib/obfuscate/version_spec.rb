require 'spec_helper'

describe Obfuscate do
  it "should have VERSION" do
    Obfuscate::VERSION.should_not be_nil
  end
end