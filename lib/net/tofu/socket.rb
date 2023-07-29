# frozen_string_literal: true

module Net
  module Tofu
    # Stoes an SSLSocket for making requests and receiving data.
    class Socket
      # Constructor for the socket type.
      # @param host [String] Hostname of the server to connect to.
      # @param port [Integer] Server port to connect to (typically 1965).
      def initialize(host, port, trust)
        @host = host
        @port = port
        @trust = trust
        @sock = OpenSSL::SSL::SSLSocket.open(@host, @port, context: generate_secure_context)
      end

      # Open a connection to the server.
      def connect
        @sock.hostname = @host
        @sock.connect
        validate_certs
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

      # Validate a remote certificate with a local one
      def validate_certs
        remote = Pub.new(@host, @sock.peer_cert.to_pem)
        local = Pub.lookup(@host)

        raise UnknownHostError if local.nil? && !@trust

        remote.pin if local.nil? && @trust
        local = Pub.lookup(@host)

        unless local == remote
          raise PublicKeyMismatchError, <<-TXT
The remote host has a different certificate than what is cached locally.
This could be because a new certificate was issued, or because of a MITM attack.
Please verify the new public certificate, then you may run:

  tofu -r #{@host}

Once you remove the old certificate public key, you will be able to add the new one.
          TXT
        end

        validate_timestamp(remote)
      end

      # Validate certificate timestamps
      def validate_timestamp(remote)
        raise InvalidCertificateError, "Certificate is not valid yet" if remote.x509.not_before > Time.now.utc
        raise InvalidCertificateError, "Certificate is no longer valid" if remote.x509.not_after < Time.now.utc
      end
    end
  end
end
