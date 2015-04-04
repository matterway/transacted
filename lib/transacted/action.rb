module Transacted
  class Action
    def initialize options
      raise "Must be initialized with procs" if not are_procs? [options[:up], options[:down]]
      @up = options[:up]
      @down = options[:down]
    end

    def up
      return @up.call
    end

    def down
      return @down.call
    end

    def valid?
      are_procs? [@up,@down]
    end

    def are_procs? proc_or_procs
      procs = [*proc_or_procs]
      procs.all? { |proc| proc.is_a?(Proc)}
    end
  end
end