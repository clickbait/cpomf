module Pomf
  class UserController
    include Util::Controller

    def do_login
      email = Util::Validations.email(params["email"])
      password = Util::Validations.password(params["password"])

      errors = [] of String

      if !email
        errors << "Email is invalid."
      end

      if !password
        errors << "Password is invalid."
      end

      if errors.empty?
        user = Models::User.where("email = $1", [email])

        if user.nil?
          errors << "Email or Password does not match."
        else
          if user.password != password.not_nil!
            errors << "Email or Password does not match."
          end
        end
      end

      if errors.empty? && !user.nil?
        token = JWT.encode({ "id" => user.id, "username" => user.username }, ENV["POMF_SECRET_KEY"], "HS256")

        cookies = HTTP::Cookies.new
        cookies << HTTP::Cookie.new("auth", token)
        cookies.add_response_headers(context.response.headers)

        Util.redirect("/")
      else
        render "pages/login"
      end
    end

    def do_register
      username = Util::Validations.username(params["username"])
      email = Util::Validations.email(params["email"])
      password = Util::Validations.password(params["password"])

      errors = [] of String

      if !username
        errors << "Username is invalid."
      else
        Pomf.db.connection do |db|
          count = db.exec("SELECT FROM users WHERE username = $1", [username]).rows.size

          if count > 0 #|| blacklist.includes?(username)
            errors << "Username is already taken."
          end
        end
      end

      if !email
        errors << "Email is invalid."
      else
        Pomf.db.connection do |db|
          count = db.exec("SELECT FROM users WHERE email = $1", [email]).rows.size

          if count > 0
            errors << "Email is already in use."
          end
        end
      end

      if !password
        errors << "Password is invalid."
      end

      if errors.empty?
        user = Models::User.new(username.not_nil!, password.not_nil!, email.not_nil!).create!
        Util.redirect("/")
      else
        render "pages/register"
      end

    end
  end
end
