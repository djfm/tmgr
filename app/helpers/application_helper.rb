module ApplicationHelper
	module BootstrapExtension

		def addclasses hash, classes
			hash = hash || {}
			hash[:class]  = ((hash[:class] || "") + " #{classes}").strip
			hash 
		end

		def form_for record, options = {}, &block
			options[:html] ||= {}
			options[:html] =  addclasses options[:html], "form-horizontal"

			super record, options, &block
		end

		def email_field object_name, method, options
			options[:class] = ((options[:class]) || "") + " form-control"
			super object_name, method, options
		end

		def password_field object_name, method, options
			options[:class] = ((options[:class]) || "") + " form-control"
			super object_name, method, options
		end

		def label object_name, method, content_or_options = nil, options = nil, &block
			(content_or_options || options)[:class] = ((content_or_options || options)[:class] || "") + " control-label col-lg-3"
			super object_name, method, content_or_options, options, &block
		end

		def submit value, options
			form_group "<div class='col-lg-9'>&nbsp;</form-group>"
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
	end

	include BootstrapExtension
end
