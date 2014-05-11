class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
    	t.belongs_to :translator
    	t.belongs_to :language
    	t.belongs_to :resource
		t.timestamps
    end
  end
end
