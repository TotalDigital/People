module Datable
  extend ActiveSupport::Concern

  included do
    validate :end_date_after_start_date?
  end

  def current
    end_date.blank?
  end

  def end_date_after_start_date?
    if start_date.present? && end_date.present? && end_date < start_date
      errors.add :start_date, :must_be_previous_to, attribute: I18n.t('activerecord.attributes.job.end_date').downcase
    end
  end

  attr_reader :start_date_year, :start_date_month, :end_date_year, :end_date_month
end
