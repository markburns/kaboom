require 'kaboom/platform/base'
require 'kaboom/platform/darwin'
require 'kaboom/platform/windows'
require 'kaboom/platform/linux'

module Boom
  class Platform
    class << self
      def platform
        @platform ||= detect_platform.new
      end

      delegate :open, :copy, :to => :platform

      def edit json_file
        if $EDITOR
          platform.edit json_file
        else
          system("#{platform.open_command} #{json_file}")
        end

        "Make your edits, and do be sure to save."
      end

      private
      def detect_platform
        if !!(RUBY_PLATFORM =~ /darwin/)
          Darwin
        elsif !!(RUBY_PLATFORM =~ /mswin|mingw/)
          Windows
        else
          Other
        end
      end
    end
  end
end
