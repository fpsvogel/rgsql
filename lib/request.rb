class Request
  InvalidRequestError = Class.new(StandardError)
  INTEGER_OR_BOOLEAN_VALUE = %r{\A
    (?:
      (?<integer>-?\d+)
      |
      (?<boolean>TRUE|FALSE)
    )
    (?:
      \s+AS\s+
      (?<column_name>[a-z_][a-z_\d]*)
    )?
  \z}x

  attr_reader :raw_request, :values, :aliases, :error_message

  def initialize(raw_request)
    @raw_request = raw_request
    parse!
  end

  private

  def parse!
    @values, @aliases = raw_request
      .sub!(/\ASELECT\s*/, "")
      .tap { (raise InvalidRequestError, "Unknown statement") if it.nil? }
      .delete_suffix!(";\0")
      .tap { (raise InvalidRequestError, "Statement not terminated") if it.nil? }
      .split(/\s*,\s*/)
      .map { |value_and_alias|
        value_and_alias.match(INTEGER_OR_BOOLEAN_VALUE) { |match|
          if match[:integer]
            [match[:integer].to_i, match[:column_name]]
          elsif match[:boolean]
            [match[:boolean] == "TRUE", match[:column_name]]
          end
        } || (raise InvalidRequestError, "Invalid alias: #{value_and_alias}")
      }
      .transpose
  rescue InvalidRequestError => e
    @error_message = e.message
  end
end
