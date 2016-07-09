module Pomf
  class PageController
    include Util::Controller

    def home
      @title = "Weeb File Hosting"

      render "pages/home"
    end

    def register
      if !logged_in_user.nil?
        Util.redirect("/")
      end

      @title = "Sign Up"

      errors = [] of String
      password = email = username = nil

      render "pages/register"
    end

    def login
      if !logged_in_user.nil?
        Util.redirect("/")
      end

      @title = "Sign In"

      errors = [] of String
      password = email = nil

      render "pages/login"
    end

    def about
    end

    def faq
    end

    def contact
    end
  end
end
