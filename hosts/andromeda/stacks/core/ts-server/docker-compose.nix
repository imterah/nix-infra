# Auto-generated using compose2nix v0.3.1.
{ pkgs, lib, ... }:

{
  # Containers
  virtualisation.oci-containers.containers."headplane" = {
    image = "ghcr.io/tale/headplane:0.5.10";
    volumes = [
      "headscale_headplane-config:/etc/headplane/config.yaml:rw"
      "headscale_headplane-data:/var/lib/headplane:rw"
      "headscale_headscale-config:/etc/headscale:rw"
    ];
    labels = {
      "traefik.http.routers.headplanehoferscloud.rule" = "Host(`headplane.hofers.cloud`)";
      "traefik.http.services.headplanehoferscloud.loadbalancer.server.port" = "3000";
    };
    dependsOn = [
      "headplane"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=headplane"
      "--network=headscale_default"
    ];
  };

  systemd.services."docker-headplane" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-headscale_default.service"
      "docker-volume-headscale_headplane-config.service"
      "docker-volume-headscale_headplane-data.service"
      "docker-volume-headscale_headscale-config.service"
    ];
    requires = [
      "docker-network-headscale_default.service"
      "docker-volume-headscale_headplane-config.service"
      "docker-volume-headscale_headplane-data.service"
      "docker-volume-headscale_headscale-config.service"
    ];
    partOf = [
      "docker-compose-headscale-root.target"
    ];
    wantedBy = [
      "docker-compose-headscale-root.target"
    ];
  };

  virtualisation.oci-containers.containers."headscale" = {
    image = "docker.io/headscale/headscale:0.26.0";
    volumes = [
      "headscale_headscale-config:/etc/headscale:rw"
      "headscale_headscale-lib:/var/lib/headscale:rw"
      "headscale_headscale-run:/var/run/headscale:rw"
    ];
    cmd = [ "serve" ];
    labels = {
      "traefik.http.routers.headscaleterahdev.rule" = "Host(`headscale.terah.dev`)";
      "traefik.http.services.headscaleterahdev.loadbalancer.server.port" = "8000";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=headscale"
      "--network=headscale_default"
    ];
  };

  systemd.services."docker-headscale" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-headscale_default.service"
      "docker-volume-headscale_headscale-config.service"
      "docker-volume-headscale_headscale-lib.service"
      "docker-volume-headscale_headscale-run.service"
    ];
    requires = [
      "docker-network-headscale_default.service"
      "docker-volume-headscale_headscale-config.service"
      "docker-volume-headscale_headscale-lib.service"
      "docker-volume-headscale_headscale-run.service"
    ];
    partOf = [
      "docker-compose-headscale-root.target"
    ];
    wantedBy = [
      "docker-compose-headscale-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-headscale_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f headscale_default";
    };
    script = ''
      docker network inspect headscale_default || docker network create headscale_default
    '';
    partOf = [ "docker-compose-headscale-root.target" ];
    wantedBy = [ "docker-compose-headscale-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-headscale_headplane-config" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect headscale_headplane-config || docker volume create headscale_headplane-config
    '';
    partOf = [ "docker-compose-headscale-root.target" ];
    wantedBy = [ "docker-compose-headscale-root.target" ];
  };

  systemd.services."docker-volume-headscale_headplane-data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect headscale_headplane-data || docker volume create headscale_headplane-data
    '';
    partOf = [ "docker-compose-headscale-root.target" ];
    wantedBy = [ "docker-compose-headscale-root.target" ];
  };

  systemd.services."docker-volume-headscale_headscale-config" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect headscale_headscale-config || docker volume create headscale_headscale-config
    '';
    partOf = [ "docker-compose-headscale-root.target" ];
    wantedBy = [ "docker-compose-headscale-root.target" ];
  };

  systemd.services."docker-volume-headscale_headscale-lib" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect headscale_headscale-lib || docker volume create headscale_headscale-lib
    '';
    partOf = [ "docker-compose-headscale-root.target" ];
    wantedBy = [ "docker-compose-headscale-root.target" ];
  };

  systemd.services."docker-volume-headscale_headscale-run" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect headscale_headscale-run || docker volume create headscale_headscale-run
    '';
    partOf = [ "docker-compose-headscale-root.target" ];
    wantedBy = [ "docker-compose-headscale-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-headscale-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
oci-conta
