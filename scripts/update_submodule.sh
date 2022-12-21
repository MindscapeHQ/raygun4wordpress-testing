#!/etc/env ash

cd /repository
echo "Updating raygun4wordpress submodule from branch \"${PROVIDER_BRANCH}\""
#git submodule add https://github.com/MindscapeHQ/raygun4wordpress plugins/raygun4wordpress
git submodule--helper set-branch -b ${PROVIDER_BRANCH} plugins/raygun4wordpress
git submodule--helper update --init --recursive
