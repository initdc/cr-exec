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

    def output(*args, chomp: true, **options)
      output = IO.popen(*args, **options).read
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

    def answer(*args, input: nil, **options)
      IO.popen(*args, **options) do |pipe|
        if input.is_a? Array
          input.each { |cmd| pipe.puts(cmd) }
        else
           pipe.puts(input)
        end
        pipe.close_write
        pipe.read
      end
    end

    def system?(...)
      system(...) ? true : false
    end
  end
end
