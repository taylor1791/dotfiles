{ lib, buildNpmPackage, fetchFromGitHub, ... }: buildNpmPackage rec {
  pname = "fireconnect";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "fw-ai";
    repo = "fireconnect";
    rev = "2dd2bdd178406b8ba29654240d7d0a4c7fd6fcc8";
    hash = "sha256-nrCiv958XfeZq9qvqbrpd5pndSr7w1n6Nzj6pKykq7M=";
  };

  sourceRoot = "${src.name}/packages/setup-cli";
  npmDepsHash = "sha256-/pXAUhoD9sgWKLFTthWRcpFWJ/DoPYkpUWDlXgqufYQ=";

  # The package postinstall rewrites ~/.claude and ~/.fireconnect. It must not
  # run from the build sandbox.
  npmFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  meta = {
    description = "Route Claude Code and other harnesses through Fireworks-hosted models";
    homepage = "https://github.com/fw-ai/fireconnect";
    license = lib.licenses.asl20;
    mainProgram = "fireconnect";
  };
}
