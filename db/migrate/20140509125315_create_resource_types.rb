class CreateResourceTypes < ActiveRecord::Migration
  def change
    create_table :resource_types do |t|
      t.string :key
      t.string :name

      t.timestamps
    end
  end
end
