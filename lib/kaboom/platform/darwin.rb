class Boom::Platform
  class Darwin < Base
    def edit json_file
      system "`echo $EDITOR` #{json_file} &"
    end

    def copy item
      super {'pbcopy'}
    end

    def open item
      system("open '#{url_from(item).gsub("\'","'\\\\''")}'")
      item.value
    end
  end
end
