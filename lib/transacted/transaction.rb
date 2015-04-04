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

          if @actions_left.count == 0
            direction == nil
            return :execution_success
          end

          action = @actions_left.shift

          begin
            action_value = action.up
            @executed_actions.push action
            direction = :down if action_value == false
          rescue Exception => e
            direction = :down
          end
          
        elsif direction == :down 

          if @executed_actions.count == 0
            direction == nil
            return :rollback_success
          end

          action = @executed_actions.pop

          begin
            action_value = action.down
            return :rollback_failure if action_value == false
          rescue
            return :rollback_failure
          end
        end
      end
    end
  end
end
