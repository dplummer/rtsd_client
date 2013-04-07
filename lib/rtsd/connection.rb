require 'socket'
module Rtsd
  class Connection
    attr_reader :hostname, :port

    def initialize(options = {})
      @hostname = options.fetch(:hostname, 'localhost')
      @port     = options.fetch(:port, 4242)
    end

    def puts(message)
      reconnect unless connected?

      send_message(message)
    end

    def connected?
      !tcp_socket.nil?
    end

    private

    def send_message(message)
      tries = 0

      begin
        if tcp_socket
          tcp_socket.puts message
        end
      rescue Errno::EPIPE
        disconnect
        if tries < 2
          tries += 1
          retry if reconnect
        end
      end
    end

    def disconnect
      @tcp_socket = nil
    end

    def tcp_socket
      @tcp_socket
    end

    def reconnect
      @tcp_socket = TCPSocket.new(hostname, port)
    rescue Errno::ECONNREFUSED
      false
    end
  end
end
