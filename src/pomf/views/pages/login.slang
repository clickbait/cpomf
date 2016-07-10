form action="/login" method="post"
  main.page.flex
    div.form_boxed
      h2 Sign In
      - if !errors.empty?
        ul.errors
          - errors.each do |error|
            li.error = error
      div.fieldset
        label for="email" Email
        input type="text" id="email" name="email" value=email

      div.fieldset
        label for="password" Password
        input type="password" id="password" name="password" value=password

      #button
        button type="submit" Create Account
