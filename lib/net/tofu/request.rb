# frozen_string_literal: true

module Net
  module Tofu
    # Stores a client request to a Gemini server.
    class Request
      MAX_URI_BYTESIZE = 1024

      # @return [URI] The full URI object of the request.
      attr_reader :uri

      # @return [String] The request scheme (i.e. gemini://, http://).
      attr_reader :scheme

      # @return [String] The hostname of the request.
      attr_reader :host

      # @return [Integer] The server port to connect on.
      attr_reader :port

      # @return [String] The requested path on the host.
      attr_reader :path

      # @return [Array] Additional queries to send to the host.
      attr_reader :queries

      # @return [String] A fragment to request from the host.
      attr_reader :fragment

      # @return [Response] The response from the server after calling #{gets}.
      attr_reader :resp

      # Constructor for the request type.
      # @param host [String] A host string, optionally with the gemini:// scheme.
      # @param port [Integer] Optional parameter to specify the server port to connect to.
      def initialize(host, port: nil, trust: false)
        @uri = URI(host)
        @uri.port = port unless port.nil?

        parse_head
        parse_tail

        # Make sure the URI isn't too large
        if format.bytesize > MAX_URI_BYTESIZE
          raise InvalidURIError,
                "The URI is too large, should be #{MAX_URI_BYTESIZE} bytes, instead is #{format.bytesize} bytes"
        end

        # Create a socket
        @sock = Socket.new(@host, @port, trust)
      end

      # Format the URI for sending over a socket to a Gemini server.
      # @return [String] The URI string appended with a carriage return and linefeed.
      def format
        "#{@uri}\r\n"
      end

      # Connect to the server and try to fetch data.
      def gets
        @sock.connect
        @resp = @sock.gets(self)
      ensure
        @sock.close
      end

      private

      # Parses the scheme, the host, and the port for the request.
      def parse_head
        # Check if a scheme was specified, if not, default to gemini://
        # Also set the port if this happens
        if @uri.scheme.nil? || @uri.scheme.empty?
          @uri.scheme = URI::Gemini::DEFAULT_SCHEME
          @uri.port = URI::Gemini::DEFAULT_PORT if @uri.port.nil?
        end

        # Check if a host was specified.
        raise InvalidURIError, "Request does not contain a host" if @uri.host.nil? || @uri.host.empty?

        # Set member parts
        @scheme = @uri.scheme
        @host = @uri.host
        @port = @uri.port

        # Check if a scheme is present that isn't gemini://
        return if @uri.scheme == URI::Gemini::DEFAULT_SCHEME

        raise InvalidSchemeError,
              "Request uses an invalid scheme (has: #{@uri.scheme}, wants: #{URI::Gemini::DEFAULT_SCHEME}"
      end

      # Parses the path, the query, and the fragment for the request.
      def parse_tail
        # Set path to '/' if one isn't specified
        @uri.path = "/" if @uri.path.nil? || @uri.path.empty?

        # Set member parts
        @path = @uri.path
        @queries = @uri.query.split("&") unless @uri.query.nil? || @uri.query.empty?
        @fragment = @uri.fragment
      end
    end
  end
end
