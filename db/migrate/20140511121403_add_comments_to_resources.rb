class AddCommentsToResources < ActiveRecord::Migration
  def change
  	add_column :resources, :comments, :text
  end
end
