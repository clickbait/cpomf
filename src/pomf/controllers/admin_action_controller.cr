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
  end
end
