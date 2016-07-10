module Pomf
  class Router < Crouter::Router
    get "/", "PageController#home"
    get "/register", "PageController#register"
    get "/login", "PageController#login"
    get "/about", "PageController#about"
    get "/faq", "PageController#faq"
    get "/contact", "PageController#contact"

    post "/upload", "UploadController#do_upload"
    post "/login", "UserController#do_login"
    post "/register", "UserController#do_register"

    #admin panel
    group "/admin" do
        get "/", "AdminPageController#dashboard"
        group "/users" do
            get "/", "AdminPageController#users"
            get "/edit/:slug", "AdminPageController#users_edit"

            post "/edit/:slug", "AdminActionController#users_edit"
        end
    end

    # Static files handler
    if ENV["POMF_DEBUG"]? == "true"
      get "/public/:path", ->(context : HTTP::Server::Context, params : HTTP::Params) {
        # Remove /public from path
        path = context.request.path || "/"
        context.request.path = path[7..-1]

        Pomf.static_handler.call(context)

        context.request.path = path
        nil
      }
    end
  end
end
