# Raygun4WP Testing
This repository provides some automated integration testing for the [Raygun4WP provider](https://github.com/MindscapeHQ/raygun4wordpress).

---

# Setup
*Requires Docker*
1. Create a Raygun application and insert your API key into `settings.env`.
2. Choose whether to target a specific branch of the provider repository or to use the distributed version in `settings.env`.
3. If needed, use `docker compose --profile update up` to automatically update the provider submodule from the branch specified.
4. Use `docker compose --profile test up` to run testing on the Raygun4WP provider!

After the automated server-side testing has completed, you will be prompted to visit the site in your browser. Complete the client-side testing by clicking each of the buttons displayed. Finally, compare your results (in the Raygun app) with the results below.

---

# Expected Results
#### In the Crash Reporting tab

---

These 9 unique errors should appear, 4 of which should have 2 occurances (highlighted):\
![1_Errors](https://user-images.githubusercontent.com/57383574/213059443-22d8d484-a6cc-49b7-8044-f88f5f03c026.png)

---

Inspecting any error should show the user "test" (@raygun.com):\
![2_User](https://user-images.githubusercontent.com/57383574/213059599-0894f523-c79e-4535-ac5f-ca6f5f763695.png)

---

Inspecting the structure of the ***errors by second*** graph by closing in the timeframe, e.g...\
![3_Timeframe](https://user-images.githubusercontent.com/57383574/213059705-2173ba81-cb71-483b-98ef-24720addedbd.png)\
Should show some form of peak where async sending was enabled, e.g.\
![4_Graph](https://user-images.githubusercontent.com/57383574/213059940-11c8855a-cf61-43f6-ae8d-18168f9924e1.png)\
*Your graph will not be an identical match! A lack of a peak could be indicative of an asyc sending performance issue.*

---

Adding a tag filter for "serverside" (*Add filter &rarr; Tags &rarr; is one of*)...\
![5_Serverside Tag](https://user-images.githubusercontent.com/57383574/213060158-c3c9b1e4-b1f1-4b8b-8da5-2d2d5bc9a759.png)\
Should yield these 5 unique errors.\
![6_Serverside Reports](https://user-images.githubusercontent.com/57383574/213060399-19c92796-c2ce-4c8b-a83f-4c715f3ba192.png)

---

Adding a tag filter for "clientside"...\
![7_Clientside Tag](https://user-images.githubusercontent.com/57383574/213060437-eccf4885-e25e-424f-8183-62fd4e85b71b.png)\
Should yield these 3 unique errors.\
![8_Clientside Reports](https://user-images.githubusercontent.com/57383574/213060508-fc70d72b-5867-4d4d-bd0e-ca09891e247b.png)

---

Further inspecting one of these client-side errors (*e.g. "Manually sent error"*) should reveal breadcrumbs such as:\
![9_Breadcrumbs](https://user-images.githubusercontent.com/57383574/213060740-d9d5169a-d874-42a6-989c-44dfa359b460.png)

---

#### In the Real User Monitoring tab

---

Inspecting the test session...\
![10_Session Location](https://user-images.githubusercontent.com/57383574/213060783-e6a013b1-f1fc-4369-97f1-bbe41e761034.png)\
Should display these two page views and appropriate information:\
![11_RUM Session](https://user-images.githubusercontent.com/57383574/213060966-e90f8e0e-f0c1-41ea-ba8d-a707cd644ee9.png)

---

# Maintenance Documentation
If you intend to make changes, running `docker compose --profile clean up` removes the API key from settings.env (functionality can be extended in `clean.sh`).

### Docker Structure
![Structure Diagram](https://user-images.githubusercontent.com/57383574/213067555-6a875b25-917b-4c3c-a3f7-52cfec01dee8.png)

## Explanations
### The raygun-testing plugin
This plugin is activated alongside the raygun4wordpress provider plugin that is to be tested. It adds an additional admin menu page (`test_page`) that can be posted to externally (e.g. from `run_tests.sh`). Any request to this page is checked for a `'test'` parameter. This parameter expects a string that corresponds to a testing function in `tests.php`, which will be subsequently executed.

This means that adding a new test is as simple as adding a function to `tests.php` and posting to the `test_page` with the new `test` string.

### How run-tests.sh works
This script first prepares the testing environment by installing WordPress Core, copying in the necessary plugins, activating them, and performing the admin login for the client. It is then able to run both "external tests" as a client (meaning tests that do not require new PHP code to be executed on the server) and server-side tests by posting to the `test_page`. It includes the function `run-serverside-test()` for this very purpose, as well as `assert-equals()` for basic validation.
