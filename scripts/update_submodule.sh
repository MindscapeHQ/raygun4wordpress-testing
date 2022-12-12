#!/etc/env ash

echo "Updating submodule"
echo "Cleaning raygun-testing"
cd /repository
for file in raygun-testing/* raygun-testing/.*; do
  [ -e "$file" ] || continue
  file="$(basename -- $file)"
  case "$file" in "."|"..") continue ;; esac
  rm -rf raygun-testing/"$file"
done

#git submodule--helper set-branch -b ${PROVIDER_BRANCH} raygun4wordpress
#git submodule update --init --remote
#find raygun4wordpress ! ( -path "*/.git/*" -or -name ".git" ) -exec cp -rf -b --parent {} raygun-testing \;
