module Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch
    pg_search_scope :attributes_cont_any,
                    against:            {
                        first_name:     'A',
                        last_name:      'A',
                        job_title:      'B',
                        email:          'C',
                        phone:          'C',
                        office_address: 'B',
                        internal_id:    'C',
                        wat_link:       'C',
                        entity:         'B'},
                        using: {
                          tsearch: {
                            dictionary: "english",
                            prefix:     true
                          }
                        },
                    associated_against: {
                      skills: :name,
                      languages: :name,
                      projects: [:name, :location],
                      jobs: [:title, :location, :description]
                    },
                    ignoring: :accents

    pg_search_scope :first_name_or_last_name_or_email_cont_any,
                    against:            {
                        first_name:     'A',
                        last_name:      'A',
                        email:          'C'},
                        using: {
                          tsearch: {
                            dictionary: "english",
                            prefix:     true
                          }
                        },
                    ignoring: :accents


    def self.search(query, scope_name)
      if query.present?
        send(scope_name, query)
      else
        []
      end
    end

  end
end
