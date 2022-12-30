{ buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "tfswitch-${version}";
  version = "0.8.832";

  preBuild = "export CGO_ENABLED=0";   # Emit a static binary
  buildFlags = [ "--tags" "release" ]; # 

  goPackagePath = "github.com/warrensbox/terraform-switcher";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "warrensbox";
    repo = "terraform-switcher";
    rev = "${version}";
    sha256 = "0jr0nzx3am1av86h8vdzfi99qw081gkf4w9bxxxqryqd7my26p1w";
  };
}
