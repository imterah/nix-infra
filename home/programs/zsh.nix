{
  pkgs,
  lib,
  ...
}: {
  programs.git.enable = true;
  programs.zsh = {
    enable = true;

    shellAliases = {
      ls = "ls -lah --color";
      lsc = "ls --color";

      run = "nix-shell -p";
      nsh = "nix-shell";
    };

    initExtra = ''
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

      if [[ "$TERM" != "dumb" ]]; then
        ${pkgs.krabby}/bin/krabby random
      fi

      function mikro() {
        ${pkgs.kitty}/bin/kitty ${pkgs.micro}/bin/micro $@ &
      }
    '';
  };
}
