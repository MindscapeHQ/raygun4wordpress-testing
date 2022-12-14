<?php

class ServersideTest extends WP_UnitTestCase
{
    public static function set_up_before_class()
    {
        parent::set_up_before_class();
        /*
        $rg4wp_apikey = "rg4wp_apikey=" . getenv("API_KEY");
        rg4wp_usertracking
        rg4wp_status // server side
        rg4wp_js // client side
        rg4wp_404s // missing pages
        rg4wp_async
        rg4wp_tags // server side tags
        rg4wp_js_tags // client side tags
        rg4wp_pulse // rum
        */
        print "curl -X POST -d \"rg4wp_apikey=" . getenv("API_KEY") . "&submitForm=submit\" " . esc_url(admin_url('settings.php'));
        exec("curl -X POST -d \"rg4wp_apikey=" . getenv("API_KEY") . "&submitForm=submit\" " . esc_url(admin_url('settings.php')));
    }

    public function testAssertTrue()
    {
        print exec("curl " . esc_url(admin_url('settings.php')));
        $this->assertTrue(true);
    }
}
