class PictureValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    temp_file = record.profile_picture.queued_for_write[:original]
    unless temp_file.nil? || right_format(temp_file)
      record.errors[attribute] << (options[:message] || (I18n.t'validators.picture_dimensions'))
    end
  end

  def right_format(file)
    dimensions = Paperclip::Geometry.from_file(file)
    width      = dimensions.width
    height     = dimensions.height
    width >= 180 && height >= 180
  end
end
