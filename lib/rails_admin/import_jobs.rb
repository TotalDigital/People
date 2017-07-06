module RailsAdmin
  module Config
    module Actions
      class ImportJobs < RailsAdmin::Config::Actions::Base
        register_instance_option :collection? do
          true
        end

        register_instance_option :visible? do
          authorized? &&  bindings[:abstract_model].model_name == "Job"
        end

        register_instance_option :link_icon do
          'icon-folder-open'
        end
      end
    end
  end
end
