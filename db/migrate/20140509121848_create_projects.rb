class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.datetime :deadline
      t.text :comments

      t.timestamps
    end
  end
end
