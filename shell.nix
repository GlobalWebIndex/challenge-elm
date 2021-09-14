{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/a165aeceda9f9741d15bc2488425daeb06c0707e.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-review
    pkgs.elmPackages.elm-test
    pkgs.elmPackages.elm-format
    pkgs.html-tidy
    pkgs.nodePackages.uglify-js
  ];
}
