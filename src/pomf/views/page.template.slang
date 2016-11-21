doctype html
html
  head
    title = @title ? "Nya - #{@title}" : "Nya"

    meta name="viewport" content="width=device-width, initial-scale=1"
    link href="/public/css/flexboxgrid.min.css" rel="stylesheet"
    link href="/public/css/main.css" rel="stylesheet"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css"

    script type="text/javascript" src="/public/js/jquery.js"
    script type="text/javascript" src="/public/js/main.js"
  body
    .navigation
      - render "partials/usernav.template"
      header
        .wrapper
          h1
            == "<a href=\"#{Util.redirect(Pomf.url)}/\"><i class=\"fa fa-paw\" aria-hidden=\"true\"></i>nya<i>.is</i></a>"
          ul
            li
              == "<a href=\"#{Util.redirect(Pomf.url)}/\">Upload</a>"
            li
              == "<a href=\"#{Util.redirect(Pomf.url)}/faq\">FAQ</a>"
            li
              == "<a href=\"#{Util.redirect(Pomf.url)}/about\">About</a>"
            li
              == "<a href=\"#{Util.redirect(Pomf.url)}/contact\">Contact</a>"
    - child.call
