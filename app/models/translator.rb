class Translator < ActiveRecord::Base
	#validates_uniqueness_of :email

	has_and_belongs_to_many :languages
	has_many :assignments, :dependent => :destroy
	attr_accessor :raw_languages

	def save
		languages.clear
		raw_languages.each do |id|
			languages << Language.find(id)
		end
		super
	end
end
