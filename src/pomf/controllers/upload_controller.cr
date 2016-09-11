module Pomf
  class UploadController
    include Util::Controller

    CHARS = "abcdefghijklmnopqrstuvwxyz".chars
    COMPLEX_EXTS = [
      "tar.gz",
      "tar.bz",
      "tar.bz2",
      "tar.xz",
      "user.js"
    ]

    def do_upload
      user = logged_in_user.try { |token| Models::User.where("id = $1", [token["id"]]) }

      upload_dir = Pomf.upload_dir

      files = [] of {name: String?, url: String, hash: String, size: Int64}
      HTTP::FormData.parse(context.request) do |mp|
        mp.file("files[]") do |io, metadata|
          file_name = unique_filename(metadata)
          file_path = File.join(upload_dir, file_name)

          size, hash = write_file(file_path, io)

          url = URI.parse Pomf.upload_url

          url.path = "/#{file_name}"

          url = url.to_s

          Models::Upload.new(file_name, size.to_i64, metadata.filename, user).create!
          files << {name: metadata.filename, url: url.to_s, hash: hash, size: size.to_i64}
        end
      end

      case context.request.query_params["output"]?
      when "gyazo"
        context.response.content_type = "text/plain"
        files.map { |file| file[:url] }.join('\n', context.response)
      when "text"
        context.response.content_type = "text/plain"
        files.map { |file| file[:url] }.join('\n', context.response)
        context.response << '\n'
      else
        context.response.content_type = "application/json"
        {success: true, files: files}.to_json(context.response)
      end
    rescue ex : Exception
      # TODO: report errors properly?
      ex.inspect_with_backtrace(STDOUT)
      context.response.content_type = "application/json"
      context.response.status_code = 500
      {success: false, errorcode: 500, description: "Internal Server Error"}.to_json(context.response)
    end

    def write_file(file_path, io) : {UInt64, String}
      digest = OpenSSL::Digest.new("SHA1")
      size = 0_u64
      File.open(file_path, "w") do |file|
        buf = uninitialized UInt8[8192]
        buffer = buf.to_slice
        while (read_bytes = io.read(buffer)) > 0
          data = buffer[0, read_bytes]
          digest << data
          file.write(data)
          size += read_bytes
        end
      end

      {size, digest.hexdigest}
    end

    def unique_filename(metadata)
      3.times do
        filename = generate_filename(metadata)

        upload_dir = Pomf.upload_dir
        file_path = File.join(upload_dir, filename)

        return filename if !File.exists?(file_path)
      end
      raise "Conflicted 3 times!"
    end

    def generate_filename(metadata)
      if filename = metadata.filename
        file_ext = extension(filename)
        "#{random_str}.#{file_ext}"
      else
        random_str
      end
    end

    def extension(filename : String)
      COMPLEX_EXTS.each do |ext|
        return ext if filename.ends_with? ".#{ext}"
      end

      File.extname(filename)[1..-1]
    end

    def random_str
      String.build(6) do |builder|
        6.times do
          builder << CHARS.sample
        end
      end
    end
  end
end
