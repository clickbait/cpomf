module Pomf::Util
  macro redirect(url, code = 303)
    context.response.status_code = {{code}}
    context.response.headers["Location"] = {{url}}
  end
end
