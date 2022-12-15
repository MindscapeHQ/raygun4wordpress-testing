<?php

class ServersideTest extends WP_UnitTestCase
{

    public function testUncaughtException()
    {
        throw new Exception('TEST UNCAUGHT EXCEPTION');
        /*if (get_option('rg4wp_status') && function_exists('curl_version') && get_option('rg4wp_apikey')) {
            require_once '/test_plugin/external/raygun4php/src/Raygun4php/RaygunClient.php';
            $client = new Raygun4php\RaygunClient(get_option('rg4wp_apikey'), false, true);

            if (get_option('rg4wp_usertracking')) {
                $client->SetUser(get_option('user'));
            }

            $result = trim($client->SendError(404, 'Congratulations, Raygun4WP is working correctly!', '0', '0'));
            if ($result == 'HTTP/1.1 403 Forbidden') {
                echo 'The Raygun service did not accept your API key. Please check to see you have a entered a valid API key for an application and then save your changes.';
            } else if ($result == 'HTTP/1.1 202 Accepted') {
                echo 'Raygun has accepted the test issue. Check your <a href="http://app.raygun.com" target="_blank">dashboard</a> to see the issue details!';
            } else {
                echo 'Woops, the errors status was not reported. Check your <a href="http://app.raygun.com" target="_blank">dashboard</a> to see if your error has been reported. If the error doesn\'t appear make sure you have entered a valid API key for an application you have created and then try again.';
            }
        } else {
            echo 'Something is missing! Please check that you have enabled Serverside error tracking, the API key is pasted in and you have saved the settings.';
        }*/
        $this->assertTrue(true);
    }

    /* TODO: post settings to the setting page and confirm with get_options
    // https://stackoverflow.com/questions/70006997/access-host-from-within-a-docker-container
    public function testSettingsPage()
    {
        exec("curl -X POST -d \"option_page=rg4wp&action=update&_wpnonce=" . wp_create_nonce() . "&_wp_http_referer=%2Fwp-admin%2Fadmin.php%3Fpage%3Drg4wp-settings&rg4wp_apikey=" . getenv("API_KEY") . "&rg4wp_ignoredomains=&rg4wp_usertracking=1&rg4wp_status=1&rg4wp_js=1&rg4wp_404s=1&rg4wp_async=1&rg4wp_tags=&rg4wp_js_tags=&rg4wp_pulse=1&action=update&page_options=rg4wp_status%2Crg4wp_apikey%2Crg4wp_tags%2Crg4wp_404s%2Crg4wp_js%2Crg4wp_usertracking%2Crg4wp_ignoredomains%2Crg4wp_pulse%2Crg4wp_js_tags&submitForm=Save+Changes\" https://host.docker.internal:8000/wp-admin/options.php");
        exec("curl -X POST -d \"page=rg4wp-settings&settings-updated=true\" https://host.docker.internal:8000/wp-admin/admin.php");
        $this->assertTrue(true);
    }*/
}
