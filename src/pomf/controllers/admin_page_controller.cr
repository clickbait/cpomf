module Pomf
  class AdminPageController
    include Util::AdminController

    def dashboard
      @title = "Dashboard"

      render "admin/dashboard"
    end

    def users
      @title = "Users"

      users = Models::User.where_multi("1=1")

      render "admin/users"
    end

    def users_edit
      username = Util::Validations.username(params["slug"])

      if username.nil?
        Util.redirect("/admin/users")
      end

      user = Models::User.where("username = $1", [username])

      if user.nil?
        Util.redirect("/admin/users")
      end

      errors = [] of String

      @title = "Editing #{user.username}"

      render "admin/users/edit"
    end
  end
end
