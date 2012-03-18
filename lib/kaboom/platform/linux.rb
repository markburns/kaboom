class Boom::Platform
  class Linux < Base
    def copy_command
      'xclip -selection clipboard'
    end

    def open item
      system "#{open_command} '#{item.url.gsub("\'","'\\\\''")}'"
    end

    def open_command
      "xdg-open"
    end
  end
end
