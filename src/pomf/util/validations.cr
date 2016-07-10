module Pomf::Util
  module Validations
    def self.username(str : String)
      username = str.downcase.gsub(/[^A-Za-z1-9]+/, "")

      username = !username.empty? ? username : nil

      username = !ENV["POMF_BLACKLISTED_NAMES"].split(',').includes?(username) ? username : nil

      username == str.downcase ? username : nil
    end
    def self.email(str : String)
      (CrystalEmail::Rfc5322::Public.validates? str) ? str : nil
    end
    def self.password(str : String)
      str.bytesize > 8 ? str : nil
    end
  end
end
