Raygun4WP Testing
==========
This repository provides automated testing for the [Raygun4WP](https://github.com/MindscapeHQ/raygun4wordpress) provider.

## Setup

1. Running `docker compose --profile update_submodule up` automatically updates the raygun4wordpress submodule from remote and changes the target branch if necessary. To change the target branch, modify line 13 (`PROVIDER_BRANCH=...`) of the `docker-compose.yml` file.

2. Running `docker compose --profile test up` runs automated testing on the Raygun4WP provider (from the submodule).
