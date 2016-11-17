module Pomf::Util
  module ReCAPTCHA
    def self.validate(response : String)
      HTTP::Client.post_form "https://www.google.com/recaptcha/api/siteverify", "response=#{response}&secret=#{ENV["POMF_RECAPTCHA_SECRET"]}"
    end
  end
end
