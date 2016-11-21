nav.user
  .wrapper
    .left
      - if !logged_in_user.nil?
        ul
          li
            a href="/files" My Files
    .right
      - if !logged_in_user.nil?
          == "Hiya, #{logged_in_user.not_nil!["username"]}!"
      - else
        == "<a href=\"#{Pomf.url}/login\">Login</a> Or <a href=\"#{Pomf.url}/register\">Register</a>"
