function wa_destroy -d "Remove Wahoo"
  echo (bold)(set_color 555)"Removing Wahoo..."(off)

  for pkg in (basename $WAHOO_PATH/pkg/*)
    test $pkg != "wa"; and wa_remove_package "$pkg"
  end

  if test -e "$HOME/.config/fish/config.copy"
    mv "$HOME/.config/fish/config".{copy,fish}
  end

  if test (basename "$WAHOO_CONFIG") = "wahoo"
    rm -rf "$WAHOO_CONFIG"
  end

  if test "$WAHOO_PATH" != "$HOME"
    rm -rf "$WAHOO_PATH"
  end
end