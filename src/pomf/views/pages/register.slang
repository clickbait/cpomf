form action="/register" method="post"
  main.page.flex
    div.form_boxed
      h2 Sign Up
      - if !errors.empty?
        ul.errors
          - errors.each do |error|
            li.error = error
      div.row
        label for="username" Username
        input type="text" id="username" name="username" value=username
        p.hint No special characters, only numbers and letters.

      div.row
        label for="email" Email
        input type="email" id="email" name="email" value=email

      div.row
        label for="password" Password
        input type="password" id="password" name="password" value=password
        p.hint No less than 8 characters long.

      #button
        button type="submit" Create Account
