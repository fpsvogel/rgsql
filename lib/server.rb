# TCP server for rgSQL from the book Build a Database Server.
#
# Run the server with `bin/server` or `bin/s`
# Then visit http://localhost:3003 in your browser or run `curl -v http://localhost:3003`

require "socket"
require_relative "live_reloader"
require_relative "request"
require_relative "response"

class Server
  DEFAULT_PORT = 3003
  START_MESSAGE = "Server is running"

  attr_reader :port

  def initialize(port: DEFAULT_PORT)
    @port = port || DEFAULT_PORT
  end

  def start
    server = TCPServer.new(port)
    # puts "#{START_MESSAGE} on port #{port}..."

    LiveReloader.start

    socket = server.accept

    loop do
      raw_request = socket.gets("\0")
      break if raw_request.nil?

      request = Request.new(raw_request)
      response = Response.new(request)

      socket.print(response.to_json + "\0")
    rescue => e
      response = Response.new("Internal Server Error: #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}")
      socket.print(response)
      socket.close
      raise e
    end

    socket.close
  end
end
