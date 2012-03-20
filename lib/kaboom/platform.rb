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

      delegate :edit, :open, :copy, :to => :platform

      private
      def detect_platform
        if !!(RUBY_PLATFORM =~ /darwin/)
          Darwin
        elsif !!(RUBY_PLATFORM =~ /mswin|mingw/)
          Windows
        else
          Linux
        end
      end
    end
  end
end
