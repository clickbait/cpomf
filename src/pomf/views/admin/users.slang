.row
  .col-xs-12
    .box
      h4 Users
      div
        table
          - users.each do |user|
            tr
              td= user.username
              td= user.email
              td
                == "<a href=\"/admin/users/edit/#{user.username}\">Edit</a>"



