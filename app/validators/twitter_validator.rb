class TwitterValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.blank? || Format.new(value).valid?
      record.errors[attribute] << (options[:message] || (I18n.t'validators.valid_twitter'))
    end
  end

  class Format
    BASE_URL = "https://twitter.com/"

    def initialize(string)
      @string = string.try(:downcase)
    end

    def valid?
      username.present?
    end

    def username
      if string.length <= 15 && !string.match(/\W/)
        string
      else string.include?("twitter") || string.include?("@")
        string[/(?<=twitter.com\/|@).\w{1,15}/]
      end
    end

    attr_accessor :string
  end
end
