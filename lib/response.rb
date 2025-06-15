require "json"

class Response
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def to_json
    if request.error_message.nil?
      {
        status: "ok",
        rows: [request.values].compact,
        column_names: request.aliases || []
      }.to_json
    else
      {
        status: "error",
        error_type: "parsing_error",
        error_message: request.error_message
      }.to_json
    end
  end
end
