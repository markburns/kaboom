class Boom::Platform
  class Other < Base
    def copy item
      super{'xclip -selection clipboard'}
    end

    def open item
      super{|i| "xdg-open '#{i.url.gsub("\'","'\\\\''")}'" }
    end
 end
end
