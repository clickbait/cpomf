module Pomf
  class PageController
    include Util::Controller

    def home
      @title = "Weeb File Hosting"
      render "pages/home"
    end

    def about
    end

    def faq
    end

    def contact
    end
  end
end
