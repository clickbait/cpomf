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
      "md",
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
        Util.redirect("/")
      else
        if WHITELISTED_EXTS.includes?(File.extname(params["filename"])[1..-1].downcase)
          context.response.headers["X-Accel-Redirect"] = "/internal/#{params["filename"]}"
          return
        end

        file = Models::Upload.where("filename = $1", [params["filename"]])

        if !file.nil?
          @title = file.not_nil!.original_filename

          render "pages/download"
        else
          Util.redirect("/")
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
