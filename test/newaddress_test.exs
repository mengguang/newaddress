defmodule NewaddressTest do
  use ExUnit.Case
  doctest Newaddress

  test "greets the world" do
    assert Newaddress.hello() == :world
  end
end
