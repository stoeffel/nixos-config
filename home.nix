{ config, pkgs, ... }:
with import <nixpkgs> {};

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
    pkgs.git
    pkgs.spice
    pkgs.spice-vdagent
    pkgs.phodav
    pkgs._1password
    pkgs._1password-gui
    pkgs.nyxt
    pkgs.autojump
    pkgs.arandr
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
    TERM = "alacritty";
    SHELL = "zsh";

  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.alacritty.enable = true;
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.zsh.shellAliases = {
    g = "git";
    v = "nvim";
  };
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [
    "git" "pip" "autojump" "command-not-found" "fasd" "history" "fzf" ];

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
    comment-nvim
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
    lightspeed-nvim
    lualine-nvim
    neoformat
    neoyank-vim
    nvim-tree-lua
    nvim-web-devicons
    plenary-nvim
    quickfix-reflector-vim
    tabular
    telescope-nvim
    toggleterm-nvim
    unicode-vim
    vim-abolish
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
  ];
  programs.neovim.extraLuaConfig = builtins.readFile ./neovim.lua;
  xsession.enable = true;
  xsession.windowManager.i3 = {
     enable = true;
      package = pkgs.i3-gaps;
      config = rec {
      keybindings = lib.mkOptionDefault {
           "${config.xsession.windowManager.i3.config.modifier}+h" = "focus left";
           "${config.xsession.windowManager.i3.config.modifier}+j" = "focus down";
           "${config.xsession.windowManager.i3.config.modifier}+k" = "focus up";
           "${config.xsession.windowManager.i3.config.modifier}+l" = "focus right";
           "${config.xsession.windowManager.i3.config.modifier}+Shift+h" = "move left";
           "${config.xsession.windowManager.i3.config.modifier}+Shift+j" = "move down";
           "${config.xsession.windowManager.i3.config.modifier}+Shift+k" = "move up";
           "${config.xsession.windowManager.i3.config.modifier}+Shift+l" = "move right";
           "${config.xsession.windowManager.i3.config.modifier}+w" = "split h";
         };
        terminal = "alacritty";
   };
  };
}
