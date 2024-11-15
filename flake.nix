{
  description = "An desktop app for simplenote written in flutter.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };
      in
      {
        packages = rec {
          default = simplenote-flutter;
          simplenote-flutter = pkgs.callPackage ./nix/package.nix { enableDebug = false; };
          # debug = pkgs.callPackage ./nix/package.nix { enableDebug = true; };
        };

        devShells.default = pkgs.mkShell {
          FLUTTER_SDK = "${pkgs.flutter.unwrapped}";
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.libepoxy}/lib
          '';
          buildInputs = with pkgs; [
            flutter
            at-spi2-core.dev
            clang
            cmake
            dart
            dbus.dev
            flutter
            gtk3
            libdatrie
            libepoxy.dev
            libselinux
            libsepol
            libthai
            libsecret
            libxkbcommon
            ninja
            pcre
            sysprof
            pkg-config
            util-linux.dev
            xorg.libXdmcp
            xorg.libXtst
          ];
        };
      }
    );
}
