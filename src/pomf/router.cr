module Pomf
  class Router < Crouter::Router
    get "/", "PageController#home"
    get "/register", "PageController#register"
    get "/login", "PageController#login"
    get "/files", "PageController#files"

    post "/upload(.php)", "UploadController#do_upload"
    post "/login", "UserController#do_login"
    post "/register", "UserController#do_register"
    post "/files", "PageController#do_files"

    # admin panel
    group "/admin" do
      get "/", "AdminPageController#dashboard"
      group "/pages" do
        get "/", "AdminPageController#pages"
        get "/new", "AdminPageController#pages_new"
        get "/edit/:slug", "AdminPageController#pages_edit"

        post "/new", "AdminActionController#pages_new"
        post "/edit/:slug", "AdminActionController#pages_edit"
      end
      group "/users" do
        get "/", "AdminPageController#users"
        get "/edit/:slug", "AdminPageController#users_edit"

        post "/edit/:slug", "AdminActionController#users_edit"
      end

      group "/files" do
        get "/", "AdminPageController#files"
        post "/", "AdminActionController#files"
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

    get "/:slug", ->(context : HTTP::Server::Context, params : HTTP::Params) {
      if context.request.headers["Host"]? == Pomf.upload_host
        params["filename"] = params["slug"]
        FileController.new(context, params).view
      else
        PageController.new(context, params).pages
      end
      nil
    }

    post "/:filename", "FileController#fetch"
  end
end
