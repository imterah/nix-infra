{inputs, ...}; let
  secretspath = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    age = {
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
    secrets = {
      tera_passwd = {
        neededForUsers = true;
      };
    };
  };
}
