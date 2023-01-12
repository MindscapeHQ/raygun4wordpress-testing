<?php
/**
 * Plugin Name:     Raygun Testing
 * Plugin URI:      https://raygun.com/
 * Description:     Provides testing for the Raygun4WP provider
 * Author:          Raygun
 * Author URI:      https://raygun.com/
 * Text Domain:     raygun-testing
 * Domain Path:     /languages
 * Version:         0.1.0
 *
 * @package         Raygun_Testing
 */

add_action('admin_menu', 'add_test_page');

function add_test_page() {
	add_menu_page('RaygunTesting', 'RaygunTesting', 'administrator', 'test_page', 'load_tests');
}

function load_tests() {
	include dirname(__FILE__).'/tests.php';
}
