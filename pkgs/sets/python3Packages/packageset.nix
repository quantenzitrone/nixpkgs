{
  lib,
  newScope,
  config,
}:
python:
lib.makeScope newScope (
  lib.foldl' (lib.flip lib.extends) (x: { inherit python; }) (
    (lib.optionals (lib.pathExists ./by-name) [
      (import ../../top-level/by-name-overlay.nix ./by-name)
      (import ./overrides.nix)
    ])
    ++ [
      (self: super: lib.optionalAttrs config.allowAliases (import ./aliases.nix self super))
      (import ./functions.nix)
      (import ./manual-packages.nix)
    ]
  )
)
