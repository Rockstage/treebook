module ApplicationHelper

	# Sends a message to the called object
	def bootstrap_paperclip_picture(form, paperclip_object)
		if form.object.send("#{paperclip_object}?")
			content_tag(:div, class: 'control-group') do
				content_tag(:label, "Current #{paperclip_object.to_s.titleize}", class: 'control-label') +
				content_tag(:div, class: 'controls') do
					image_tag form.object.send(paperclip_object).send(:url, :small)
				end
			end
		end
	end

	def bootstrap_paperclip_avatar(form, paperclip_object)
		if form.object.send("#{paperclip_object}?")
			content_tag(:div, class: 'control-group') do
				content_tag(:label, "Current #{paperclip_object.to_s.titleize}", class: 'control-label') +
				content_tag(:div, class: 'controls') do
					image_tag form.object.send(paperclip_object).send(:url, :thumb)
				end
			end
		end
	end

	def can_display_status?(status)
		signed_in? && !current_user.has_blocked?(status.user) || !signed_in?
	end

	def status_document_link(status)
		if status.document && status.document.attachment?
			content_tag(:span, "Attachment", class: "label label-info") +
			# link_to(image_tag(status.document.attachment.url), status.document.attachment.url, style: 'height: 300px;')
			link_to(status.document.attachment_file_name, status.document.attachment.url)
		end
	end

	def avatar_profile_link(user, image_options={}, html_options={})
		avatar_url = user.avatar? ? user.avatar.url(:avatar) : user.default_avatar
		link_to(image_tag(avatar_url, image_options), profile_path(user.profile_name), html_options)
	end

	def thumb_profile_link(user, image_options={}, html_options={})
		avatar_url = user.avatar? ? user.avatar.url(:thumb) : user.default_avatar
		link_to(image_tag(avatar_url, image_options), profile_path(user.profile_name), html_options)
	end

	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-info"
		else
			""
		end
	end
end
