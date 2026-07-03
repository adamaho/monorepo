{
  description = "Development shell for the monorepo monorepo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              docker
              docker-compose
              git
              nodejs_24
              pnpm_11
            ];

            shellHook = ''
              echo "monorepo dev shell: node $(node --version), pnpm $(pnpm --version 2>/dev/null || printf 'unavailable')"
              echo "Docker daemon must be installed/enabled by the host OS for docker compose commands to run."
            '';
          };
        });
    };
}
