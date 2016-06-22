module Pomf::Util
  def self.timed : Time::Span
    time_start = Time.now
    yield
    time_end = Time.now

    time_end - time_start
  end
end
