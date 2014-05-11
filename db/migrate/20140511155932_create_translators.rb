class CreateTranslators < ActiveRecord::Migration
  def change
    create_table :translators do |t|
      t.string :email
      t.string :firstname
      t.string :lastname

      t.timestamps
    end

    create_table :languages_translators do |t|
    	t.belongs_to :language
    	t.belongs_to :translator
    end
  end
end
