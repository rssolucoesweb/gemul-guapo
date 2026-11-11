<!-- the #js-page-content id is needed for some plugins to initialize -->
<main id="js-page-content" role="main" class="page-content">
	<ol class="breadcrumb page-breadcrumb">
		<li class="breadcrumb-item"><a href="javascript:void(0);">GEMUL</a></li>
		<li class="breadcrumb-item">Acadêmico</li>
		<li class="breadcrumb-item active">Basic Inputs</li>
		<li class="position-absolute pos-top pos-right d-none d-sm-block"><span class="js-get-date"></span></li>
	</ol>
	<div class="subheader">
		<h1 class="subheader-title">
			<i class='subheader-icon fal fa-edit'></i> Basic Inputs
			<small>
				Default input elements for forms
			</small>
		</h1>
	</div>
	<div class="row">
		<div class="col-xl-6">
			<div id="panel-1" class="panel">
				<div class="panel-hdr">
					<h2>
						General <span class="fw-300"><i>inputs</i></span>
					</h2>
					<div class="panel-toolbar">
						<button class="btn btn-panel" data-action="panel-collapse" data-toggle="tooltip" data-offset="0,10" data-original-title="Collapse"></button>
						<button class="btn btn-panel" data-action="panel-fullscreen" data-toggle="tooltip" data-offset="0,10" data-original-title="Fullscreen"></button>
						<button class="btn btn-panel" data-action="panel-close" data-toggle="tooltip" data-offset="0,10" data-original-title="Close"></button>
					</div>
				</div>
				<div class="panel-container show">
					<div class="panel-content">
						<div class="panel-tag">
							Be sure to use an appropriate type attribute on all inputs (e.g., code <code>email</code> for email address or <code>number</code> for numerical information) to take advantage of newer input controls like email verification, number selection, and more.
						</div>
						<form>
							<div class="form-group">
								<label class="form-label" for="simpleinput">Text</label>
								<input type="text" id="simpleinput" class="form-control">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-email-2">Email</label>
								<input type="email" id="example-email-2" name="example-email-2" class="form-control" placeholder="Email">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-password">Password</label>
								<input type="password" id="example-password" class="form-control" value="password">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-palaceholder">Placeholder</label>
								<input type="text" id="example-palaceholder" class="form-control" placeholder="placeholder">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-textarea">Text area</label>
								<textarea class="form-control" id="example-textarea" rows="5"></textarea>
							</div>
							<div class="form-group">
								<label class="form-label" for="example-static">Static control</label>
								<input type="text" readonly="" class="form-control-plaintext" id="example-static" value="email@example.com">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-helping">Helping text</label>
								<input type="text" id="example-helping" class="form-control" placeholder="Helping text">
								<span class="help-block">
									A block of help text that breaks onto a new line and may extend beyond one line.
								</span>
							</div>
							<div class="form-group">
								<label class="form-label" for="example-select">Input Select</label>
								<select class="form-control" id="example-select">
									<option>1</option>
									<option>2</option>
									<option>3</option>
									<option>4</option>
									<option>5</option>
								</select>
							</div>
							<div class="form-group">
								<label class="form-label" for="example-multiselect">Multiple Select</label>
								<select id="example-multiselect" multiple="" class="form-control">
									<option>1</option>
									<option>2</option>
									<option>3</option>
									<option>4</option>
									<option>5</option>
								</select>
							</div>
							<div class="form-group">
								<label class="form-label" for="example-fileinput">Default file input</label>
								<input type="file" id="example-fileinput" class="form-control-file">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-datetime-local-input">Date and time</label>
								<input class="form-control" type="datetime-local" value="2023-07-23T11:25:00" id="example-datetime-local-input">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-date">Date</label>
								<input class="form-control" id="example-date" type="date" name="date" value="2023-07-23">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-month">Month</label>
								<input class="form-control" id="example-month" type="month" name="month">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-week">Week</label>
								<input class="form-control" id="example-week" type="week" name="week">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-time-2">Time</label>
								<input class="form-control" id="example-time-2" type="time" name="time">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-time-3">Time</label>
								<input class="form-control" id="example-time-3" type="time" name="time">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-number">Number</label>
								<input class="form-control" id="example-number" type="number" name="number" value="839473">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-color">Color</label>
								<input class="form-control" id="example-color" type="color" name="color" value="#727cf5">
							</div>
							<div class="form-group">
								<label class="form-label" for="example-range">Range</label>
								<input class="form-control" id="example-range" type="range" name="range" min="0" max="100">
							</div>
							<div class="form-group">
								<label class="form-label" for="customRange2">Range (custom)</label>
								<input type="range" class="custom-range" id="customRange2">
							</div>
							<div class="form-group">
								<label class="form-label">Select (custom)</label>
								<select class="custom-select form-control">
									<option selected="">Open this select menu</option>
									<option value="1">One</option>
									<option value="2">Two</option>
									<option value="3">Three</option>
								</select>
							</div>
							<div class="form-group mb-0">
								<label class="form-label">File (Browser)</label>
								<div class="custom-file">
									<input type="file" class="custom-file-input" id="customFile">
									<label class="custom-file-label" for="customFile">Choose file</label>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</main>
<!-- this overlay is activated only when mobile menu is triggered -->
<div class="page-content-overlay" data-action="toggle" data-class="mobile-nav-on"></div>