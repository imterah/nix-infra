{
  pkgs,
  lib,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "imterah";
    userEmail = "me@terah.dev";

    aliases = {
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --";
    };

    extraConfig = {
      init.defaultBranch = "main";

      user.signing.key = "8FA7DD57BA6CEA37";
      commit.gpgSign = true;

      credential.helper = "store";
    };

    ignores = [".direnv"];
  };
}
