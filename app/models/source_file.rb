require 'fileutils'

class SourceFile < ActiveRecord::Base
	ROOT = 'source_files'

	after_destroy :delete_file

	def store_on_disk uf
		self.path = "#{ROOT}/#{id}#{File.extname uf.original_filename}"
		save
		FileUtils.mv uf.path, absolute_path
	end

	def absolute_path
		Rails.public_path.join(path)
	end

	private
		def delete_file
			FileUtils.rm absolute_path
		end
end
