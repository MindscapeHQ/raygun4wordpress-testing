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

register_activation_hook(__FILE__, 'rg4wptesting_install');
add_action('admin_init', 'rg4wptesting_register_settings');
add_action('admin_menu', 'add_test_page');
add_action('plugins_loaded', 'on_rg4wp_active');

function add_test_page() {
	add_menu_page('RaygunTesting', 'RaygunTesting', 'administrator', 'test_page', 'load_tests');
}

function load_tests() {
	include dirname(__FILE__).'/tests.php';
}

function rg4wptesting_install() {
	add_option('rg4wptesting_test_post_id', 0);
	add_option('rg4wptesting_crash_shutdown', 0);
	update_option('rg4wptesting_crash_shutdown', 0);
}

function rg4wptesting_register_settings() {
	register_setting('rg4wptesting', 'rg4wptesting_test_post_id');
	register_setting('rg4wptesting', 'rg4wptesting_crash_shutdown');
}

function on_rg4wp_active() {
	// Crash the site if requested...
	if (1 == get_option('rg4wptesting_crash_shutdown')) {
		@require "thisDoesNotExist.php";
	}
}
