module RelationshipsHelper

  def relationship_labels(relationship_kind)
    klass_labels = {
      "is_manager_of"   => "label-default",
      "is_managed_by"   => "label-warning",
      "is_assistant_of" => "label-warning",
      "is_assisted_by"  => "label-success",
      "is_colleague_of" => "label-primary"
    }
    content_tag(:span, (t"helpers.relationships.labels.#{relationship_kind}"), class: "label #{klass_labels[relationship_kind]}")
  end

  def relationship_titles
    {
      is_assistant_of: t('profiles.relations.assistant_of'),
      is_managed_by:   t('profiles.relations.managers'),
      is_assisted_by:  t('profiles.relations.assistant'),
      is_manager_of:   t('profiles.relations.team_members'),
      is_colleague_of: t('profiles.relations.colleagues')
    }
  end

  def modal_title(full_name, job_title)
    full_name_title = job_title.present? ? "#{full_name} (#{job_title})" : full_name
    content_tag :h4, (t'helpers.relationships.add_relation_with', person: full_name_title)
  end

  def add_or_remove_relationship_button(user, target)
    relationship = user.relationship_with(target)

    if relationship.nil? && policy(Relationship.new(user: user, target: target)).create?
      link_to new_relationship_path(relationship: {user_id: current_user.id, target_id: target.id}), { class: 'btn btn-primary', remote: true} do
        "#{t'helpers.relationships.add_relation'} <span class='glyphicon glyphicon-plus'></span>".html_safe
      end
    elsif relationship && policy(current_user.relationship_with(target)).destroy?
      content_tag :span do
        link_to current_user.relationship_with(target), method: :delete, format: :js, remote: true, class: 'btn btn-danger' do
          "<span class='glyphicon glyphicon-remove'></span> #{t'helpers.relationships.remove_relation'}".html_safe
        end
      end
    end
  end
end
