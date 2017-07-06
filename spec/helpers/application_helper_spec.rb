require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe 'error_message(error_msg, alert_class, detailed_errors = [])' do
    context 'without details' do
      it 'returns html markup' do
        html_markup = <<-HTML
          <div class="alert alert--fullScreen alert-dismissable alert-danger" role="alert">
            <button type="button" class="close" data-dismiss="alert">
              <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
            </button>
            <span class="error-message">Lorem</span>

          </div>
        HTML

        expect( error_message('Lorem', 'alert-danger').gsub(/\s+/, "") ).to eq html_markup.html_safe.gsub(/\s+/, "")
      end
    end

    context 'with details' do
      it 'returns html markup' do
        html_markup = <<-HTML
          <div class="alert alert--fullScreen alert-dismissable alert-danger" role="alert">
            <button type="button" class="close" data-dismiss="alert">
              <span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
            </button>
            <span class="error-message">Lorem</span>
            <ul>
              <li>Error 1</li>
              <li>Error 2</li>
            </ul>
          </div>
        HTML

        expect( error_message('Lorem', 'alert-danger', ['Error 1', 'Error 2']).gsub(/\s+/, "") ).to eq html_markup.html_safe.gsub(/\s+/, "")
      end
    end
  end

  describe 'to_list(errors)' do
    it 'returns ul html markup' do
      expect(to_list(['Error 1', 'Error 2'])).to eq '<ul><li>Error 1</li><li>Error 2</li></ul>'
    end
  end
end
