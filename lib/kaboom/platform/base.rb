class Boom::Platform
  class Base
    def open_file file
      system("#{open_command} #{file}")
    end

    def edit json_file
      if $EDITOR
        if block_given?
          yield
        else
          system "`echo $EDITOR` #{json_file} &"
        end
      else
        open_file json_file
      end

      "Make your edits, and do be sure to save."
    end

    def copy item
      IO.popen(copy_command,"w") {|cc|  cc.write(item.value)}
      item.value
    end
  end
end
