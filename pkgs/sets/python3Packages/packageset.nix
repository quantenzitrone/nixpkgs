{
  lib,
  pkgs,
  stdenv,
  pythonPackagesExtensions,
  makeScopeWithSplicing',
  config,
}:
interpreter: packageOverrides:
let
  inherit (interpreter)
    pythonOnBuildForBuild
    pythonOnBuildForHost
    pythonOnBuildForTarget
    pythonOnHostForHost
    pythonOnTargetForTarget
    ;

  ensurePythonModules =
    items:
    let
      exceptions = [
        stdenv
      ];
      providesSetupHook = lib.attrByPath [ "provides" "setupHook" ] false;
      valid =
        value: pythonPackages.hasPythonModule value || providesSetupHook value || lib.elem value exceptions;
      func =
        name: value:
        if lib.isDerivation value then
          lib.extendDerivation (
            valid value
            || throw "${name} should use `buildPythonPackage` or `toPythonModule` if it is to be part of the Python packages set."
          ) { } value
        else
          value;
    in
    lib.mapAttrs func items;

  # - imports python-packages.nix
  # - adds spliced package sets to the package set
  # - applies overrides from `packageOverrides` and `pythonPackagesOverlays`.
  pythonPackages = ensurePythonModules (
    let
      pythonPackagesFun = import ./python-packages-base.nix {
        inherit
          stdenv
          pkgs
          lib
          ;
        python = interpreter;
      };
      otherSplices = {
        selfBuildBuild = pythonOnBuildForBuild.pkgs;
        selfBuildHost = pythonOnBuildForHost.pkgs;
        selfBuildTarget = pythonOnBuildForTarget.pkgs;
        selfHostHost = pythonOnHostForHost.pkgs;
        selfTargetTarget = pythonOnTargetForTarget.pkgs or { }; # There is no Python TargetTarget.
      };
      hooks = import ./hooks/default.nix;
      keep = self: hooks self { };
      optionalExtensions = cond: as: lib.optionals cond as;
      python2Extension = import ../../development/misc/resholve/python2-packages.nix;
      extensions = lib.composeManyExtensions (
        [
          hooks
        ]
        ++ (lib.optionals (lib.pathExists ./by-name) [
          (import ../../top-level/by-name-overlay.nix ./by-name)
          (import ./overrides.nix)
        ])
        ++ [
          (import ./functions.nix)
          (import ./manual-packages.nix)
        ]
        ++ (optionalExtensions (!interpreter.isPy3k) [
          python2Extension
        ])
        ++ pythonPackagesExtensions
        ++ [
          packageOverrides
        ]
      );
      aliases = self: super: lib.optionalAttrs config.allowAliases (import ./aliases.nix lib self super);
    in
    makeScopeWithSplicing' {
      inherit otherSplices keep;
      f = lib.extends (lib.composeExtensions aliases extensions) pythonPackagesFun;
    }
  );
in
pythonPackages
