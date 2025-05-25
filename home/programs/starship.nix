{
  pkgs,
  lib,
  ...
}: {
  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
      format = "($nix_shell)$directory($git_branch) $character";
      continuation_prompt = "\t[\\$>](bold black)";

      character = {
        success_symbol = "[λ](bold gray)";
        error_symbol = "[λ](bold red)";
      };

      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
        format = "[$path]($style)";
        style = "bold white";
      };

      git_branch = {
        format = "[ on $branch(@$remote_branch)]($style)";
        style = "bold purple";
      };

      nix_shell = {
        format = "[❄]($style) ";
      };
    };
  };
}
