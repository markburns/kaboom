class Boom::Platform
  class Base
    def edit json_file
      system "`echo $EDITOR` #{json_file} &"
    end

    def copy item
      IO.popen(copy_command,"w") {|cc|  cc.write(item.value)}
      item.value
    end
 end
end
