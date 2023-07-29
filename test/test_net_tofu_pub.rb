# frozen_string_literal: true

require "test_helper"
require "fileutils"

class TestNetTofuPub < Minitest::Test
  def test_creating_known_hosts_file
    assert Net::Tofu::Pub.db_exist?
  ensure
    FileUtils.rm_rf(Net::Tofu::Pub::DIR)
  end

  def test_loooking_up_a_host_with_empty_file
    FileUtils.rm_rf(Net::Tofu::Pub::DIR)
    assert_nil Net::Tofu::Pub.lookup("gemini.circumlunar.space")
  ensure
    FileUtils.rm_rf(Net::Tofu::Pub::DIR)
  end

  def test_looking_up_a_host
    assert Net::Tofu::Pub.db_exist?
    f = File.open(Net::Tofu::Pub::DB, "a")
    f.puts "gemini.circumlunar.space MIIBiDCCAS2gAwIBAgIQPjK/qvqQIwbBbgAAm5NdSTAKBggqhkjOPQQDAjAjMSEwHwYDVQQDExhnZW1pbmkuY2lyY3VtbHVuYXIuc3BhY2UwHhcNMjAxMDAzMTM1MDM3WhcNMjUxMDAzMTM1MDM3WjAjMSEwHwYDVQQDExhnZW1pbmkuY2lyY3VtbHVuYXIuc3BhY2UwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASokAgCHo9618c0mNkUfMHREihY/bAt4NUPgkkfjK981SWitBCiCHGmrH23WvehzgTC9mKDeBCPjWqzjrh0jXm9o0MwQTA/BgNVHREEODA2ghhnZW1pbmkuY2lyY3VtbHVuYXIuc3BhY2WCGiouZ2VtaW5pLmNpcmN1bWx1bmFyLnNwYWNlMAoGCCqGSM49BAMCA0kAMEYCIQCqawL48qofghdNM0vUa21BJ2cp96fxIeJDp3SCzFAjrgIhAKyvNbXokC6i189Y6dRem1Wojh6Sy3hU/EHPpLlobpcR"
    f&.close

    remote = Net::Tofu::Pub.new("gemini.circumlunar.space", "-----BEGIN CERTIFICATE-----\nMIIBiDCCAS2gAwIBAgIQPjK/qvqQIwbBbgAAm5NdSTAKBggqhkjOPQQDAjAjMSEwHwYDVQQDExhnZW1pbmkuY2lyY3VtbHVuYXIuc3BhY2UwHhcNMjAxMDAzMTM1MDM3WhcNMjUxMDAzMTM1MDM3WjAjMSEwHwYDVQQDExhnZW1pbmkuY2lyY3VtbHVuYXIuc3BhY2UwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASokAgCHo9618c0mNkUfMHREihY/bAt4NUPgkkfjK981SWitBCiCHGmrH23WvehzgTC9mKDeBCPjWqzjrh0jXm9o0MwQTA/BgNVHREEODA2ghhnZW1pbmkuY2lyY3VtbHVuYXIuc3BhY2WCGiouZ2VtaW5pLmNpcmN1bWx1bmFyLnNwYWNlMAoGCCqGSM49BAMCA0kAMEYCIQCqawL48qofghdNM0vUa21BJ2cp96fxIeJDp3SCzFAjrgIhAKyvNbXokC6i189Y6dRem1Wojh6Sy3hU/EHPpLlobpcR\n-----END CERTIFICATE-----")
    local = Net::Tofu::Pub.lookup("gemini.circumlunar.space")

    assert_equal remote, local
  ensure
    f&.close
    FileUtils.rm_rf(Net::Tofu::Pub::DIR)
  end
end
