class Project < ActiveRecord::Base
	validates_uniqueness_of :title
	validates_presence_of :deadline

	has_many :resources, :dependent => :destroy
end
