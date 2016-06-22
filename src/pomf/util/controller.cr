module Pomf::Util
  module Controller
    private getter context : HTTP::Server::Context, params : HTTP::Params

    def initialize(@context, @params)
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
end
