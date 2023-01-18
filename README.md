# Raygun4WP Testing
This repository provides some automated integration testing for the [Raygun4WP provider](https://github.com/MindscapeHQ/raygun4wordpress).

---

# Setup
*Requires Docker*
1. Create a Raygun application and insert your API key into `settings.env`.
2. Choose whether to target a specific branch of the provider repository or to use the distributed version in `settings.env`.
3. If needed, use `docker compose --profile update up` to automatically update the provider submodule from the branch specified.
4. Use `docker compose --profile test up` to run testing on the Raygun4WP provider!

After the automated server-side testing has completed, you will be prompted to visit the site in your browser. Complete the client-side testing by clicking each of the buttons displayed. Finally, compare your results (now located in the Raygun app) with the expected results below.

***Note:*** *If you need to test against a specific version of WordPress, that can be specified in `docker-compose.yml` line 33.*

---

# Expected Results
#### In the Crash Reporting tab

---

These 9 unique errors should appear, 4 of which should have 2 occurances (highlighted):\
![1_Errors](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/1_Errors.png)

---

Inspecting any error should show the user "test" (@raygun.com):\
![2_User](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/2_User.png)

---

Inspecting the structure of the ***errors by second*** graph by closing in the timeframe, e.g...\
![3_Timeframe](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/3_Timeframe.png)\
Should show some form of peak where async sending was enabled, e.g.\
![4_Graph](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/4_Graph.png)\
*Your graph will not be an identical match! A lack of a peak could be indicative of an asyc sending performance issue.*

---

Adding a tag filter for "serverside" (*Add filter &rarr; Tags &rarr; is one of*)...\
![5_Serverside Tag](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/5_Serverside%20Tag.png)\
Should yield these 5 unique errors.\
![6_Serverside Reports](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/6_Serverside%20Reports.png)

---

Adding a tag filter for "clientside"...\
![7_Clientside Tag](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/7_Clientside%20Tag.png)\
Should yield these 3 unique errors.\
![8_Clientside Reports](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/8_Clientside%20Reports.png)

---

Further inspecting one of these client-side errors (*e.g. "Manually sent error"*) should reveal breadcrumbs such as:\
![9_Breadcrumbs](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/9_Breadcrumbs.png)

---

#### In the Real User Monitoring tab

---

Inspecting the test session...\
![10_Session Location](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/10_Session%20Location.png)\
Should display these two page views and appropriate information:\
![11_RUM Session](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/11_RUM%20Session.png)

---

# Maintenance Documentation
If you intend to make changes, running `docker compose --profile clean up` removes the API key from settings.env (functionality can be extended in `clean.sh`).

### Docker Structure
![Structure Diagram](https://github.com/MindscapeHQ/raygun4wordpress-testing/blob/main/images/Structure%20Diagram.png)

## Explanations
### The raygun-testing plugin
This plugin is activated alongside the raygun4wp provider plugin that is to be tested. It adds an additional admin menu page (`test_page`) that can be posted to externally (e.g. from `run_tests.sh`). Any request to this page is checked for a `'test'` parameter. This parameter expects a string that corresponds to a testing function in `tests.php`, which will be subsequently executed. This means that adding a new test is as simple as adding a function to `tests.php` and posting to the `test_page` with the new test string.

The test page also contains a JavaScript component for client-side testing. This JavaScript code is to be executed by the tester's browser when they request the page.

### How run-tests.sh works
This script first prepares the testing environment by installing WordPress Core, copying in/installing the necessary plugins, activating them, and performing the admin login for the client. It is then able to run both "external tests" as a client (meaning tests that do not require new PHP code to be executed on the server) and server-side tests by posting to the `test_page` as described above. It includes the function `run-serverside-test()` for this very purpose, as well as `assert-equals()` for basic validation.
