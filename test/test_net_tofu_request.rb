# frozen_string_literal: true

require "test_helper"

class TestNetTofuRequest < Minitest::Test
  def test_that_it_parses_a_uri_with_all_components
    r = Net::Tofu::Request.new(URIS[1])

    assert r.scheme == URI::Gemini::DEFAULT_SCHEME
    assert r.host == HOST
    assert r.port == URI::Gemini::DEFAULT_PORT
    assert r.path == PATH
    assert r.queries[0] == QUERY
    assert r.fragment == FRAGMENT
  end

  def test_that_it_parses_a_uri_without_a_path
    r = Net::Tofu::Request.new(URIS[2])

    assert r.scheme == URI::Gemini::DEFAULT_SCHEME
    assert r.host == HOST
    assert r.port == URI::Gemini::DEFAULT_PORT
    assert r.path == PATH
    assert_nil r.queries
    assert_nil r.fragment
  end

  def test_that_it_parses_a_uri_without_a_scheme
    r = Net::Tofu::Request.new(URIS[3])

    assert r.scheme == URI::Gemini::DEFAULT_SCHEME
    assert r.host == HOST
    assert r.port == URI::Gemini::DEFAULT_PORT
    assert r.path == PATH
    assert_nil r.queries
    assert_nil r.fragment
  end

  def test_that_it_parses_a_uri_without_a_path_or_a_scheme
    r = Net::Tofu::Request.new(URIS[4])

    assert r.scheme == URI::Gemini::DEFAULT_SCHEME
    assert r.host == HOST
    assert r.port == URI::Gemini::DEFAULT_PORT
    assert r.path == PATH
    assert_nil r.queries
    assert_nil r.fragment
  end
end
