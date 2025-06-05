class Request
  InvalidRequestError = Class.new(StandardError)

  private attr_reader :raw_request

  def initialize(raw_request)
    @raw_request = raw_request
    parse!
  end

  def to_s
    <<~END.chomp
      #{raw_request}
    END
  end

  private

  def parse!
  rescue => e
    raise InvalidRequestError, "Failed to parse request due to exception #{e.class}: #{e.message}\n#{e.backtrace.join("\n\t")}"
  end
end
