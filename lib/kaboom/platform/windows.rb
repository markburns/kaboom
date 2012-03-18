class Boom::Platform
  class Windows
    def edit json_file
      super{"start %EDITOR$ "}
    end

    def copy item
      super {'clip'}
    end

    def open item
      system("start #{url_from(item).gsub("\'","'\\\\''")}")
      item.respond_to?(:value) ? item.value : item
    end
  end
end
