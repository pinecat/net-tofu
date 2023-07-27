# frozen_string_literal: true

class String # :nodoc:
  def numerical?
    to_i.to_s == self
  end
end

module Net
  module Tofu
    # Stores a response from a Gemini server.
    class Response
      # Response types
      INPUT = 1
      SUCCESS = 2
      REDIRECT = 3
      TEMPORARY_FAILURE = 4
      PERMANENT_FAILURE = 5
      REQUEST_CERTIFICATE = 6

      # Limits
      MAX_META_BYTESIZE = 1024

      # @return [String] The full response header from the server.
      attr_reader :header

      # @return [Integer] The 2-digit, server response status.
      attr_reader :status

      # @return [Integer] The first digit of the server response status.
      attr_reader :status_maj

      # @return [Integer] The second digit of the server response status.
      attr_reader :status_min

      # Dependent on the #{status} ->
      # => 1x: (INPUT)     A prompt line that should be displayed to the user.
      # => 2x: (SUCCESS)   A MIME media type.
      # => 3x: (REDIRECT)  A new URL for the requested resource.
      # => 4x: (TEMP FAIL) Additional information regarding the temporary failure.
      # => 5x: (PERM FAIL) Additional information regarding the temporary failure.
      # => 6x: (RQST CERT) Additional information regarding the client certificate requirements.
      #
      # According to the specification for the Gemini Protocol, clients SHOULD close a connection to servers which send
      # a meta over 1024 bytes. This library complies with this specification, although, it is conceivable that meta
      # could be an arbitrarily long string.
      #
      # @return [String] The UTF-8 encoded message from the response header.
      attr_reader :meta

      # @return [String] The message body.
      attr_reader :body

      # Constructor for the response type.
      # @param data [String] A raw Gemini server response.
      def initialize(data)
        @data = data
        parse
      end

      # Get a human readable response type.
      # @return [String] The response type as a human readable string.
      def type
        case @status_maj
        when INPUT then return "Input"
        when SUCCESS then return "Success"
        when REDIRECT then return "Redirect"
        when TEMPORARY_FAILURE then return "Temporary failure"
        when PERMANENT_FAILURE then return "Permanent failure"
        when REQUEST_CERTIFICATE then return "Request certificate"
        end
        "Unknown"
      end

      def input?; return true if @status_maj == INPUT; false; end
      def success?; return true if @status_maj == SUCCESS; false; end
      def redirect?; return true if @status_maj == REDIRECT; false; end
      def temporary_failure?; return true if @status_maj == TEMPORARY_FAILURE; false; end
      def permanent_failure?; return true if @status_maj == PERMANENT_FAILURE; false; end
      def request_certificate?; return true if @status_maj == REQUEST_CERTIFICATE; false; end

      private

      # Splits up the responseinto a header and a body.
      def parse
        # Extract the header and parse it
        a = @data.split("\n")
        @header = a[0].strip
        parse_header

        # Remove the first element from the array,
        # then populate body with the rest of the data
        a.shift
        @body = a.join("\n") if a.length.positive?
      end

      # Splits upt the header into a status code and a meta.
      def parse_header
        a = @header.split

        # Make sure there are only one or two elements in the header
        raise InvalidHeaderError, "The server did not send a header" unless a.length.positive?

        # Parse the status code
        @status = a[0]
        parse_status

        # Parse the meta
        @meta = ""
        @meta = a[1..].join(" ") if a.length >= 2
        parse_meta
      end

      # Splits up the status into a major and minor, checks for invalid status codes.
      def parse_status
        # Make sure the status is numerical
        unless @status.numerical?
          raise InvalidStatusCodeError,
                "The server sent a non-numerical status code: #{@status}"
        end

        # Allow status code to only be a single digit, or two digits (as the spec says it should be)
        if @status.length == 1
          @status_maj = Integer(@status)
          @status_min = 0
        elsif @status.length == 2
          @status_maj = Integer(@status[0])
          @status_min = Integer(@status[1])
        else
          raise InvalidStatusCodeError, "The server sent a status code that is longer than 2 digits: #{@status}"
        end

        # Make sure the major status code is between 1 and 6, including 1 and 6
        unless @status_maj >= 1 && @status_maj <= 6
          raise InvalidStatusCodeError,
                "The server sent an invalid, major status code: #{@status_maj}"
        end

        # Make sure #{status} is an Integer
        @status = Integer(@status)
      end

      # Checks the meta size, does extra checking depending on #{status} type.
      def parse_meta
        # Make sure the meta isn't too large
        if @meta.bytesize > MAX_META_BYTESIZE
          raise InvalidMetaError,
                "The server sent a meta that was too large, should be #{MAX_META_BYTESIZE} bytes, instead is #{@meta.bytesize} bytes"
        end

        if @status_maj == TEMPORARY_FAILURE || @status_maj == PERMANENT_FAILURE || @status_maj == REQUEST_CERTIFICATE
          return
        end

        # Make sure meta exists (i.e. has length)
        # This satisfies the INPUT and SUCCESS
        unless @meta.length.positive?
          raise InvalidMetaError,
                "The server sent an empty meta, should've sent a user prompt"
        end

        # TODO: Possibly check for valid MIME type for the SUCCESS response
        return if @status_maj == INPUT || @status_maj == SUCCESS

        # The meta needs a specific URI if @status_maj == REDIRECT
        uri = URI(@meta)

        # Make sure the URI has a scheme
        raise InvalidRedirectError, "The redirect link does not have a scheme" if uri.scheme.nil? || uri.scheme.empty?

        # Make sure the URI scheme is 'gemini'
        return if uri.scheme == "gemini"

        raise InvalidRedirectError,
              "The redirect link has an invalid scheme (has: #{uri.scheme}, wants: gemini)"
      end
    end
  end
end
