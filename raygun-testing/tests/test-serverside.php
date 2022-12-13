<?php

class ServersideTest extends WP_UnitTestCase
{
    public static function set_up_before_class()
    {
        parent::set_up_before_class();
        exec("curl -X POST -F 'rg4wp_apikey=" . getenv("API_KEY") . "' " . esc_url(admin_url('options.php')));
    }

    public function testAssertTrue()
    {
        $this->assertTrue(true);
        print $_GET['rg4wp_apikey'];
    }
}
