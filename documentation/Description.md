## The "raygun-testing" Plugin
This plugin is activated alongside the raygun4wordpress provider plugin that is to be tested.
It adds an additional admin menu page (`test_page`) that can be posted to externally (e.g. from `run_tests.sh`).
Any request to this page is checked for a `'test'` parameter.
This parameter expects a string that corresponds to a testing function in `tests.php`, which will be subsequently executed.

This means that adding a new test is as simple as adding a function to `tests.php` and posting to the `test_page` with the new `test` string.
