defmodule DigestTest do
  use ExUnit.Case
  doctest FDup.Digest
  import FDup.Digest

  test "the digest" do
    assert "9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08" == hash("test")
    assert "9F86D081884C7D659A2FEAA0C55AD015A3BF4F1B2B0B822CD15D6C15B0F00A08" == hash("te", "st")
  end
end
