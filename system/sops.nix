{inputs, ...}: let
  secretspath = builtins.toString inputs.nix-secrets;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    age = {
      # I'd prefer different OpenSSH keys for different hosts so I'm not 100% screwed if one of my devices get compromised.
      # Therefore, we set a custom path for the sops key.
      sshKeyPaths = ["/var/lib/sops-nix/ssh_host_ed25519_key"];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = false;
    };
    secrets = {
      tera_password = {
        neededForUsers = true;
      };
    };
  };
}
