{ config, pkgs, ... }:

{
  home.username = "miek";
  home.homeDirectory = "/home/miek";
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Пользовательские программы
  home.packages = with pkgs; [
    # Менеджер версий Proton, Wine-GE, DXVK для Steam и других лаунчеров
    protonplus

    # Локальная передача файлов (аналог AirDrop)
    localsend
  ];

  # Настройки оболочки Bash
  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      ll = "ls -la";
    };
  };

  # Управление конфигурацией Git через Home Manager
  programs.git = {
    enable = true;
    # При желании можно раскомментировать:
    # userName = "miek";
    # userEmail = "miek@example.com";
  };

  # Версия схемы состояния Home Manager
  home.stateVersion = "26.05";

  # Позволяет Home Manager управлять собственной установкой
  programs.home-manager.enable = true;
}
