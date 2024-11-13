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
        packages.default = pkgs.callPackage ./nix/package.nix { };
        devShells.default = pkgs.mkShell {
          FLUTTER_SDK = "${pkgs.flutter.unwrapped}";
          buildInputs = with pkgs; [
            flutter
          ];
        };
      }
    );
}
