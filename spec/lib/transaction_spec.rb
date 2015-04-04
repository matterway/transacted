require "spec_helper"
require "transacted"

describe Transacted::Transaction do
  it "should be initialized with an array of actions" do
    options = {
      up: -> { puts "up_1" },
      down: -> { puts "down_1" }
    }
    action_1 = Transacted::Action.new options
    options = {
      up: -> { puts "up_2" },
      down: -> { puts "down_2" }
    }
    action_2 = Transacted::Action.new options
    transaction = Transacted::Transaction.new [action_1, action_2]
    expect(transaction.valid?).to eq(true)
  end

  it "should throw if initialized with non Transacted::Action type objects" do
    expect{Transacted::Transaction.new [123, "abc"]}.to raise_error
  end

  it "should execute the actions used to initialize it" do
    result = 0
    options = {
      up: -> { result += 1 },
      down: -> { puts "down_1" }
    }
    action_1 = Transacted::Action.new options
    options = {
      up: -> { result += 2 },
      down: -> { puts "down_2" }
    }
    action_2 = Transacted::Action.new options
    transaction = Transacted::Transaction.new [action_1, action_2]
    transaction.execute
    expect(result).to eq 3
  end

  it "should return :execution_success if execution succeeds" do
    result = 0
    options = {
      up: -> { result += 1 },
      down: -> { puts "down_1" }
    }
    action_1 = Transacted::Action.new options
    options = {
      up: -> { result += 2 },
      down: -> { puts "down_2" }
    }
    action_2 = Transacted::Action.new options
    transaction = Transacted::Transaction.new [action_1, action_2]
    expect(transaction.execute).to eq :execution_success
  end

  it "should rollback if an error is raised during it's execution" do
    result = 0
    options = {
      up: -> { result += 1 },
      down: -> { result -= 1 }
    }
    action_1 = Transacted::Action.new options
    options = {
      up: -> {
        raise "Random error"
      },
      down: -> { result -= 2 }
    }
    action_2 = Transacted::Action.new options
    transaction = Transacted::Transaction.new [action_1, action_2]
    transaction.execute
    expect(result).to eq 0
  end

  it "should return :rollback_success if the execution fails" do
    result = 0
    options = {
      up: -> { result += 1 },
      down: -> { result -= 1 }
    }
    action_1 = Transacted::Action.new options
    options = {
      up: -> {
        raise "Random error"
      },
      down: -> { result -= 2 }
    }
    action_2 = Transacted::Action.new options
    transaction = Transacted::Transaction.new [action_1, action_2]
    expect(transaction.execute).to eq :rollback_success
  end

  it "should return :rollback_failure on execution if the rollback fails" do
    result = 0
    options = {
      up: -> { result += 1 },
      down: -> {
        raise "Another random error"
      }
    }
    action_1 = Transacted::Action.new options
    options = {
      up: -> {
        raise "Random error"
      },
      down: -> { result -= 2 }
    }
    action_2 = Transacted::Action.new options
    transaction = Transacted::Transaction.new [action_1, action_2]
    expect(transaction.execute).to eq :rollback_failure
  end
end