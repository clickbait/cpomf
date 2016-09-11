module Pomf
  class PageController
    include Util::Controller

    def home
      @title = "Weeb File Hosting"

      render "pages/home"
    end

    def register
      if !logged_in_user.nil?
        Util.redirect("/")
      else
        @title = "Sign Up"

        errors = [] of String
        password = email = username = nil

        render "pages/register"
      end
    end

    def login
      if !logged_in_user.nil?
        Util.redirect("/")
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
        @title = "My Files"

        url = URI.parse Pomf.upload_url
        url = url.to_s

        files = Models::Upload.where_multi("user_id=$1", [logged_in_user.not_nil!["id"]])

        render "pages/files"
      end
    end

    def do_files
      if logged_in_user.nil?
        Util.redirect("/login")
      else
        managing = params.fetch_all("manage")
        method = params["action"]

        managing = managing.map { |id| id.to_i32 }

        case method
        when "delete"
          files_for_deleting = Models::Upload.where_multi("user_id=$1 AND id = ANY($2::INT[])", [logged_in_user.not_nil!["id"], "{#{managing.join(",")}}"])

          file_ids_for_deleting = [] of Int32
          file_names_for_deleting = [] of String

          upload_dir = Pomf.upload_dir

          files_for_deleting.each do |file|
            file_ids_for_deleting << file.id

            file = File.join(upload_dir, file.filename)

            if File.exists?(file)
              File.delete(file)
            end
          end

          Pomf.db.connection do |db|
            db.exec("DELETE FROM uploads WHERE user_id=$1 AND id = ANY($2::INT[])", [logged_in_user.not_nil!["id"], "{#{file_ids_for_deleting.join(",")}}"])
          end

          Util.redirect("/files")
        else
          Util.redirect("/login")
        end
      end
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
