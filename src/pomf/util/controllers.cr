module Pomf::Util
  module Controller
    private getter context : HTTP::Server::Context, params : HTTP::Params

    def initialize(@context, @params)
      if context.request.headers["Host"]? == Pomf.upload_host
        Util.redirect(Pomf.url)
      end
    end

    def logged_in_user
      Util::User.logged_in_user(context)
    end

    property title : String?
    property subtitle : String?

    macro render(view_name)
      {% if view_name.ends_with? ".template" %}
        ::Pomf::Util.render({{view_name}}, "context.response")
      {% else %}
        __default_template(->{ ::Pomf::Util.render({{view_name}}, "context.response") })
      {% end %}
    end

    private def __default_template(child)
      Slang.embed(__DIR__ + "/../views/page.template.slang", "context.response")
    end
  end

  module AdminController
    include Util::Controller

    def initialize(@context, @params)
      if logged_in_user.nil? || !designated_admins.includes?(logged_in_user.not_nil!["username"])
        Util.redirect("/")
      end
    end

    private def designated_admins
      ENV["POMF_ADMINS"].split(',')
    end

    private def __default_template(child)
      Slang.embed(__DIR__ + "/../views/admin.template.slang", "context.response")
    end
  end

  module FileController
    include Util::Controller

    def initialize(@context, @params)
    end
  end
end
