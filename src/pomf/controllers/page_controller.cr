module Pomf
  class PageController
    include Util::Controller

    def redirect
      Util.redirect(ENV["POMF_CLOSING_DOWN_URL"])
    end

    def home
      if logged_in_user.nil?
        Util.redirect("/login")
      else
        user = logged_in_user.try { |token| Models::User.where("id = $1", [token["id"]]) }

        if user.not_nil!.can_upload
          @title = "Catgirl File Hosting"

          render "pages/home"
        else
          Util.redirect("/files")
        end
      end
    end

    def register
      if !logged_in_user.nil?
        Util.redirect("/upload")
      else
        @title = "Sign Up"

        errors = [] of String
        password = email = username = nil

        render "pages/register"
      end
    end

    def login
      if !logged_in_user.nil?
        Util.redirect("/upload")
      else
        @title = "Sign In"

        errors = [] of String
        password = email = nil

        render "pages/login"
      end
    end

    def files
      if logged_in_user.nil?
        Util.redirect("/login")
      else
        user = logged_in_user.try { |token| Models::User.where("id = $1", [token["id"]]) }

        @title = "My Files"

        url = URI.parse Pomf.upload_url
        url = url.to_s

        # fuck i hate this
        sharex_code = "{
  \"Name\": \"Nya Beta\",
  \"RequestType\": \"POST\",
  \"RequestURL\": \"https://nya.is/upload?token=#{user.not_nil!.access_token}\",
  \"FileFormName\": \"files[]\",
  \"ResponseType\": \"Text\",
  \"URL\": \"$json:files[0].url$\"
}"

        files = Models::Upload.where_multi("user_id=$1", [logged_in_user.not_nil!["id"]])

        render "pages/files"
      end
    end

    def do_files
      Util.redirect("/files")
    end

    def pages
      slug = params["slug"].to_slug

      if slug.empty?
        Util.redirect("/")
        # TODO: replace with 404
      end

      page = Models::Page.where("slug = $1", [slug])

      if !page.nil?
        @title = page.not_nil!.title

        render "pages/page"
      else
        @title = "404"

        context.response.status_code = 404

        render "pages/404"
      end
    end
  end
end
