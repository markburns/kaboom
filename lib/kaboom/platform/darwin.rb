class Boom::Platform
  class Darwin < Base
    def copy_command
      'pbcopy'
    end

    def open item
      system("#{open_command} '#{item.url.gsub("\'","'\\\\''")}'")
      item.value
    end

    def open_command
      "open"
    end
  end
end
