class GetLinkedinFullProfile

  def initialize(user)
    @base_url   = "https://api.linkedin.com/v1"
    @auth_token = user.linkedin_token
  end

  def call
    run_request
  end

  private
  attr_reader :base_url, :auth_token, :email

  def run_request
    response = request.run
    MultiJson.load(response.body).with_indifferent_access
  rescue StandardError => e
    Rails.logger.error e
    Rollbar.error(e)
    {}
  end

  def request
    Typhoeus::Request.new(url, method: :get)
  end

  def url
    "#{base_url}/people/~:(#{fields})?oauth2_access_token=#{auth_token}&format=json"
  end

  def fields
    ["headline", "summary", "positions", "public-profile-url", "specialties", "picture-urls::(original)"].join(",")
  end
end
