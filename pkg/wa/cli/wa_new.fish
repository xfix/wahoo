function wa_new -a option name
  switch $option
    case "p" "pkg" "pack" "packg" "package"
      set option "pkg"
    case "t" "th" "the" "thm" "theme" "themes"
      set option "themes"
    case "*"
      echo (wa::err)"$option is not a valid option."(wa::off) 1^&2
      return $WAHOO_INVALID_ARG
  end

  if not wa_util_valid_package "$name"
    echo (wa::err)"$name is not a valid package/theme name"(wa::off) 1^&2
    return $WAHOO_INVALID_ARG
  end

  if set -l dir (wa_util_mkdir "$option/$name")
    cd $dir

    set -l github (git config github.user)
    test -z "$github"; and set github "{{USERNAME}}"

    set -l user (git config user.name)
    test -z "$user"; and set user "{{USERNAME}}"

    wa_new_from_template "$WAHOO_PATH/pkg/wa/templates/$option" \
      $github $user $name

    echo (wa::em)"Switched to $dir"(wa::off)
  else
    echo (wa::err)"\$WAHOO_CUSTOM and/or \$WAHOO_PATH undefined."(wa::off) 1^&2
    exit $WAHOO_UNKNOWN_ERR
  end
end
