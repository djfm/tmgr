class Message < ActiveRecord::Base
	validates_presence_of :message
	validates_uniqueness_of :key, :allow_nil => true, :allow_blank => true
	validates_uniqueness_of :message, :scope => :key
end
