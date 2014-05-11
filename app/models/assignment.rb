class Assignment < ActiveRecord::Base
	belongs_to :language
	belongs_to :translator
	belongs_to :resource

	validates_presence_of :language
	validates_presence_of :translator
	validates_presence_of :resource

	validates_uniqueness_of :translator, scope: [:language, :resource]
end
