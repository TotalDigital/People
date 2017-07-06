require 'pry'
require 'yaml'
require 'fileutils'

class SetupGenerator < Rails::Generators::Base

  INITIALIZER_PATH = "config/initializers/people.rb"

  ATTRIBUTE_QUESTIONS = {
    "email"                 => "Please enter an email for Admin",
    "password"              => "Please choose a password",
    "password_confirmation" => "Please confirm password",
    "first_name"            => "What's your first_name?",
    "last_name"             => "What's your last_name?"
  }

  SETTING_QUESTIONS = {
    "app_owner" => "What's your organization ?",
    "app_name"  => "How would you like to call your app ?",
    "default_mailer" => "Please choose sender default email for all automatic app-related emails",
    "default_locale" => "Please choose your default language (fr or en)"
  }

  DEFAULT_SETTINGS = {
    "app_owner" => "My organisation",
    "app_name"  => "My app name",
    "default_mailer" => "admin@my_app.fr",
    "default_locale" => "en"
  }

  def set_up
    puts "Welcome to People"
    collect_settings
    delete_settings_file if File.exist?(INITIALIZER_PATH)
    create_settings_file(config_file_content)
    puts "Your app is now set up"
    create_admin
    puts "You can now launch your server with : 'bundle exec rails s'"
  end

  private

  def create_settings_file(file_content)
    create_file INITIALIZER_PATH, file_content
  end

  def delete_settings_file
    File.delete(INITIALIZER_PATH)
  end

  def collect_settings
    @answers = Hash.new
    SETTING_QUESTIONS.each do |setting, question|
      @answers[setting] = ask_question(question)
    end
  end

  def create_admin
    user = User.new(role: "admin")
    user.skip_confirmation!
    ATTRIBUTE_QUESTIONS.each do |user_attr, question|
      answer = ask_question(question)
      user.assign_attributes(user_attr => answer)
    end

    until user.save do
      puts user.errors.full_messages
      user.errors.keys.each do |user_attr|
        answer = ask_question(ATTRIBUTE_QUESTIONS[user_attr.to_s])
        user.assign_attributes(user_attr => answer)
      end
    end

    puts "Congratulations"
  end

  def ask_question(question)
    puts question
    gets.chomp
  end

  def config_file_content
    <<~HEREDOC
      People.config do |config|

        # app_owner => Organization that owns the app
        config.app_owner = '#{ answer_or_default('app_owner') }'

        # app_name => Name mentionned on app welcome page and emails
        config.app_name = '#{ answer_or_default('app_name') }'

        # default_mailer => Email used as sender for all automatic emails
        config.default_mailer = '#{ answer_or_default('default_mailer') }'

        # default_locale => Only french & english translations available, add your own if needed
        config.default_locale = '#{ answer_or_default('default_locale') }'

        # internal_id_regex => Define a regex to validate your internal id
        config.internal_id_regex = /.*/

        # contact_info_attributes => List the contact info to dislay in the upper right box on the profile page
        config.contact_info_attributes = [:internal_id, :phone, :linkedin, :twitter]

        # protected_attributes => List the contact info that only admins can update
        config.protected_attributes = [:internal_id]
      end
    HEREDOC
  end

  def answer_or_default(field)
    @answers[field].blank? ? DEFAULT_SETTINGS[field] : @answers[field]
  end
end
