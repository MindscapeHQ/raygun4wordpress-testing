<?php

/*
 * NOTE: Testing Raygun4WP version 1.9 requires a slight modification to its main.php.
 * Global variables must be declared explicitly within PHPUnit.
 * This means that initialization of the RaygunClient (approx. line 169) must follow "global $client;"
 */

class ServersideTest extends WP_UnitTestCase
{
    /*
  * Helper function to set the current WordPress user
  * @param string $role The role of the user
  */
    public function setUser($role)
    {
        $current_user = get_current_user_id();
        wp_set_current_user(self::factory()->user->create(array('role' => $role)));
    }

    public function set_up()
    {
        update_option('siteurl', 'http://example.com');
    }

    public function testErrorHandlerManually()
    {
        $this->expectNotToPerformAssertions();
        trigger_error("Error handler functions with trigger_error");
    }

    public function testMenusAdded()
    {
        setUser('administrator');
        do_action('admin_menu');
        $this->assertNotEmpty(menu_page_url('rg4wp', false));
        $this->assertNotEmpty(menu_page_url('rg4wp-settings', false));
    }

    public static function tear_down_after_class()
    {
        print "\nRESULTS MUST NOW BE VERIFIED WITHIN THE RAYGUN APPLICATION: SEE README";
        print "\nASSUMING NO FAILURES BELOW:";
    }
}
