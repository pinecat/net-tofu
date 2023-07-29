# frozen_string_literal: true

require "simplecov"
SimpleCov.start

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "net/tofu"
require "minitest/autorun"

# Previous content of test helper now starts here

HOST = "gemini.circumlunar.space"
PATH = "/"
QUERY = "client=tofu"
FRAGMENT = "5"

URIS = [
  "#{URI::Gemini::DEFAULT_SCHEME}://#{HOST}#{PATH}", # A typical top-level Gemini URI
  "#{URI::Gemini::DEFAULT_SCHEME}://#{HOST}:#{URI::Gemini::DEFAULT_PORT}#{PATH}?#{QUERY}##{FRAGMENT}", # All the bits
  "#{URI::Gemini::DEFAULT_SCHEME}://#{HOST}", # A Gemini URI without a path
  "//#{HOST}#{PATH}", # A Gemini URI without a scheme
  "//#{HOST}" # A gemini URI without a scheme or a path
].freeze
