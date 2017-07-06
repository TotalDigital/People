class InternalIdValidator < ActiveModel::EachValidator
  REGEX = People.internal_id_regex || /./

  def validate_each(record, attribute, value)
    unless value.blank? || Format.new(value).valid?
      record.errors[attribute] << (options[:message] || (I18n.t'validators.internal_id_format'))
    end
  end

  class Format
    def initialize(internal_id)
      @internal_id = internal_id
    end

    def valid?
      internal_id[REGEX].present?
    end

    attr_accessor :internal_id
  end
end
