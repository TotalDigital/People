class UrlValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || I18n.t('validators.url_format', url_format: url_format(attribute)) ) unless value.blank? || url_valid?(value)
  end

  def url_valid?(url)
    url = URI.parse(url) rescue false
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
  end

  def url_format(attribute)
    case attribute
    when :linkedin
      "https://www.linkedin.com/in/username"
    else
      "http://..."
    end
  end
end
