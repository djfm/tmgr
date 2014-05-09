module ApplicationHelper
	module Bootstrap
		
		def addclasses hash, classes
			hash = hash || {}
			hash[:class]  = ((hash[:class] || "") + " #{classes}").strip
			hash 
		end

		def form_group left, right
			<<-eos
				<div class="form-group">
					#{left}
					<div class="col-lg-9">
						#{right}
					</div>
				</div>
			eos
			.html_safe
		end

		def bootstrap_form_for record, options = {}, &block
			options.merge! :builder => BootstrapFormBuilder, :html => addclasses(options[:html], 'form-horizontal')
			form_for record, options, &block
		end
	end

	include Bootstrap
end
