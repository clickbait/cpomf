h2= @title

form action="" method="post"
  .form
    - if !errors.empty?
      ul.errors
        - errors.each do |error|
          li.error = error

    div.fieldset
      label for="title" Title
      input type="text" id="title" name="title" value=page.not_nil!.title

    div.fieldset
      label for="content" Content
      textarea id="content" name="content"= page.not_nil!.content

    #button
      button type="submit" Save Page
