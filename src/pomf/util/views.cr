module Pomf::Util
  macro render(view_name, io_name)
    Slang.embed(__DIR__ + "/../views/{{view_name.id}}.slang", {{io_name}})
  end
end
