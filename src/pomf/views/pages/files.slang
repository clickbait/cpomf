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
