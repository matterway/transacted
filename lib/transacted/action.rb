module Transacted
  class Action
    def initialize options
      @up = options[:up]
      @down = options[:down]
    end

    def up
      return @up.call
    end

    def down
      return @down.call
    end
  end
end