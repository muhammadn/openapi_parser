class OpenAPIParser::SecuritySchemes
  # @param [OpenAPIParser::Schemas::SecuritySchemes] schemes
  def initialize(schemes)
    @schemes = schemes
  end

  # find operation object and if not exist return nil
  # @param [String, Symbol] http_method like (get, post .... allow symbol)
  # @param [String] request_path
  # @return [Result, nil]
  def security_scheme_object

    puts "schemes: #{@schemes}"
  end
end
