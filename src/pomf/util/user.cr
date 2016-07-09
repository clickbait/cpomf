module Util
  module User
    def self.logged_in_user(context)
      if context.request.cookies.has_key? "auth"
        user, header = JWT.decode(context.request.cookies["auth"].value, ENV["POMF_SECRET_KEY"], "HS256")
        user
      else
        nil
      end
    end
  end
end
