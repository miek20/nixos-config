# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n.defaultLocale = "ru_RU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Cinnamon Desktop Environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;

  # Автоматический вход в систему
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "miek";

  # Configure keymap in X11 and LightDM
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  # Использовать те же настройки раскладки в TTY (виртуальной консоли)
  console.useXkbConfig = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."miek" = {
    isNormalUser = true;
    description = "miek";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Системные пакеты и программы
  environment.systemPackages = with pkgs; [
    # Терминал и базовые утилиты
    git
    curl
    wget
    btop
    fastfetch
    ripgrep
    fd
    tree
    jq
    p7zip
    unzip
    parted
    e2fsprogs

    # Текстовые редакторы
    neovim
    vim
    nano

    # Разработка и языки
    vscode
    python3
    python3Packages.pip
    python3Packages.virtualenv

    # Мессенджеры, медиа и утилиты
    telegram-desktop
    vesktop
    mpv
    flameshot
    copyq
    keepassxc

    # SMB / Windows Network
    cifs-utils
    samba
  ];

  # Игры: Steam и оптимизация производительности GameMode
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
  programs.gamemode.enable = true;

  # Контейнеризация: Docker
  virtualisation.docker.enable = true;

  # Сжатая подкачка в оперативной памяти (zram)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  # Дополнительный накопитель (Samsung SSD 870 EVO 500GB)
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/bd58f108-ce08-4f04-bf6e-c77aaa9c0240";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  # -------------------------------------------------------------
  # NVIDIA GPU Configuration (GeForce GTX 1050 Ti - Pascal)
  # -------------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting обязательно для корректной работы
    modesetting.enable = true;

    # Управление питанием
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # ВАЖНО: для Pascal (GTX 1050 Ti) только проприетарные модули!
    # Открытые модули ядра NVIDIA поддерживают только Turing и новее.
    open = false;

    # Графическая панель управления nvidia-settings
    nvidiaSettings = true;

    # Версия драйвера (ветка 580.xx LTSB для карт Pascal / GTX 1050 Ti)
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };
  # -------------------------------------------------------------

  # Включение Flakes и новой команды nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];
}
