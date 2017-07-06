class PhoneNumberValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    unless value.blank? || Format.new(value).valid?
      record.errors[attribute] << (options[:message] || (I18n.t'validators.phone_format'))
    end
  end

  class Format
    def initialize(phone_number)
      @phone_number = phone_number
    end

    def valid?
      Phonelib.parse(phone_number).valid?
    end

    attr_accessor :phone_number
  end
end
