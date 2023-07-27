# frozen_string_literal: true

module Net
  module Tofu
    # Stoes an SSLSocket for making requests and receiving data.
    class Socket
      # Constructor for the socket type.
      # @param host [String] Hostname of the server to connect to.
      # @param port [Integer] Server port to connect to (typically 1965).
      def initialize(host, port)
        @host = host
        @port = port
        @sock = OpenSSL::SSL::SSLSocket.open(@host, @port, context: generate_secure_context)
      end

      # Open a connection to the server.
      def connect
        @sock.hostname = @host
        @sock.connect
      end

      # Try and retrieve data from a request.
      def gets(req)
        @sock.puts req.format

        io = StringIO.new
        while (line = @sock.gets)
          io.puts line
        end

        Response.new(io.string)
      ensure
        io.close
      end

      # Close the connection with the server.
      def close
        @sock.close
      end

      private

      # Configure the TLS security options to use on the socket.
      def generate_secure_context
        ctx = OpenSSL::SSL::SSLContext.new
        ctx.verify_hostname = true
        ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
        ctx.min_version = OpenSSL::SSL::TLS1_2_VERSION
        ctx.options |= OpenSSL::SSL::OP_IGNORE_UNEXPECTED_EOF
        ctx
      end
    end
  end
end
