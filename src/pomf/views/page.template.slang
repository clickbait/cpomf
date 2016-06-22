doctype html
html
  head
    title = @title ? "Pomf - #{@title}" : "Pomf"

    meta name="viewport" content="width=device-width, initial-scale=1"
    link href="/public/css/main.css" rel="stylesheet"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css"

    script type="text/javascript" src="/public/js/jquery.js"
    script type="text/javascript" src="/public/js/main.js"
  body
    header
      .wrapper
        h1
          a href="#"
            == "<i class=\"fa fa-paw\" aria-hidden=\"true\"></i>nya<i>.is</i>"
        ul
          li
            a href="#" Home
          li
            a href="#" News
          li
            a href="#" FAQ
          li
            a href="#" Transparency
          li
            a href="#" Contact
    - child.call
