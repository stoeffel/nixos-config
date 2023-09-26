{ config, pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "stoeffel";
  home.homeDirectory = "/home/stoeffel";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    pkgs.arandr
    pkgs.pinentry
    pkgs.autojump
    pkgs.copilot-cli
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-language-server
    pkgs.elmPackages.elm-test
    pkgs.gh
    pkgs.git
    pkgs.git-extras
    pkgs.gnome.nautilus
    pkgs.pcmanfm
    pkgs.gnupg
    pkgs.gopass
    pkgs.jq
    pkgs.killall
    pkgs.lxappearance
    pkgs.minio-client
    pkgs.nerdfonts
    pkgs.nixfmt
    pkgs.nodePackages.prettier
    pkgs.nodejs
    pkgs.nyxt
    pkgs.phodav
    pkgs.python3
    pkgs.ripgrep
    pkgs.spice-vdagent
    pkgs.tree-sitter
    pkgs.wget
    pkgs.xclip
    pkgs.feh
    (pkgs.writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')
    (pkgs.writeShellScriptBin "xrandr-big-monitor" ''
      xrandr --output Virtual-1 --mode 5120x2160
    '')

    (pkgs.writeShellScriptBin "random-wallpaper" ''
      ${pkgs.feh}/bin/feh --bg-fill --no-fehbg --randomize $HOME/backgrounds/
    '')

    (pkgs.writeShellScriptBin "ctrl-c" ''
      ${pkgs.xclip}/bin/xclip -selection clipboard
    '')

    (pkgs.writeShellScriptBin "ctrl-v" ''
      ${pkgs.xclip}/bin/xclip -selection clipboard -o
    '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/stoeffel/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "kitty";
    SHELL = "${pkgs.zsh}/bin/zsh";

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.chromium.enable = true;
  programs.ssh.enable = true;

  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    g = "lazygit";
    v = "nvim";
    t = "tmuxinator";
  };
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins =
    [ "git" "pip" "autojump" "command-not-found" "fasd" "history" "fzf" ];

  programs.tmux.enable = true;
  programs.tmux.tmuxinator.enable = true;
  programs.tmux.keyMode = "vi";
  programs.tmux.sensibleOnTop = true;
  programs.tmux.prefix = "C-b";
  programs.tmux.shell = "${pkgs.zsh}/bin/zsh";
  programs.tmux.mouse = true;

  programs.kitty = {
    enable = true;
    theme = "Tokyo Night Day";
    font = {
      name = "FiraCode Nerd Font Mono";
      size = 22;
    };
    settings = {
      shell = "zsh";
      hide_window_decorations = "yes";
    };
  };
  programs.firefox.enable = true;
  programs.fzf.enable = true;
  programs.starship.enable = true;
  programs.git.enable = true;
  programs.git.userName = "Stoeffel";
  programs.git.userEmail = "schtoeffel@gmail.com";
  programs.lazygit.enable = true;
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  programs.neovim.plugins = with pkgs.vimPlugins; [
    ale
    bufferline-nvim
    mini-nvim
    copilot-lua
    dashboard-nvim
    dhall-vim
    editorconfig-vim
    fzf-vim
    git-blame-nvim
    gitsigns-nvim
    haskell-vim
    hop-nvim
    lazygit-nvim
    vim-bookmarks
    telescope-vim-bookmarks-nvim
    lightspeed-nvim
    lualine-nvim
    neoformat
    neoyank-vim
    nightfox-nvim
    tokyonight-nvim
    nvim-tree-lua
    nvim-web-devicons
    plenary-nvim
    quickfix-reflector-vim
    tabular
    telescope-nvim
    telescope-fzf-native-nvim
    toggleterm-nvim
    unicode-vim
    vim-abolish
    vim-devicons
    vim-eunuch
    vim-exchange
    vim-fugitive
    vim-highlightedyank
    vim-localvimrc
    vim-markdown
    vim-nix
    vim-repeat
    vim-rhubarb
    vim-scala
    vim-scriptease
    vim-sensible
    vim-speeddating
    vim-surround
    vim-textobj-user
    vim-unimpaired
    vim-vinegar
    vim-visual-star-search
    which-key-nvim
    nvim-lspconfig
    nvim-treesitter
    nvim-treesitter-parsers.elm
  ];
  programs.neovim.extraLuaConfig = builtins.readFile ./neovim.lua;
  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars = {
    bottom = {
      blocks = [
        { block = "disk_space"; }
        { block = "cpu"; }
        { block = "memory"; }
        {
          block = "time";
          interval = 60;
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
        }
      ];
      theme = "modern";
      icons = "material-nf";
    };
  };
  xsession.enable = true;
  xsession.scriptPath = ".hm-xsession";
  xsession.initExtra = ''
    spice-vdagent;
    spice-webdavd;
  '';
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      defaultWorkspace = "workspace number 1";
      gaps = { inner = 10; };
      fonts = [ "FiraCode Nerd 10" ];
      keybindings = lib.mkOptionDefault {
        "${config.xsession.windowManager.i3.config.modifier}+h" = "focus left";
        "${config.xsession.windowManager.i3.config.modifier}+j" = "focus down";
        "${config.xsession.windowManager.i3.config.modifier}+k" = "focus up";
        "${config.xsession.windowManager.i3.config.modifier}+l" = "focus right";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+h" =
          "move left";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+j" =
          "move down";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+k" =
          "move up";
        "${config.xsession.windowManager.i3.config.modifier}+Shift+l" =
          "move right";
        "${config.xsession.windowManager.i3.config.modifier}+w" = "split h";
        "${config.xsession.windowManager.i3.config.modifier}+t" =
          "focus mode_toggle";
        "${config.xsession.windowManager.i3.config.modifier}+space" =
          "exec ${config.xsession.windowManager.i3.config.menu}";
        "${config.xsession.windowManager.i3.config.modifier}+n" =
          "exec i3-input -F 'rename workspace to \"%s\"' -P 'New name: '";
      };
      terminal = "kitty";
      bars = [{
        position = "bottom";
        fonts = [ "FiraCode Nerd 10" ];
        statusCommand =
          "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
      }];
    };
  };
  services.random-background.enable = true;
  services.random-background.imageDirectory = "%h/backgrounds/";
  services.random-background.enableXinerama = true;
  services.random-background.interval = "1h";
  home.activation.createGitignore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cp -f ${./gitignore} $HOME/.config/git/ignore
  '';

}
