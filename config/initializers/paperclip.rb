if Rails.env.production?
	Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
	Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
end
#	#Paperclip::Attachment.default_options[:url] = ':rails_root/public:url'
#	#Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
#end