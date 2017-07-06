class StripTwitterUsername
  def call
    User.where.not(twitter: nil).each do |user|
      username = TwitterValidator::Format.new(user.twitter).username
      user.update_columns(twitter: username)
    end
  end
end
