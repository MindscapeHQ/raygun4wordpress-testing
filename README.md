Raygun4WP Testing
==========
Provides a local WordPress enviroment with a testing plugin for the Raygun4WP provider. The envirnoment can be composed for testing a specified branch of the [raygun4wordpress](https://github.com/MindscapeHQ/raygun4wordpress) repository, or instead for maintaining the testing plugin itself.

## Setup

1. Running `docker compose --profile update_submodule up` automatically updates the raygun4wordpress submodule from remote and changes the target branch if specified. To change the target provider branch, modify line 13 (`PROVIDER_BRANCH=...`) of the `docker-compose.yml` file.

2. Running `docker compose --profile testing up` creates the local WordPress environment. The provider plugin (Raygun4WP) as well as the testing plugin (Raygun Testing) are already included.

- **Alternative:** running `docker compose --profile cli_prepare up` runs `scripts/prepare.sh` with the WordPress CLI installed after the testing environment is initialized. You may modify this script as needed. *Note:* `prepare.sh` sleeps for 30 seconds before executing to ensure initialization on any machine. This build can be useful for maintaining the testing plugin itself. **If you do not require the WordPress CLI, just use the standard testing build.**

## Usage

With WordPress running locally, you can access the testing site by visiting `http://localhost:8000/` in your browser.
