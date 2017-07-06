module DatesHelper

  def month_collection
    (1..12).map do |id|
      [(I18n.t'date.month_names')[id], id]
    end
  end

  def year_collection
    (1975..Time.now.year).to_a.reverse
  end

  def formatted_start_date(date)
    date.present? ? "#{ I18n.t'date.from'} #{ I18n.l(date, format: :month_and_year) }" : (I18n.t'date.unknown')
  end

  def formatted_end_date(date)
    date.present? ? "#{ I18n.t'date.to'} #{ I18n.l(date, format: :month_and_year) }" : "(#{I18n.t'date.current'})"
  end
end
