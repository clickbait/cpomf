h2= @title

form action="" method="post"
  .form
    - if !errors.empty?
      ul.errors
        - errors.each do |error|
          li.error = error

    div.fieldset
      label for="username" Username
      input type="text" id="username" name="username" value=user.not_nil!.username
      p.hint No special characters, only numbers and letters.

    div.fieldset
      label for="email" Email
      input type="email" id="email" name="email" value=user.not_nil!.email

    div.fieldset
      label for="password" Password
      input type="password" id="password" name="password"
      p.hint No less than 8 characters long.

    #button
      button type="submit" Save User
