module Pomf
  class AdminActionController
    include Util::AdminController

    def users_edit
      slug = Util::Validations.username(params["slug"])

      if slug.nil?
        Util.redirect("/admin/users")
      end

      user = Models::User.where("username = $1", [slug])

      if user.nil?
        Util.redirect("/admin/users")
      end

      if !params["password"].empty?
        password = params["password"]
      else
        password = nil
      end

      errors = Util.validate(params["email"], password, params["username"], user.id)

      @title = "Editing #{user.username}"

      if !errors.empty?
        render "admin/users/edit"
      else
        puts params["username"]
        user.username = params["username"].downcase
        user.email = params["email"].downcase
        if !params["password"].empty?
          user.password = params["password"]
        end

        user.save

        Util.redirect("/admin/users")
      end
    end

    def pages_new
      if !params["title"].nil?
        page = Models::Page.new(params["title"], params["content"])

        page.create!
      end

      Util.redirect("/admin/pages")
    end

    def pages_edit
      slug = params["slug"].to_slug

      if slug.empty?
        Util.redirect("/admin/pages")
      end

      errors = [] of String

      page = Models::Page.where("slug = $1", [slug])

      if !page.nil?
        page.title = params["title"]
        page.content = params["content"]

        page.save
      else
        errors << "Page does not exist"
      end

      Util.redirect("/admin/pages")
    end

    def files
      if !params["file"]?.nil?
        files_for_deleting = Models::Upload.where_multi("filename = $1", [params["file"]])

        if files_for_deleting
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
        end
        Util.redirect("/admin/files")
      elsif !params["username"]?.nil?
        user = Models::User.where("username = $1", [params["username"]])

        if user
          user_files = Models::Upload.where_multi("user_id=$1", [user.id])

          url = URI.parse Pomf.upload_url
          url = url.to_s

          render "admin/files_user"
        end
      else
        Util.redirect("/admin/files")
      end
    end
  end
end
