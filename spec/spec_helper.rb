RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  # DatabaseCleaner strategies

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  # Doorkeeper helpers for API tests

  def create_doorkeeper_app(opts={})
    create_doorkeeper(opts)
    scopes    = opts && opts[:scopes] || 'public'
    @dk_token = Doorkeeper::AccessToken.create!(application_id: @dk_application.id, resource_owner_id: @dk_user.id, scopes: scopes)
  end

  def create_doorkeeper(opts={})
    @dk_user        = opts && opts[:user] || FactoryGirl.create(:user)
    @dk_application = Doorkeeper::Application.create(name: "DoorkeeperTestApp")
  end

end
