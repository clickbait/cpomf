doctype html
html
  head
    title = @title ? "Admin - #{@title}" : "Admin"

    meta name="viewport" content="width=device-width, initial-scale=1"
    link href="/public/css/flexboxgrid.min.css" rel="stylesheet"
    link href="/public/css/admin.css" rel="stylesheet"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css"

    script type="text/javascript" src="/public/js/jquery.js"
    script type="text/javascript" src="/public/js/admin.js"
  body
    .navigation
      - render "partials/usernav.template"
      header
        .wrapper
          h1
            a href="/"
              == "<i class=\"fa fa-paw\" aria-hidden=\"true\"></i>nya<i>.is</i>"
          h2 Admin
          ul
            li
              a href="/admin/" Dashboard
            li
              a href="/admin/users/" Users
            li
              a href="#" Files
            li
              a href="#" CMS
    .body
      .wrapper
        - child.call
