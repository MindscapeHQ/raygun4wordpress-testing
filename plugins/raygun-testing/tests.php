<?php

// Call the test function corresponding to the request parameter 'test'
if(isset($_REQUEST['test'])) {
	$test = $_REQUEST['test'];
	call_user_func($test);
}

/*----- Tests below -----*/

function test_manual_exception() {
	throw new Exception("Manually thrown Exception");
}

function test_manual_errorexception() {
	throw new ErrorException("Manually thrown ErrorException");
}

function test_error_handler_manually() {
	trigger_error("Error handler functions with trigger_error");
}
