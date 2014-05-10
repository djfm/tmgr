class TextExtractor
	def self.process uploaded_file
		text = if uploaded_file.content_type == "text/plain"
			File.read uploaded_file.path
		else
			Docx::Document.open(uploaded_file.path).to_s rescue nil
		end

		if text
			{valid: true}
		else
			{valid: false}
		end
	end
end