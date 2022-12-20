Raygun4WP testing with `WP-UnitTestCase`
==========
**This is not the [Raygun4WP provider](https://github.com/MindscapeHQ/raygun4wordpress)!**

**NOTE:** This branch stores a discarded attempt at testing the Raygun4WP provider using `WP-UnitTestCase` functionality. Despite the name, [this is more of an integration test](https://www.nexcess.net/blog/understanding-wordpress-unit-testing-jargon/). The idea was to merge the Raygun4WP provider into `raygun-testing`, essentially setting up a test plugin with all of the required testing files. The tests would then be executed using Composer. Due to the lack of official documentation and missing convenience features, another strategy is to be used instead.

If this is ever revisited, these resources may be useful:
- [WordPress Advanced Unit Tests](https://www.codetab.org/tutorial/wordpress-plugin-development/unit-test/advanced-unit-tests/)
- [benlk's collection of notes on WP_UnitTestCase](https://gist.github.com/benlk/d1ac0240ec7c44abd393)
- [Unit Tests for WordPress Plugins - The Factory](https://pippinsplugins.com/unit-tests-for-wordpress-plugins-the-factory/)

## Setup

1. Modify `settings.env` to add the API key and change the target provider branch if necessary.

2. Run `docker compose --profile update up` to automatically update the `raygun4wordpress` submodule and merge it into `raygun-testing`.

3. Run `docker compose --profile test up` to run automated testing on the Raygun4WP provider.

## Maintenance

- Run `docker compose --profile clean up` to remove the API key and clean `raygun-testing` before pushing changes.
