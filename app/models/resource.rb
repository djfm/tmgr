class Resource < ActiveRecord::Base
	validates_presence_of :title, :resource_type
	validate :messages_are_ok
	validate :file_is_ok
	validate :resource_type_is_ok

	belongs_to :resource_type
	belongs_to :project
	has_many :messages, :dependent => :destroy
	has_one :source_file, :dependent => :destroy
	has_and_belongs_to_many :languages
	has_many :assignments, :dependent => :destroy

	attr_accessor :raw_messages, :raw_file, :raw_languages

	def resource_type_is_ok
		if !resource_type
			@errors.add(:resource_type, 'is missing')
		elsif !['list_of_messages', 'text_file'].include? resource_type.key
			@errors.add(:resource_type, 'is invalid, weird')
		end
	end

	def messages_are_ok
		if resource_type.key == 'list_of_messages'
			if !@raw_messages
				errors.add(:list_of_messages, 'is required')
			else
				message_keys = {}
				keys = {}
				@raw_messages.each do |string|
					mk = "#{string[:message]}:#{string[:key]}"
					if message_keys[mk]
						errors.add(:base, "More than 1 definition of this string: #{string[:message]}")
						break
					else
						message_keys[mk] = true
					end
					unless string[:key].to_s == ''
						if keys[string[:key]]
							errors.add(:base, "More than 1 definition of this key: #{string[:key]}")
							break
						else
							keys[string[:key]] = true
						end
					end
				end
			end
		end
	end

	def file_is_ok
		if resource_type.key == 'text_file' and !id
			if raw_file
				res = TextExtractor.process(raw_file)
				if !res[:valid]
					@errors.add(:text_file, 'could not be read as a text file')
				end
			else
				@errors.add(:text_file, 'is required')
			end
		end
	end

	def save
		if ok = super
			languages.clear
			raw_languages.each do |id|
				languages << Language.find(id)
			end

			if resource_type.key == 'list_of_messages' and @raw_messages

				source_file.try :destroy

				if id
					messages.delete_all
				end

				@raw_messages.each do |message|
					messages.create message
				end

			elsif resource_type.key == 'text_file'

				messages.delete_all
				
				if raw_file
					source_file.try :destroy
					source_file = create_source_file
					source_file.store_on_disk raw_file
				end

			end

			languages.each do |l|
				unless assignment_for_language l
					if t = l.translators.first
						assignments.create :language_id => l.id, :translator_id => t.id
					end
				end
			end
		end

		return ok
	end

	def assignment_for_language language
		assignments.find_by_language_id(language.is_a?(Integer) ? language : language.id)
	end

	def isSourceFile
		resource_type.try(:key) == 'text_file'
	end
end
