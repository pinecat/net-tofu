# frozen_string_literal: true

module Net
  module Tofu
    class Response
      # Raised when a server doesn't send any data.
      class NoServerResponseError < StandardError; end

      # Raised when a server sends an invalid header.
      class InvalidHeaderError < StandardError; end

      # Raised when a server sends an invalid status code.
      class InvalidStatusCodeError < StandardError; end

      # Raised when a server sends an invalid meta field.
      class InvalidMetaError < StandardError; end

      # Raised when a server sends an invalid redirect link.
      class InvalidRedirectError < StandardError; end
    end

    class Request
      # Raised when a request contains an invalid scheme.
      class InvalidSchemeError < StandardError; end

      # Raised when a request contains an invalid URI.
      class InvalidURIError < StandardError; end
    end

    # Raised if the host in a get request doesn't have a cached public key.
    class UnknownHostError < StandardError; end

    # Raised if the host returns an invalid certificate (usually, it means it is out of date).
    class InvalidCertificateError < StandardError; end

    # Raised if the host returns a different public key.
    class PublicKeyMismatchError < StandardError; end
  end
end
