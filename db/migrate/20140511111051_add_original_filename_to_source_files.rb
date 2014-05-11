class AddOriginalFilenameToSourceFiles < ActiveRecord::Migration
  def change
  	add_column :source_files, :original_filename, :string
  end
end
