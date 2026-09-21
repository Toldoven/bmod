{ pkgs, ... }:

{
  # Packages available in the shell
  packages = [
    pkgs.godot_4_7
  ];

  # Shell commands
  scripts = {
    # Open the project in the editor.
    editor.exec = "godot --editor --path ${"\${DEVENV_ROOT}"}";
    # Run the test scene without opening the editor.
    play.exec = "godot --path ${"\${DEVENV_ROOT}"}";
  };

  # Shell startup message
  enterShell = ''
    echo ""

    GODOT_VER=$(godot --headless --version 2>/dev/null | head -n1)

    echo -e "  \033[1;35mBMOD\033[0m"
    echo -e "  \033[36mGodot\033[0m $GODOT_VER"
    echo ""
    echo -e "  \033[33meditor\033[0m to open the editor"
    echo -e "  \033[33mplay\033[0m to run the test scene"
    echo ""
  '';
}
