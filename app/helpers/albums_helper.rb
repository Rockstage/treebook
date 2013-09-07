module AlbumsHelper

	def can_edit_album?(album)
		signed_in? && current_user == album.user
	end

	def can_view_album?(album)
    	signed_in? && current_user == album.user
	end

	def album_thumbnail(album)
		if album.pictures.count > 0
			album.pictures.first.asset.url(:large)
		else
			"http://placekitten.com/260/180"
		end
	end
end
