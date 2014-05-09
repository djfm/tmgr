class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
	
	include ApplicationHelper::Bootstrap

	def email_field name, options = {}
		options = addclasses options, "form-control"
		super
	end

	def password_field name, options = {}
		options = addclasses options, "form-control"
		super
	end

	def label method, text = nil, options = {}, &block
		options = addclasses options, "control-label col-lg-3"
		super method, text, options, &block
	end

	def check_box label, options = {}
		<<-eos
			<div class="form-group">
				<div class="col-lg-9 col-lg-offset-3">
					<div class="checkbox">
						<label>
							#{super} #{label.to_s.humanize}
						</label>
					</div>
				</div>
			</div>
		eos
		.html_safe
	end

	def submit value=nil, options={}
		options = addclasses options, "btn btn-default"
		<<-eos
			<div class="form-group">
				<div class="col-lg-9 col-lg-offset-3">
					#{super}
				</div>
			</div>
		eos
		.html_safe
	end
end