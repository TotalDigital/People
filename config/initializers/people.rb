People.config do |config|

  # app_owner => Organization that owns the app
  config.app_owner = 'My App'

  # app_name => Name mentionned on app welcome page and emails
  config.app_name = 'My People App'

  # default_mailer => Email used as sender for all automatic emails
  config.default_mailer = 'admin@my-people-app.com'

  # default_locale => Only french & english translations available, add your own if needed
  config.default_locale = 'en'

  # internal_id_regex => Define a regex to validate your internal id
  config.internal_id_regex = /.*/

  # contact_info_attributes => List the contact info to dislay in the upper right box on the profile page
  config.contact_info_attributes = [:internal_id, :phone, :linkedin, :twitter]

  # protected_attributes => List the contact info that only admins can update
  config.protected_attributes = [:internal_id]
end
