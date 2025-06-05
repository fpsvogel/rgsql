# TCP server for rgSQL from the book Build a Database Server.
#
# Run the server with `bin/server` or `bin/s`
# Then visit http://localhost:3003 in your browser or run `curl -v http://localhost:3003`

require "socket"
require_relative "live_reloader"

class Server
  DEFAULT_PORT = 3003 # 4000
  START_MESSAGE = "Server is running"

  attr_reader :port

  def initialize(port: DEFAULT_PORT)
    @port = port || DEFAULT_PORT
  end

  def start
    server = TCPServer.new(port)
    puts "#{START_MESSAGE} on port #{port}..."

    LiveReloader.start

    loop do
      client = server.accept
    # request = Request.new(client)
    # puts request
    # puts
    # response = Response.new(
    #   "Hello Response!",
    #   headers: {"Content-Language" => "en"}
    # )
    # puts response
    # puts
    # client.write(response.to_s)
    # rescue Request::InvalidRequestError => e
    #   response = Response.new(
    #     "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}",
    #     status: 400,
    #     message: "Bad Request"
    #   )
    #   client&.write(response.to_s)
    #   puts response
    #   puts
    #   next
    rescue => e
      response = Response.new(
        "#{e.class}: #{e.message}\n#{e.backtrace.join("\n")}",
        status: 500,
        message: "Internal Server Error"
      )
      client&.write(response.to_s)
      raise e
    ensure
      client&.close
    end
  end
end
