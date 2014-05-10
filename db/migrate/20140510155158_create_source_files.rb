class CreateSourceFiles < ActiveRecord::Migration
  def change
    create_table :source_files do |t|
      t.string :path
      t.string :segments
      t.string :words
      t.belongs_to :resource

      t.timestamps
    end
  end
end
