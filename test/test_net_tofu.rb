# frozen_string_literal: true

require "test_helper"

class TestNetTofu < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Net::Tofu::VERSION
  end

  def test_that_it_can_get_a_geminispace_page
    body = Net::Tofu.get(URIS[0], trust: true)

    refute_nil body
  end

  def test_that_it_gets_a_proper_response
    resp = Net::Tofu.get_response(URIS[0], trust: true)

    assert resp.success?
    assert resp.status == 20
    assert resp.meta == "text/gemini"
    refute_nil resp.body
  end
end
