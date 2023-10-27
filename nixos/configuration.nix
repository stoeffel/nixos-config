# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, lib,  ... }:

let
  dual-function-keys = pkgs.writeText "dual-function-keys.yaml" ''
    # https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h
    TIMING:
      TAP_MILLISEC: 200
      DOUBLE_TAP_MILLISEC: 150

    MAPPINGS:
      - KEY: KEY_LEFTALT
        TAP: KEY_ESC
        HOLD: KEY_LEFTALT
        HOLD_START: BEFORE_CONSUME
  '';
in

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	<home-manager/nixos>
    ];


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfreePredicate = _: true;




  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;
  services.xserver = {
    dpi = 220;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    displayManager.sessionCommands = ''
      spice-vdagent;
      spice-webdavd;
      xrandr --output Virtual-1 --mode 3840x2160;
      '';
    displayManager.lightdm = {
      enable = true;
      autoLogin.enable = true;
      autoLogin.user = "stoeffel";
      };
    windowManager.i3.enable = true;
	};



  home-manager.users.stoeffel = import /home/stoeffel/.config/home-manager/home.nix;


  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stoeffel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      firefox
      git
      vim
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     yubikey-manager
     yubikey-personalization
     zsh
  ];
  environment.shellInit = ''
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };
  services.interception-tools = with pkgs; {
      enable = true;
      plugins = [ interception-tools-plugins.dual-function-keys ];
      udevmonConfig = ''
        - JOB: "${interception-tools}/bin/intercept -g $DEVNODE | ${interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c ${dual-function-keys} | ${interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            LINK: .*-event-kbd
      '';
    };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 8080  8382];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

