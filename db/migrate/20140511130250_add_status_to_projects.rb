class AddStatusToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :project_status_id, :integer
  end
end
