class Project < ActiveRecord::Base
	validates_uniqueness_of :title
	validates_presence_of :deadline
	validates_presence_of :user


	has_many :resources, :dependent => :destroy
	belongs_to :user
end
