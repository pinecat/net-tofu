# frozen_string_literal: true

require "test_helper"

class TestNetTofuResponse < Minitest::Test
  def test_receiving_a_success_response
    r = Net::Tofu.get_response(URIS[0])

    assert r.success?
    assert r.status == 20
    assert r.status_maj == 2
    assert r.status_min.zero?
    assert r.meta == "text/gemini"
  end

  def test_receiving_a_redirect_response
    r = Net::Tofu.get_response("#{URIS[0]}software")

    assert r.redirect?
    assert r.status == 31
    assert r.status_maj == 3
    assert r.status_min == 1
    assert r.meta == "gemini://gemini.circumlunar.space/software/"
  end

  def test_receiving_a_permanent_failure_response
    r = Net::Tofu.get_response("#{URIS[0]}prettysurethisdoesntexist")

    assert r.permanent_failure?
    assert r.status == 51
    assert r.status_maj == 5
    assert r.status_min == 1
    assert r.meta == "Not found!"
  end
end
