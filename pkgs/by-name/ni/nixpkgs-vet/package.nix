{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.0.0+multi-by-name";

  src = fetchFromGitHub {
    owner = "quantenzitrone";
    repo = "nixpkgs-vet";
    rev = "d8ccf3ba29c3cd58946b450c16d44ebe47f9fcc0";
    hash = "sha256-QZEARzP4zwrVrniKQJn7Azy4HQWt3Qlyx4G9bumQ3I0=";
  };

  cargoHash = "sha256-RVZ3HgTkDmu+lbrNxGw4oQIatJE3Td23bI71+Y8cUrw=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to vet (check) Nixpkgs, including its pkgs/by-name directory";
    changelog = "https://github.com/NixOS/nixpkgs-vet/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    homepage = "https://github.com/NixOS/nixpkgs-vet";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-vet";
    maintainers = with lib.maintainers; [
      mdaniels5757
      philiptaron
      willbush
    ];
    teams = [ lib.teams.ci ];
  };
})
