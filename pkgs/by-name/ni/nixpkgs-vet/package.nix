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
    rev = "1a060d619b6c7ac4605e682a13bf9eacd7956865";
    hash = "sha256-i0SiKgCrNZ5/qX0ILpyQxWL079/Bx+Eyt0EunoBMWzE=";
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
