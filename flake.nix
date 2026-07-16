{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      version = "0.3.1";
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        name = "wren-console";
        version = version;

        srcs = [
          (pkgs.fetchFromGitHub {
            name = "wren-console";
            owner = "joshgoebel";
            repo = "wren-console";
            rev = "86264afab3cacb91cb0b18830006cea6f629cc8d";
            sha256 = "DXKExXActz4+DayIrLcRBSXwDCQbxFGc+Rdmab88H/M=";
          })
          (pkgs.fetchFromGitHub {
            name = "wren-essentials";
            owner = "joshgoebel";
            repo = "wren-essentials";
            rev = "0d116a1658fdcd3a33496e5e0f69fbe9f01e5b38";
            sha256 = "OlxsC7NOy4jxdXUASW2i1XWeIqKhNFmchOYCPLBuKZw=";
          })
        ];

        sourceRoot = ".";

        buildPhase = ''
          mv wren-essentials wren-console/deps/
          make -C wren-console/projects/make/
        '';

        installPhase = ''
          mkdir -p $out
          cp -r wren-console/bin $out/
        '';

        meta = with pkgs.lib; {
          homepage = "https://wren.io/";
          description = "Wren language";
          platforms = platforms.linux;
        };
      };
    }
  );
}
