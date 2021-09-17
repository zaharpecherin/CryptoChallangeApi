require 'net/http'

API_ENDPOINT ||= 'https://api.nomics.com/v1'

class CryptoService
  include HttpStatusCodes
  include ApiExceptions

  def request(endpoint:, params: {})
    uri = URI(API_ENDPOINT + endpoint)
    uri.query = URI.encode_www_form(authenticated_params(params))
    @response = Net::HTTP.get_response(uri)
    return @response.body if response_successful?

    raise error_class, "Code: #{@response.code}, response: #{@response.body}"
  end

  def self.specific_attributes
    JSON.parse(self).map{ |object| object.slice("circulating_supply", "max_supply", "name", "symbol", "price") }
  end

  def error_class
    case @response.code
    when HTTP_BAD_REQUEST_CODE
      BadRequestError
    when HTTP_UNAUTHORIZED_CODE
      UnauthorizedError
    when HTTP_FORBIDDEN_CODE
      ForbiddenError
    when HTTP_NOT_FOUND_CODE
      NotFoundError
    when HTTP_UNPROCESSABLE_ENTITY_CODE
      UnprocessableEntityError
    else
      ApiError
    end
  end

  def response_successful?
    @response.code == HTTP_OK_CODE
  end

  def authenticated_params(params)
    params[:key] = ENV['API_KEY']
    params
  end
end
