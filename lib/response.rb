class Response
  attr_reader :message

  def initialize(message = nil)
    @message = message
  end

  def to_s
    <<~END.chomp
      #{message}\0
    END
  end
end
