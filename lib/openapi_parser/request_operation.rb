# binding request data and operation object

class OpenAPIParser::RequestOperation
  class << self
    # @param [OpenAPIParser::Config] config
    # @param [OpenAPIParser::PathItemFinder] path_item_finder
    # @return [OpenAPIParser::RequestOperation, nil]
    def create(http_method, request_path, path_item_finder, config, components)
      result = path_item_finder.operation_object(http_method, request_path)
      return nil unless result

      self.new(http_method, result, config, components.security_schemes)
    end
  end

  # @!attribute [r] operation_object
  #   @return [OpenAPIParser::Schemas::Operation]
  # @!attribute [r] path_params
  #   @return [Hash{String => String}]
  # @!attribute [r] config
  #   @return [OpenAPIParser::Config]
  # @!attribute [r] http_method
  #   @return [String]
  # @!attribute [r] original_path
  #   @return [String]
  # @!attribute [r] path_item
  #   @return [OpenAPIParser::Schemas::PathItem]
  attr_reader :operation_object, :path_params, :config, :http_method, :original_path, :path_item, :security_schemes

  # @param [String] http_method
  # @param [OpenAPIParser::PathItemFinder::Result] result
  # @param [OpenAPIParser::Config] config
  def initialize(http_method, result, config, security_schemes)
    @http_method = http_method.to_s
    @original_path = result.original_path
    @operation_object = result.operation_object
    @path_params = result.path_params || {}
    @path_item = result.path_item_object
    @config = config
    @security_schemes = security_schemes
  end

  def validate_security(security_schemes)
    operation_object.validate_security_schemes(security_schemes)
  end

  def validate_path_params(options = nil)
    options ||= config.path_params_options
    operation_object&.validate_path_params(path_params, options)
  end

  # @param [String] content_type
  # @param [Hash] params
  # @param [OpenAPIParser::SchemaValidator::Options] options
  def validate_request_body(content_type, params, options = nil)
    options ||= config.request_body_options
    operation_object&.validate_request_body(content_type, params, options)
    validate_security(security_schemes)
  end

  # @param [OpenAPIParser::RequestOperation::ValidatableResponseBody] response_body
  # @param [OpenAPIParser::SchemaValidator::ResponseValidateOptions] response_validate_options
  def validate_response_body(response_body, response_validate_options = nil)
    response_validate_options ||= config.response_validate_options

    operation_object&.validate_response(response_body, response_validate_options)
  end

  # @param [Hash] params parameter hash
  # @param [Hash] headers headers hash
  # @param [OpenAPIParser::SchemaValidator::Options] options request validator options
  def validate_request_parameter(params, headers, options = nil)
    options ||= config.request_validator_options
    operation_object&.validate_request_parameter(params, headers, options)
  end

  class ValidatableResponseBody
    attr_reader :status_code, :response_data, :headers

    def initialize(status_code, response_data, headers)
      @status_code = status_code
      @response_data = response_data
      @headers = headers
    end

    def content_type
      headers['Content-Type'].to_s.split(';').first.to_s
    end
  end
end
