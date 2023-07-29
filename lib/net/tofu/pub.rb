# frozen_string_literal: true

module Net
  module Tofu
    # Intermediate container for an X509 certificate public key.
    # Manages Geminispace public certificates.
    class Pub
      DIR = File.expand_path("~/.tofu")
      DB = File.expand_path("~/.tofu/known_hosts")

      # @return [String] The host associated with the certificate public key.
      attr_reader :host

      # @return [String] The certificate public key associated with the host.
      attr_reader :key

      # @return [OpenSSL::X509::Certificate] The X509 certificate.
      attr_reader :x509

      # Constructor for the cert type.
      # @param host [String] Host to associate with the certificate public key.
      # @param data [String] Certificate public key to associate with the host.
      def initialize(host, data)
        @host = host
        @key = data
        @key = format_hosts(data) if data.start_with?("-----BEGIN CERTIFICATE-----")
        @x509 = OpenSSL::X509::Certificate.new(to_x509)
      end

      # Lookup a host in the known_hosts table.
      # @param host [String] the hostname to lookup
      # @return [Cert] An instance of this class if found, or nil if not found.
      def self.lookup(host)
        db_exist?

        f = File.read(DB)
        includes = nil
        f.lines.each_with_index do |l, i|
          if l.split[0].include? host
            @line = i
            includes = l.split[1]
            break
          end
        end
        return nil if includes.nil? || includes.empty?

        new(host, includes)
      end

      def line
        @line ||= nil
      end

      # Pin a certificate public key to the known_hosts file
      def pin
        Net::Tofu::Pub.db_exist?

        f = File.open(DB, "a")
        f.puts self
      ensure
        f&.close
      end

      # Conver the certificate public key to a properly formatted X509 string.
      def to_x509
        lines = @key.chars.each_slice(64).map(&:join)
        "-----BEGIN CERTIFICATE-----\n#{lines.join("\n")}\n-----END CERTIFICATE-----"
      end

      # Hosts file format.
      def to_s
        "#{@host} #{@key}"
      end

      # Compare certificate public keys
      def ==(other)
        @key == other.key
      end

      # Check if known_hosts file exists, try to create it if it doesn't.
      def self.db_exist?
        return true if File.exist?(DB)

        FileUtils.mkdir_p(DIR) unless File.directory?(DIR)
        FileUtils.touch(DB)
        true
      end

      private

      # Strip header, tail, and newlines from base64 encoded certificate public key.
      def format_hosts(key)
        key.gsub("-----BEGIN CERTIFICATE-----", "").gsub("-----END CERTIFICATE-----", "").gsub("\n", "")
      end
    end
  end
end
