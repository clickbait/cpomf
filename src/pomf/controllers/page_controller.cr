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

    def pages
      slug = params["slug"].to_slug

      if slug.empty?
        Util.redirect("/")
        # TODO: replace with 404
      end

      page = Models::Page.where("slug = $1", [slug])

      @title = page.title

      render "pages/page"
    end
  end
end
