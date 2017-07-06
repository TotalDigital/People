module API
  module V1
    class Base < Grape::API
      mount API::V1::Users
      mount API::V1::Languages
      mount API::V1::Skills
      mount API::V1::Schools
      mount API::V1::Degrees
      mount API::V1::Relationships
      mount API::V1::Projects
      mount API::V1::ProjectParticipations
      mount API::V1::Jobs
      mount API::V1::Statistics
    end
  end
end
