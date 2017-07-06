class UserDecorator < Draper::Decorator
  include ActionView::Context
  include ActionView::Helpers::UrlHelper
  include SpecificUserDecorator

  delegate_all

  CONTACT_INFO_ATTRIBUTES = People.contact_info_attributes

  def twitter_label
    link_to(twitter_url, class: "btn btn-default btn-sm", target: "_blank") do
      (content_tag(:span, "", class: "glyphicon glyphicon-link") + " Twitter")
    end unless twitter.blank?
  end

  def linkedin_label
    link_to(linkedin, class: "btn btn-default btn-sm", target: "_blank") do
      (content_tag(:span, "", class: "glyphicon glyphicon-link") + " Linkedin")
    end unless linkedin.blank?
  end

  def phone_label
    link_to(phone_number.international, "tel:#{phone_number.e164}") unless phone.blank?
  end

  def internal_id_label
    "#{I18n.t'activerecord.attributes.user.internal_id'} : #{internal_id}"
  end

  def twitter_url
    TwitterValidator::Format::BASE_URL + twitter
  end
end
