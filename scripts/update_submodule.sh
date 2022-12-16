#!/etc/env ash

cd /repository
git submodule--helper set-branch -b ${PROVIDER_BRANCH} html/wp-content/plugins/raygun4wordpress
git submodule--helper update --init --recursive