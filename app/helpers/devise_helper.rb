module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?
    messages = resource.errors.full_messages
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    error_message(sentence, "alert-danger", messages)
  end

  def devise_error_messages?
    defined?(resource).present? && !resource.errors.empty?
  end

end
