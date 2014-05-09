class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.belongs_to :project
      t.belongs_to :user
      t.belongs_to :resource_type
      t.string :title
      t.timestamps
    end
  end
end
