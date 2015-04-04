module Transacted  
  class Transaction
    def initialize actions
      raise "Actions must be of type Transacted::Action" if not are_actions? actions
      @actions = actions
    end

    def are_actions? action_or_actions
      [*action_or_actions].all? {|action| action.is_a? Transacted::Action }
    end

    def valid?
      are_actions? @actions
    end

    def execute
      @executed_actions = []
      @actions_left = @actions.clone
      direction = :up
      status = nil
      while direction != nil do
        if direction == :up
          begin
            if @actions_left.count == 0
              direction == nil
              return :execution_success
            end
            action = @actions_left.shift
            action.up
            @executed_actions.push action
          rescue
            direction = :down
          end
        elsif direction == :down
          begin
            if @executed_actions.count == 0
              direction == nil
              return :rollback_success
            end
            action = @executed_actions.pop
            action.down
          rescue
            return :rollback_failure
          end
        end
      end
    end
  end
end
