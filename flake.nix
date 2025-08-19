# /qompassai/blaze.nvim/flake.nix
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
{
  description = "Blaze.nvim - A modern Neovim plugin for the 🔥(mojo) language.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    mojo-dev = {
      url = "https://developer.modular.com/download/mojo-linux-25.3.0.dev2025040205.tar.gz";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , neovim-flake
    , ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              neovim-unwrapped = neovim-flake.packages.${system}.default;
            })
          ];
        };
        mojo-lsp = pkgs.stdenv.mkDerivation {
          name = "mojo-lsp";
          buildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin
            makeWrapper ${pkgs.mojo}/bin/mojo $out/bin/mojo-lsp \
              --add-flags "lsp"
          '';
        };
        blaze-nvim = pkgs.neovimUtils.buildNeovimPlugin {
          name = "blaze.nvim";
          src = ./.;
          buildInputs = [ pkgs.luajitPackages.luarocks-nix ];
          postInstall = ''
            mkdir -p $out/lua
            cp -r lua/* $out/lua/
          '';
        };

        neovim-blaze = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            customRC = ''
              lua << EOF
              package.path = '${blaze-nvim}/lua/?.lua;' .. package.path
              require('blaze').setup({
                lsp = {
                  cmd = { "${mojo-lsp}/bin/mojo-lsp" },
                  version = "25.3.0.dev2025040205",
                  enable_quantum = true,
                  filetypes = { "mojo", "🔥", "qasm" }
                },
                quantum = {
                  simulator = "qpp",
                  visualization = "braket"
                }
              })
              EOF
            '';
            packages.myVimPackage = {
              start = [
                blaze-nvim
                pkgs.vimPlugins.nvim-treesitter
                pkgs.vimPlugins.nvim-lspconfig
                pkgs.vimPlugins.which-key-nvim
              ];
            };
          };
        };
      in
      {
        packages = {
          inherit blaze-nvim neovim-blaze mojo-lsp;
          default = neovim-blaze;
        };
        devShells.default = pkgs.mkShell {
          packages = [
            neovim-blaze
            pkgs.mojo
            pkgs.nil
            pkgs.stylua
            pkgs.luajitPackages.lua-lsp
          ];
        };
        apps.default = {
          type = "app";
          program = "${neovim-blaze}/bin/nvim";
        };
      }
    );
}
{
  description = "Blaze.nvim - Quantum-Ready Mojo Language Support for Neovim";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly.url = "github:neovim/neovim?dir=contrib";
        quantum-sim = {
      url = "github:quantumlib/qsim/v0.9.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , neovim-nightly
    , mojo-dev
    , quantum-sim
    , ...
    }@inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (self: super: {
              neovim-unwrapped = neovim-nightly.packages.${system}.neovim;
              mojo = super.stdenv.mkDerivation {
                name = "mojo-25.3.0.dev2025040205";
                src = mojo-dev;
                installPhase = ''
                  mkdir -p $out
                  cp -r * $out/
                  wrapProgram $out/bin/mojo \
                    --prefix PATH : ${super.lib.makeBinPath [ super.python311 ]}
                '';
                meta = {
                  license = super.lib.licenses.unfree;
                  platforms = super.lib.platforms.linux;
                };
              };
            })
            quantum-sim.overlays.default
          ];
        };
        mojo-lsp = pkgs.writeShellApplication {
          name = "mojo-lsp";
          runtimeInputs = [ pkgs.mojo ];
          text = ''
            export MOJO_CACHE_PATH="''${MOJO_CACHE_PATH:-$XDG_CACHE_HOME/mojo}"
            exec ${pkgs.mojo}/bin/mojo lsp "$@"
          '';
        };
        blaze-nvim = pkgs.neovimUtils.buildNeovimPlugin {
          name = "blaze.nvim";
          src = ./.;
          buildInputs = [ pkgs.luajit ];
          postInstall = ''
            mkdir -p $out/lua/blaze
            cp -r lua/* $out/lua/
            cp ${./quantum} $out/lua/blaze/quantum.lua
          '';
        };
        neovim-blaze = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            customRC = ''
              lua << EOF
              package.path = '${blaze-nvim}/lua/?.lua;' .. package.path
              require('blaze').setup({
                lsp = {
                  cmd = { "${mojo-lsp}/bin/mojo-lsp" },
                  enable_quantum = true,
                  filetypes = { "mojo", "🔥", "qasm" }
                },
                quantum = {
                  simulator = "qpp",
                  visualization = "braket"
                }
              })
              EOF
            '';
            packages.myVimPackage = {
              start = [
                blaze-nvim
                pkgs.vimPlugins.nvim-treesitter
                pkgs.vimPlugins.nvim-lspconfig
                pkgs.vimPlugins.which-key-nvim
              ];
            };
          };
        };

      in
      {
        packages = {
          inherit blaze-nvim neovim-blaze mojo-lsp;
          quantum-env = pkgs.mkShell {
            buildInputs = [ quantum-sim.packages.${system}.default ];
          };
          default = neovim-blaze;
        };

        devShells.default = pkgs.mkShell {
          packages = [
            neovim-blaze
            pkgs.mojo
            quantum-sim.packages.${system}.default
            pkgs.nil
            pkgs.stylua
            pkgs.lua-language-server
            pkgs.qiskit
          ];
          shellHook = ''
            export MOJO_HOME="${pkgs.mojo}"
            export QSIM_PATH="${quantum-sim.packages.${system}.default}"
            echo "🔥 Blaze.nvim Dev Environment Activated"
            echo " - Mojo SDK: ${pkgs.mojo.version}"
            echo " - Quantum Sim: ${quantum-sim.packages.${system}.default.version}"
          '';
        };
        apps.default = {
          type = "app";
          program = "${neovim-blaze}/bin/nvim";
        };
        nixosModules.default =
          { config, pkgs, ... }:
          {
            environment.systemPackages = [ self.packages.${system}.default ];
            environment.sessionVariables = {
              MOJO_CACHE_DIR = "${config.xdg.cacheHome}/mojo";
              QSIM_BIN_PATH = "${quantum-sim.packages.${system}.default}/bin";
            };
          };
      }
    );
}
