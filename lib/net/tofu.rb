# frozen_string_literal: true

require_relative "tofu/error"
require_relative "tofu/request"
require_relative "tofu/response"
require_relative "tofu/socket"
require_relative "tofu/version"

require "openssl"
require "stringio"
require "uri/gemini"

module Net
  # Top level module for Geminispace requests.
  module Tofu
    def self.get(uri, trust: true)
      req = Request.new(uri)
      req.gets

      return req.resp.body if req.resp.success?

      req.resp.meta
    end

    def self.get_response(uri, trust: true)
      req = Request.new(uri)
      req.gets

      req.resp
    end
  end
end
