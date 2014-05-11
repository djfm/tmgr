class CreateLanguagesResources < ActiveRecord::Migration
  def change
    create_table :languages_resources do |t|
    	t.belongs_to :language
    	t.belongs_to :resource
    end
  end
end
