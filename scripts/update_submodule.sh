#!/etc/env ash

cd /repository

echo "Cleaning raygun-testing"
for file in raygun4wordpress/* raygun4wordpress/.*; do
  [ -e raygun-testing/"$file" ] || continue
  file="$(basename -- $file)"
  case "$file" in "."|"..") continue ;; esac
  rm -rf raygun-testing/"$file"
done

echo "Updating raygun4wordpress submodule"
git submodule--helper set-branch -b ${PROVIDER_BRANCH} raygun4wordpress
git submodule update --init --remote

echo "Merging raygun4wordpress into raygun-testing"
for file in raygun4wordpress/*; do
  cp -rf "$file" raygun-testing
done
