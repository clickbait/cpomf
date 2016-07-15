module Pomf
  class AdminActionController
    include Util::AdminController

    def users_edit
      slug = Util::Validations.username(params["slug"])

      if slug.nil?
        Util.redirect("/admin/users")
      end

      user = Models::User.where("username = $1", [slug])

      if user.nil?
        Util.redirect("/admin/users")
      end

      if !params["password"].empty?
        password = params["password"]
      else
        password = nil
      end

      errors = Util.validate(params["email"], password, params["username"], user.id)

      @title = "Editing #{user.username}"

      if !errors.empty?
        render "admin/users/edit"
      else
        puts params["username"]
        user.username = params["username"].downcase
        user.email = params["email"].downcase
        if !params["password"].empty?
          user.password = params["password"]
        end

        user.save

        Util.redirect("/admin/users")
      end
    end

    def pages_new
      if !params["title"].nil?
        page = Models::Page.new(params["title"], params["content"])

        page.create!
      end

      Util.redirect("/admin/pages")
    end

    def pages_edit
      slug = params["slug"].to_slug

      if slug.empty?
        Util.redirect("/admin/pages")
      end

      errors = [] of String

      page = Models::Page.where("slug = $1", [slug])

      page.title = params["title"]
      page.content = params["content"]

      page.save

      Util.redirect("/admin/pages")
    end
  end
end
