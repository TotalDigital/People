# == Schema Information
#
# Table name: domains
#
#  id        :integer          not null, primary key
#  name      :string
#  branch_id :integer
#

class Domain < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  belongs_to :branch

  def self.all_names
    Domain.all.map(&:name)
  end

  def self.authorized?(email)
    domain_regexes = Domain.all_names.map{ |name| /\w*#{Regexp.quote("@"+name)}\b/ }
    regex = Regexp.union(domain_regexes)
    email.match(regex).present?
  end

  def self.get_domain(email_address)
    email_address[/(?<=@)[^+]+/]
  end
end
