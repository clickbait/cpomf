.row
  .col-xs-12
    .box
      h4 Pages
        a href="/admin/pages/new" New
      div
        table
          - pages.each do |page|
            tr
              td= page.title
              td
                == "<a href=\"/admin/pages/edit/#{page.slug}\">Edit</a>"



