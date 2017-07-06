RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    begin
      DatabaseCleaner.start

      # https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#linting-factories
      #
      # Recommended usage of FactoryGirl.lint is to run this in a task before
      # your test suite is executed. Running it in a before(:suite), will
      # negatively impact the performance of your tests when running single
      # tests
      #
      # FactoryGirl.lint

    ensure
      DatabaseCleaner.clean
    end
  end
end
