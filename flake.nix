{
  description = "A flake for sokol-lean";
  
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            lean4
            pkg-config        
            alsa-lib           
            libGL             
            libGLU            
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            xorg.libXinerama
          ];

          shellHook = ''
            echo "sokol-lean's shell ready"
            nu 
          '';
        };
      }
    );
}


