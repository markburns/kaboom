class Boom::Platform
  class Base
    def open_file file
      system("#{open_command} #{file}")
    end

    def edit json_file
      if $EDITOR
        return yield if block_given?

        system "`echo $EDITOR` #{json_file} &"
      else
        open_file json_file
      end
    end

    def copy item
      IO.popen(copy_command,"w") {|cc|  cc.write(item.value)}
      item.value
    end
  end
end
