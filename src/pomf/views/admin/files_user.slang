.row
  .col-xs-12
    .box
      h4 Files
      div
        table
          - user_files.each do |file|
            tr
              td
                == "<a href=\"#{url}#{file.filename}\" target=\"_blank\">#{file.original_filename}</a>"
              td= file.created.to_s("%Y-%m-%d %l:%M%P")
