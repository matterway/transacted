module Transacted  
  class Transaction
    def initialize actions
      @actions = actions
    end

    def execute
      @executed_actions = []
      @actions_left = @actions.clone
      direction = :up
      status = 
      while direction != nil do
        if direction == :up
          begin
            if @actions_left.count == 0
              direction == nil
              return true
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
              return false
            end
            action = @executed_actions.pop
            action.down
          rescue
            raise "Rollingback failed !"
          end
        end
      end
      return true
    end
  end
end
