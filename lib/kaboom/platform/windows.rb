class Boom::Platform
  class Windows
    def edit json_file
      super { system "start %EDITOR$ #{json_file}" }
    end

    def copy_command
      'clip'
    end

    def open item
      system("#{open_command} #{item.url.gsub("\'","'\\\\''")}")
      item.value
    end

    def open_command
      "start"
    end
  end
end
