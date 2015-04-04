require "spec_helper"
require "transacted"

describe Transacted::Action do
  it "is initialized with an options object" do
    options = {
      up: -> { puts "up" },
      down: -> { puts "down" }
    }
    action = Transacted::Action.new options
    expect(action.valid?).to eq true
  end

  it "should throw when initialized with non procs options" do
    options = {
      up: "abc",
      down: 123
    }
    expect{Transacted::Action.new options}.to raise_error
  end

  it "should execute up method" do
    result = false
    options = {
      up: -> { result = true },
      down: -> { puts "down" }
    }
    action = Transacted::Action.new options
    action.up
    expect(result).to eq true
  end

  it "should execute down method" do
    result = false
    options = {
      up: -> { puts "up" },
      down: -> { result = true }
    }
    action = Transacted::Action.new options
    action.down
    expect(result).to eq true
  end
end