require "sticks/pipe/version"

require 'open3'
require 'readline'

module Sticks

  module Pipe
    
    module Blocks
      
      module_function
      
      def capture
        Proc.new { |i,o,t|
          i.close
          result = o.readlines.join("")
          Process.waitpid(t.pid) rescue nil
          result.chomp
        }
      end
    
    
      def stream name = nil
        Proc.new { |i,o,t|
          i.close
          ot = Thread.new{
            while !o.eof?  do
              $stdout.puts(name ? "[#{name}] #{o.gets}" : o.gets)
            end
          }
          ot.abort_on_exception = true
          Process.waitpid(t.pid) rescue nil
          ot.join
          Process.waitpid(t.pid) rescue nil
          t.value #Process::status
        }
      end
    
        
      def interactive
        Proc.new { |i,o,t|
          pid = t.pid
          ot = Thread.new {
            while !o.eof?  do
              $stdout.puts PROMPT + o.gets
            end
          }
          catch :exit do
            while !i.closed? 
              input = Readline.readline(PROMPT, true) 
              i.puts input  
              throw :exit if input == "exit"
            end
          end
          i.close
          ot.join
          t.value #Process::status
        }
      end
    
    end
    
    INTERACTIVE_COMMANDS = /bash|sh|irb|console/
    PROMPT = "> "
    
    def pipe *args, &block
      block = Blocks.capture unless block_given?
      Open3.popen2e(*args,&block)
    end
    
  end
end