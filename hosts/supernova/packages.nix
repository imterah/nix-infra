{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  # Application packages
  programs.steam.enable = true;
  services.flatpak.enable = true;

  fonts.packages = with pkgs; [
    liberation_ttf
    google-fonts
    fixedsys-excelsior
    nerd-fonts.ubuntu-mono
  ];

  environment.systemPackages = with pkgs; [
    linuxPackages.usbip

    # iOS stage 2
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'

    # Editors
    nano
    micro
    htop
  ];

  users.users.tera.packages = with pkgs; [
    # KDE GTK settings
    kdePackages.kde-gtk-config

    # Video Editing
    kdePackages.kdenlive

    # VPN
    protonvpn-gui

    # Photography
    gimp
    rawtherapee

    # Notifications
    libnotify

    # Firmware updating
    gnome-firmware

    # Audio
    easyeffects

    # Remoting
    remmina
    moonlight-qt

    # VPN
    trayscale

    # Web / chatting / etc.
    floorp
    mullvad-browser
    tor-browser
    google-chrome
    tor
    element-desktop
    signal-desktop-bin
    spotify

    (discord.override {
      withVencord = true;
    })

    # Crypto
    monero-gui
    electrum
    mycrypto

    obs-studio
    vlc

    # Gaming
    lunar-client
    prismlauncher
    lutris
    mangohud

    # Encryption
    kdePackages.kleopatra

    # Programming
    android-studio
    zed-editor
    vscode
    micro
    bruno
    git

    transmission_4

    # Management
    gnome-disk-utility
    killall

    # Hack for micro clipboard support
    wl-clipboard
  ];
}
