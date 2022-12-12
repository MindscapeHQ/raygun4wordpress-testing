#!/etc/env ash

cd /repository

echo "Cleaning raygun-testing"
for file in raygun4wordpress/* raygun4wordpress/.*; do
  file="$(basename -- $file)"
  case "$file" in "."|"..") continue ;; esac
  rm -rf raygun-testing/"$file"
done

if [ "${UPDATE}" == "true" ]; then
  echo "Updating raygun4wordpress submodule from branch \"${PROVIDER_BRANCH}\""
  git submodule--helper set-branch -b ${PROVIDER_BRANCH} raygun4wordpress
  git submodule--helper update --init --remote

  echo "Merging raygun4wordpress into raygun-testing (file copy)"
  for file in raygun4wordpress/*; do
    cp -r "$file" raygun-testing
  done
fi
