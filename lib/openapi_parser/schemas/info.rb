module OpenAPIParser::Schemas
  class Info < Base
    # @!attribute [r] title
    #   @return [String, nil]
    openapi_attr_value :title

    # @!attribute [r] version
    #   @return [String, nil]
    openapi_attr_value :version
  end
end
