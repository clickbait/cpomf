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
        user = Models::User.where("lower(email) = $1", [email.not_nil!.downcase])

        if user.nil?
          errors << "Email or Password does not match."
        else
          if user.password != password.not_nil!
            errors << "Email or Password does not match."
          end
        end
      end

      if errors.empty? && !user.nil?
        token = JWT.encode({"id" => user.id, "username" => user.username}, ENV["POMF_SECRET_KEY"], "HS256")

        cookies = HTTP::Cookies.new
        cookies << HTTP::Cookie.new("auth", token, "/", nil, Pomf.home_host)
        cookies.add_response_headers(context.response.headers)

        Util.redirect("/files")
      else
        render "pages/login"
      end
    end

    def do_register
      username = Util::Validations.username(params["username"])
      email = Util::Validations.email(params["email"])
      password = Util::Validations.password(params["password"])

      errors = Util.validate(params["email"], params["password"], params["username"], 0)

      if errors.empty?
        user = Models::User.new(params["username"], params["password"], params["email"]).create!

        token = JWT.encode({"id" => user.id, "username" => user.username}, ENV["POMF_SECRET_KEY"], "HS256")

        cookies = HTTP::Cookies.new
        cookies << HTTP::Cookie.new("auth", token)
        cookies.add_response_headers(context.response.headers)

        Util.redirect("/files")
      else
        render "pages/register"
      end
    end
  end
end
