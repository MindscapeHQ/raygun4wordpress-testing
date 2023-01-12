## The raygun-testing plugin
This plugin is activated alongside the raygun4wordpress provider plugin that is to be tested. It adds an additional admin menu page (`test_page`) that can be posted to externally (e.g. from `run_tests.sh`). Any request to this page is checked for a `'test'` parameter. This parameter expects a string that corresponds to a testing function in `tests.php`, which will be subsequently executed.

This means that adding a new test is as simple as adding a function to `tests.php` and posting to the `test_page` with the new `test` string.

## How run-tests.sh works
This script first prepares the testing environment by installing WordPress Core, copying in the necessary plugins, activating them, and performing the admin login for the client. It is then able to run both "external tests" as a client (meaning tests that do not require new PHP code to be executed on the server) and server-side tests by posting to the `test_page`. It includes the function `run-serverside-test()` for this very purpose, as well as `assert-equals()` for basic validation.
