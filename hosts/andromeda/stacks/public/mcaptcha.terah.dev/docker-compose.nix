# Auto-generated using compose2nix v0.3.1.
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../../../../system/sops.nix
  ];

  # Containers
  virtualisation.oci-containers.containers."mcaptcha-cache" = {
    image = "mcaptcha/cache:latest";
    log-driver = "journald";
    extraOptions = [
      "--network-alias=cache"
      "--network=mcaptcha_default"
    ];
  };

  systemd.services."docker-mcaptcha-cache" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mcaptcha_default.service"
    ];
    requires = [
      "docker-network-mcaptcha_default.service"
    ];
    partOf = [
      "docker-compose-mcaptcha-root.target"
    ];
    wantedBy = [
      "docker-compose-mcaptcha-root.target"
    ];
  };

  virtualisation.oci-containers.containers."mcaptcha-db" = {
    image = "postgres:16.8";
    environmentFiles = [ config.sops.secrets.mcaptcha_db_docker_env.path ];
    environment = {
      "PGDATA" = "/var/lib/postgresql/data/mcaptcha/";
    };
    volumes = [
      "mcaptcha_db:/var/lib/postgresql:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=db"
      "--network=mcaptcha_default"
    ];
  };

  systemd.services."docker-mcaptcha-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mcaptcha_default.service"
      "docker-volume-mcaptcha_db.service"
    ];
    requires = [
      "docker-network-mcaptcha_default.service"
      "docker-volume-mcaptcha_db.service"
    ];
    partOf = [
      "docker-compose-mcaptcha-root.target"
    ];
    wantedBy = [
      "docker-compose-mcaptcha-root.target"
    ];
  };

  virtualisation.oci-containers.containers."mcaptcha-mcaptcha" = {
    image = "mcaptcha/mcaptcha:latest";
    labels = {
      "traefik.http.routers.mcaptchaterahdev.rule" = "Host(`mcaptcha.terah.dev`)";
      "traefik.http.services.mcaptchaterahdev.loadbalancer.server.port" = "7000";
    };
    environmentFiles = [ config.sops.secrets.mcaptcha_mcaptcha_docker_env.path ];
    environment = {
      "MCAPTCHA__server_IP" = "0.0.0.0";
      "MCAPTCHA_allow_demo" = "false";
      "MCAPTCHA_allow_registration" = "false";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_avg_traffic_difficulty" = "50000";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_avg_traffic_time" = "1";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_broke_my_site_traffic_difficulty" = "5000000";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_broke_my_site_traffic_time" = "5";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_duration" = "30";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_peak_sustainable_traffic_difficulty" = "3000000";
      "MCAPTCHA_captcha_DEFAULT_DIFFICULTY_STRATEGY_peak_sustainable_traffic_time" = "3";
      "MCAPTCHA_captcha_ENABLE_STATS" = "true";
      "MCAPTCHA_captcha_GC" = "30";
      "MCAPTCHA_captcha_QUEUE_LENGTH" = "2000";
      "MCAPTCHA_captcha_RUNNERS" = "4";
      "MCAPTCHA_commercial" = "false";
      "MCAPTCHA_database_POOL" = "4";
      "MCAPTCHA_debug" = "false";
      "MCAPTCHA_redis_POOL" = "4";
      "MCAPTCHA_redis_URL" = "redis://cache";
      "MCAPTCHA_server_DOMAIN" = "mcaptcha.terah.dev";
      "MCAPTCHA_source_code" = "https://github.com/mCaptcha/mCaptcha";
      "PORT" = "7000";
    };
    dependsOn = [
      "mcaptcha-cache"
      "mcaptcha-db"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=mcaptcha"
      "--network=mcaptcha_default"
    ];
  };

  systemd.services."docker-mcaptcha-mcaptcha" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-mcaptcha_default.service"
    ];
    requires = [
      "docker-network-mcaptcha_default.service"
    ];
    partOf = [
      "docker-compose-mcaptcha-root.target"
    ];
    wantedBy = [
      "docker-compose-mcaptcha-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-mcaptcha_default" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f mcaptcha_default";
    };
    script = ''
      docker network inspect mcaptcha_default || docker network create mcaptcha_default
    '';
    partOf = [ "docker-compose-mcaptcha-root.target" ];
    wantedBy = [ "docker-compose-mcaptcha-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-mcaptcha_db" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect mcaptcha_db || docker volume create mcaptcha_db
    '';
    partOf = [ "docker-compose-mcaptcha-root.target" ];
    wantedBy = [ "docker-compose-mcaptcha-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-mcaptcha-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
