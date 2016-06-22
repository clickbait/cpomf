module Pomf
  class PageController
    include Util::Controller

    def home
      @title = "Weeb File Hosting"
      render "pages/home"
    end
  end
end
