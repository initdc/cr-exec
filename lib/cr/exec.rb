# frozen_string_literal: true

require_relative "exec/version"

# https://github.com/initdc/exec/blob/master/src/exec.cr
module Cr
  # https://www.rubydoc.info/stdlib/core/Process.spawn
  # https://www.rubydoc.info/stdlib/core/Process.wait2
  module Exec
    extend self

    def run(...)
      pid, status = Process.wait2(spawn(...))
      status
    end

    def code(...)
      pid, status = Process.wait2(spawn(...))
      status.exitstatus
    rescue Errno::ENOENT
      127
    end

    def output(*args, chomp: true)
      command = args.join(" ")
      output = `#{command}`
      return output.chomp if chomp

      output
    end

    def each_line(*args, chomp: false, **options, &block)
      if block
        IO.popen(*args, **options) do |pipe|
          pipe.each_line(chomp: chomp, &block)
        end
      else
        IO.popen(*args, **options).readlines(chomp: chomp)
      end
    end

    def system?(...)
      system(...) ? true : false
    end
  end
end
