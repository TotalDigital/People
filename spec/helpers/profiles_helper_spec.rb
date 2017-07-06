require 'rails_helper'

RSpec.describe ProfilesHelper, type: :helper do
  let(:user) { create(:user, twitter: "plop") }
  let(:user_decorator) { UserDecorator.decorate(user) }

  describe "contact_info_input(user_decorator, attribute)" do
    context "when attribute has a label method" do
      it "returns a remote input html" do
        expected_html_content = <<~HTML
          <span class="twitter_user_decorator_#{user.id}">
            <a class="btn btn-default btn-sm" target="_blank" href="https://twitter.com/plop"><span class="glyphicon glyphicon-link"></span> Twitter</a>
          </span>
          <span class="twitter_user_decorator_#{user.id}">
            <a class="edit-link glyphicon glyphicon-pencil" data-inputs-class="twitter_user_decorator_#{user.id}" href=""></a>
          </span>
          <form class="hidden twitter_user_decorator_#{user.id}" style="display: inline-block;" id="edit_user_#{user.id}" action="/p/#{user.slug}.js" accept-charset="UTF-8" data-remote="true" method="post">
            <input name="utf8" type="hidden" value="&#x2713;" />
            <input type="hidden" name="_method" value="patch" />
            <input class="js-edit-field" placeholder="@username" type="text" value="plop" name="user[twitter]" id="user_twitter" />
          </form>
        HTML
        returned_html_content = contact_info_input(user_decorator, :twitter, true)
        expect(html_squish(returned_html_content)).to eq html_squish(expected_html_content)
      end
    end

    context "when attribute does not have a label method" do
      it "returns a missing attribute span" do
        expected_html_content = <<~HTML
          <i>Label method missing for entity</i>
        HTML
        returned_html_content = contact_info_input(user_decorator, :entity, true)
        expect(html_squish(returned_html_content)).to eq html_squish(expected_html_content)
      end
    end
  end

  describe "remote_input(obj, attribute, url_objects)" do
    let(:job) { create(:job, user: user, title: "Senior Metrics Manager") }

    it "returns a remote input" do
      expected_html_content = <<~HTML
        <span class="title_job_#{job.id}">
          <span>Senior Metrics Manager</span>
        </span>
        <span class="title_job_#{job.id}">
          <a class="edit-link glyphicon glyphicon-pencil" data-inputs-class="title_job_#{job.id}" href=""></a>
        </span>
        <form class="hidden title_job_#{job.id}" style="display: inline-block;" id="edit_job_#{job.id}" action="/p/#{user.slug}/jobs/#{job.id}.js" accept-charset="UTF-8" data-remote="true" method="post">
          <input name="utf8" type="hidden" value="&#x2713;" />
          <input type="hidden" name="_method" value="patch" />
          <input class="js-edit-field" placeholder="" type="text" value="Senior Metrics Manager" name="job[title]" id="job_title" />
        </form>
      HTML
      returned_html_content = remote_input(job, :title, [user, job], update_policy: true)
      expect(html_squish(returned_html_content)).to eq html_squish(expected_html_content)
    end
  end

  def html_squish(string)
    string.squish.gsub("> <", "><")
  end
end
