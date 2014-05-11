class Language < ActiveRecord::Base
	has_and_belongs_to_many :resources
	has_and_belongs_to_many :translators
	has_many :assignments, :dependent => :destroy
end
