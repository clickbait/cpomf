require "../src/pomf"

require "spec2"
require "power_assert"

Spec2.random_order
Spec2.doc

macro expect_raises(exception_type = Exception)
  %exception = nil

  begin
    {{yield}}
  rescue ex
    %exception = ex
  end

  if %exception == nil
    raise "Expected exception but was nil"
  end

  if !%exception.is_a?({{exception_type}})
    raise "Expected exception to be a {{exception_type}} but was a #{%exception.class}"
  end

  %exception
end
