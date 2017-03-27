main.page.single
  .wrapper
    .content
        h2 Your Files
        form method="post"
          table
            - files.each do |file|
              tr
                td
                  == "<a href=\"#{url}#{file.filename}\" target=\"_blank\">#{file.original_filename}</a>"
                td= file.created.to_s("%Y-%m-%d %l:%M%P")
      - if user.not_nil!.can_upload
        hr
          h3 Upload with ShareX.
          div
            == "<textarea readonly class=\"codeblock\" rows=\"10\" onfocus=\"this.select()\">#{sharex_code}</textarea>"
      - else
        hr
        h3 Want to upload files?
        p == "<a href=\"mailto:neko@nya.is\" target=\"_blank\">Send Neko <s>nudes</s> an email</a> explaining what you'll be using nya.is for and he'll consider whitelisting your account."
