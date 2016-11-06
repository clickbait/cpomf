module Pomf::Util
  module Validations
    def self.username(str : String)
      username = str.gsub(/[^A-Za-z1-9]+/, "")

      username = !username.empty? ? username : nil

      username = !ENV["POMF_BLACKLISTED_NAMES"].split(',').includes?(username) ? username : nil

      username == str ? username : nil
    end

    def self.email(str : String)
      (CrystalEmail::Rfc5322::Public.validates? str) ? str : nil
    end

    def self.password(str : String)
      str.bytesize >= 8 ? str : nil
    end
  end

  def self.validate(email = nil, password = nil, username = nil, id = -1)
    errors = [] of String

    if !username.nil?
      username = Validations.username(username)
      if username.nil?
        errors << "Username is invalid or blacklisted."
      else
        Pomf.db.connection do |db|
          count = db.exec("SELECT FROM users WHERE username = $1 AND id != $2", [username, id]).rows.size

          if count > 0
            errors << "Username is already taken."
          end
        end
      end
    end

    if !email.nil?
      email = Validations.email(email)
      if email.nil?
        errors << "Email is invalid."
      else
        Pomf.db.connection do |db|
          count = db.exec("SELECT FROM users WHERE email = $1 AND id != $2", [email, id]).rows.size

          if count > 0
            errors << "Email is already taken."
          end
        end
      end
    end

    if !password.nil?
      password = Validations.password(password)
      if password.nil?
        errors << "Password is invalid."
      end
    end

    errors
  end
end
