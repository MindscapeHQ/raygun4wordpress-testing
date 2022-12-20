<?php

/*
 * NOTE: Testing Raygun4WP version 1.9 requires a slight modification to its main.php.
 * Global variables must be declared explicitly within PHPUnit.
 * This means that initialization of the RaygunClient (approx. line 169) must follow "global $client;"
 */

class ServersideTest extends WP_UnitTestCase
{

    public function testErrorHandlerManually()
    {
        $this->expectNotToPerformAssertions();
        trigger_error("Error handler functions with trigger_error");
    }

    /*public function testSettingsPagePost()
    {
        $this->expectNotToPerformAssertions();
        exec("curl -X POST -d \"option_page=rg4wp&action=update&_wpnonce=" . wp_create_nonce() . "&_wp_http_referer=%2Fwp-admin%2Fadmin.php%3Fpage%3Drg4wp-settings&rg4wp_apikey=" . getenv("API_KEY") . "&rg4wp_ignoredomains=&rg4wp_usertracking=1&rg4wp_status=1&rg4wp_js=1&rg4wp_404s=1&rg4wp_async=1&rg4wp_tags=&rg4wp_js_tags=&rg4wp_pulse=1&action=update&page_options=rg4wp_status%2Crg4wp_apikey%2Crg4wp_tags%2Crg4wp_404s%2Crg4wp_js%2Crg4wp_usertracking%2Crg4wp_ignoredomains%2Crg4wp_pulse%2Crg4wp_js_tags&submitForm=Save+Changes\" https://host.docker.internal:8000/wp-admin/options.php");
        exec("curl -X POST -d \"page=rg4wp-settings&settings-updated=true\" https://host.docker.internal:8000/wp-admin/admin.php");
    }*/

    public function testSendTestErrorPost()
    {
        $this->expectNotToPerformAssertions();
        $response = $this->post('/sendtesterror.php', [
            'rg4wp_status' => get_option('rg4wp_status'),
            'rg4wp_apikey' => get_option('rg4wp_apikey'),
            'rg4wp_usertracking' => get_option('rg4wp_usertracking'),
            'user' => 'testrunner'
        ]);
        print $response;
    }

    public static function tear_down_after_class()
    {
        print "\nRESULTS MUST NOW BE VERIFIED WITHIN THE RAYGUN APPLICATION: SEE README";
        print "\nASSUMING NO FAILURES BELOW:";
    }
}
