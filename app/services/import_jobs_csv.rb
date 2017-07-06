class ImportJobsCSV
  include CSVImporter

  model Job

  column :title
  column :start_date
  column :end_date
  column :description
  column :location
  column :email, to: -> (email, job) { job.user = User.find_by(email: email)}

  when_invalid :skip

  after_build do |job|
    skip! if job.user_id.blank? || job.user.jobs.any?
  end
end
