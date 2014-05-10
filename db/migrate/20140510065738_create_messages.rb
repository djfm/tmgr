class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :key
      t.string :message
      t.text :comments
      t.belongs_to :resource

      t.timestamps
    end
  end
end
