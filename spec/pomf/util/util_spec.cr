require "../../spec_helper"

Spec2.describe Pomf::Util do
  describe ".cache" do
    it "returns the value in the block" do
      assert Util.cache("spec-1") { "foo" } == "foo"
    end

    it "caches the block's return value" do
      run_count = 0

      res = Util.cache("spec-2") { run_count += 1; "one" }

      assert res == "one"
      assert run_count == 1

      res = Util.cache("spec-2") { run_count += 1; "two" }

      assert res == "one"
      assert run_count == 1
    end

    it "caches different value for different keys" do
      assert Util.cache("spec-3-1") { "foo" } == "foo"
      assert Util.cache("spec-3-2") { "bar" } == "bar"
      assert Util.cache("spec-3-1") { "baz" } == "foo"
      assert Util.cache("spec-3-2") { "bing" } == "bar"
    end
  end
end
