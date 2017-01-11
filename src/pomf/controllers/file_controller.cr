module Pomf
  class FileController
    include Util::FileController

    WHITELISTED_EXTS = [
      "avi",
      "bmp",
      "css",
      "csv",
      "db",
      "demo",
      "epub",
      "flac",
      "gif",
      "ico",
      "jpeg",
      "jpg",
      "js",
      "json",
      "log",
      "m3u",
      "md",
      "mkv",
      "mov",
      "mp3",
      "mp4",
      "mpeg",
      "mpg",
      "ogg",
      "osb",
      "osk",
      "osr",
      "osu",
      "osz",
      "pdf",
      "png",
      "psd",
      "sc2replay",
      "sql",
      "tif",
      "tiff",
      "torrent",
      "txt",
      "wav",
      "webm",
      "webp",
      "wmv",
      "xml",
    ]

    def view
      if !params["filename"]
        Util.redirect(Pomf.url)
      else
        if WHITELISTED_EXTS.includes?(File.extname(params["filename"])[1..-1].downcase)
          context.response.headers["X-Accel-Redirect"] = "/internal/#{params["filename"]}"
          return
        end

        file = Models::Upload.where("filename = $1", [params["filename"]])

        upload_dir = Pomf.upload_dir
        file_path = File.join(upload_dir, params["filename"])

        if !File.exists?(file_path)
          @title = "404"

          context.response.status_code = 404

          render "pages/404"
          return
        end

        if !file.nil?
          @title = file.not_nil!.original_filename

          render "pages/download"

        elsif File.exists?(file_path)
          @title = params["filename"]

          render "pages/download"
        else
          @title = "404"

          context.response.status_code = 404

          render "pages/404"
        end
      end
    end

    def fetch
      if !params["filename"]
        Util.redirect(Pomf.url)
      else
        if params["g-recaptcha-response"]
          captcha = Util::ReCAPTCHA.validate(params["g-recaptcha-response"])

          if captcha.body
            response = JSON.parse(captcha.body)

            if !response["success"].nil?
              if response["success"] == true
                context.response.headers["X-Accel-Redirect"] = "/internal/#{params["filename"]}"
                return
              end
            end
          end
        end
        Util.redirect("/#{params["filename"]}")
      end
    end
  end
end
