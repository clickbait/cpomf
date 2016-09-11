nav.user
  .wrapper
    .left
      - if !logged_in_user.nil?
        ul
          li
            a href="/files" My Files
    .right
      - if !logged_in_user.nil?
          a href="#" = logged_in_user.not_nil!["username"]
      - else
        a href="/login" Login
        == " Or "
        a href="/register" Register
