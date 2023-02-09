<?php
// Call the test function corresponding to the request parameter 'test'
if (isset($_REQUEST['test'])) {
	$test = $_REQUEST['test'];
	if (is_callable($test)) {
		call_user_func($test);
	}
}

/*----- Server-side Testing Below -----*/

function test_error_handler_manually() {
	// Unsure that the new error handler is being used
	trigger_error("Error handler functions with trigger_error");
}

function test_uncaught_error() {
	// Produce an uncaught array out of bounds error (undefined offset)
	$test_array = array("index 0", "index 1");
	echo "index out of bounds: " . $test_array[2];
}

function test_uncaught_exception() {
	throw new Exception("Manually thrown Exception");
}

function test_uncaught_errorexception() {
	throw new ErrorException("Manually thrown ErrorException");
}

function test_no_admin_tracking() {
	trigger_error("THIS ERROR SHOULD NOT APPEAR: Disable tracking on admin pages is non-functional!");
}

/*----- Client-side Testing Below -----*/

// Creates a post for the "Demonstrate RUM" button to direct to
function create_test_post() {
	if (get_option('rg4wptesting_test_post_id') == 0) {
		$test_post = array(
			'post_title' => 'VERIFY RESULTS IN THE RAYGUN APP',
			'post_content' => 'All results should now be visible in your Raygun app. Compare these with the expected results to manually validate testing.',
			'post_status' => 'publish',
			'post_author' => 1,
			'post_type' => 'post'
		);
		update_option('rg4wptesting_test_post_id', wp_insert_post($test_post));
		if (get_option('rg4wptesting_test_post_id') == 0) {
			trigger_error("THIS ERROR SHOULD NOT APPEAR: Test post could not be created!");
		}
	}
}
?>
<style>
	progress {
		width: 60%;
		height: 3rem;
	}
</style>
<body>
	<progress id="js-test-progress-bar" value="0" max="100"></progress>
	<div>
		<button onclick="this.disabled=true; testManualErrorSend();" class="button-primary">Send Manual Error</button>
		<button onclick="this.disabled=true; testErrorSend();" class="button-primary">Send Manual Exception</button>
		<button onclick="this.disabled=true; testUncaughtError();" class="button-primary">Send Uncaught Error</button>
		<button onclick="this.disabled=true; demonstrateRUM();" class="button-primary">Demonstrate RUM</button>
	</div>
	<script>
		function testManualErrorSend() {
			document.getElementById("js-test-progress-bar").value += 25;
			rg4js('send', {
				error: new Error('Manually sent error'),
			});
		}

		function testErrorSend() {
			document.getElementById("js-test-progress-bar").value += 25;
			try {
				eval("("); // Produces a syntax error
			} catch (e) {
				rg4js('send', e);
			}
		}

		function testUncaughtError() {
			document.getElementById("js-test-progress-bar").value += 25;
			throw new Error('Unhandled error');
		}

		function demonstrateRUM() {
			document.getElementById("js-test-progress-bar").value += 25;
			setTimeout(function () {
				window.location.href = window.location.protocol + window.location.hostname + '/?p=' + '<?php echo get_option('rg4wptesting_test_post_id');?>';
			}, 100);
		}
	</script>
</body>
