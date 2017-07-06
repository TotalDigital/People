class SchoolsController < ApplicationController
  autocomplete :school, :name, full: true
end
