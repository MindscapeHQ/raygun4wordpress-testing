#!/etc/env ash

cd /repository
echo "Updating raygun4wordpress submodule from branch \"${PROVIDER_BRANCH}\""
git submodule--helper set-branch -b ${PROVIDER_BRANCH} raygun4wordpress
git submodule--helper update --init --recursive
