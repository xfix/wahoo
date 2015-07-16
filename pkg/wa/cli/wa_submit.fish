# SYNOPSIS
#   Submit a package to the registry
#
# OPTIONS
#   name  Name of the package.
#   [url] URL to the package repository.

function wa_submit -a name url -d "Submit a package to the registry"
  switch (dirname $name)
    case pkg
    case themes
    case "*"
      echo (wa::err)"Missing directory name: pkg/ or themes/"(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  set -l pkg (basename $name)
  if not wa_util_valid_package $pkg
    echo (wa::err)"$pkg is not a valid package/theme name"(wa::off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if test -z "$url"
    echo (wa::em)"URL not specified, looking for a remote origin..."(wa::off) 1^&2
    set url (git config --get remote.origin.url)
    if test -z "$url"
      echo (wa::em)"$pkg remote URL not found"(wa::off) 1^&2
      echo "Try: git remote add <URL> or see Docs#Submitting" 1^&2
      return $WAHOO_INVALID_ARG
    end
  else
    if test -e "$WAHOO_PATH/db/$name"
      echo (wa::err)"Error: $pkg already exists in the registry!"(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
    else
      echo "$url" > $WAHOO_PATH/db/$name
      echo (wa::em)"$pkg added to the "(dirname $name)" registry."(wa::off)
      open "https://github.com"/$user/wahoo
      return 0
    end
  end
end
