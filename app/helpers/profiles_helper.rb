module ProfilesHelper
  AVATAR_COLORS = [ "#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#34495e", "#16a085", "#27ae60", "#2980b9", "#8e44ad", "#2c3e50",
    "#f1c40f", "#e67e22", "#e74c3c", "#ecf0f1", "#95a5a6", "#f39c12", "#d35400", "#c0392b", "#bdc3c7", "#7f8c8d"]

  def contact_info_input(user_decorator, attribute, update_policy)
    begin
      field_content = remote_input(user_decorator, attribute, user_decorator,
        label: I18n.t("profiles.contact_info_labels.#{attribute}"),
        display_as: user_decorator.send("#{attribute}_label"),
        placeholder: (I18n.t"profiles.contact_info_placeholders.#{attribute}"),
        update_policy: update_policy
      )
    rescue NoMethodError => e
      if e.name.to_s == "#{attribute}_label"
        puts "\n WARNING : Label method missing. Please add '#{e.name}' method to user_decorator.rb \n\n"
        field_content = content_tag :i, "Label method missing for #{attribute}"
      else
        raise e
      end
    end
    field_content
  end

  def remote_input(obj, attribute, url_objects, input_type: nil, label: '', display_as: '', placeholder: '', update_policy: nil)
    render "shared/inputs/remote",
      obj: obj,
      attribute: attribute,
      input_type: input_type || :text_field,
      js_class: "#{attribute}_#{obj.class.to_s.underscore}_#{obj.id}",
      placeholder: placeholder, # Inside input
      display_as: display_as,   # When attribute value is present
      label: label,             # When attribute value is blank
      update_policy: update_policy || policy(obj).update?,
      url_objects: url_objects
  end

  def avatar(user, size, css_class='')
    if user.profile_picture_file_name
      image_tag user.profile_picture.url(size), class: "img-circle avatar--#{size} #{css_class}"
    else
      content_tag :div, "#{user.first_name[0]}#{user.last_name[0]}".upcase,
        class: "img-circle avatar avatar--#{size} #{css_class}",
        style: "background-color: #{AVATAR_COLORS[user.id%20]}"
    end
  end
end
