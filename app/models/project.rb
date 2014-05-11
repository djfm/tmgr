class Project < ActiveRecord::Base
	validates_uniqueness_of :title
	validates_presence_of :deadline
	validates_presence_of :user
	validates_presence_of :project_status


	has_many :resources, :dependent => :destroy
	belongs_to :user
	belongs_to :project_status
end
