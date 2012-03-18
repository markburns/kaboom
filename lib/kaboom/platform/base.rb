class Boom::Platform
  class Base
    def edit json_file
      system("#{yield} #{json_file}")
    end

    def copy item
      IO.popen(yield,"w") {|cc|  cc.write(item.value)}
      item.value
    end

    def open item
      system(yield item)
      item.respond_to?(:value) ? item.value : item
    end

    def url_from item
      if item.respond_to?(:url)
        item.url
      else
        item
      end
    end
  end
end
