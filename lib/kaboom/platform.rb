require 'kaboom/platform/base'
require 'kaboom/platform/darwin'
require 'kaboom/platform/windows'
require 'kaboom/platform/other'

module Boom
  class Platform
    class << self
      def platform
        @platform ||=
          begin
            if !!(RUBY_PLATFORM =~ /darwin/)
              Darwin.new
            elsif !!(RUBY_PLATFORM =~ /mswin|mingw/)
              Windows.new
            else
              Other.new
            end
          end
      end

      delegate :open, :copy, :to => :platform

      def edit json_file
        if $EDITOR
          platform.edit json_file
        else
          platform.open json_file
        end

        "Make your edits, and do be sure to save."
      end
    end
  end
end
