let
  nixpkgs = (import <nixpkgs> { config.allowAliases = false; });

  inherit (nixpkgs) lib;

  done = import ./pkgs/servers/x11/xorg/default.nix |> lib.functionArgs |> lib.attrNames;

  pkgs =
    nixpkgs.xorg
    |> lib.filterAttrs (
      n: v:
      lib.isAttrs v
      && v ? pname
      && !lib.elem n done
      && !lib.elem n (map (lib.replaceStrings [ "-" ] [ "" ]) done)
      && !lib.elem v.pname done
      && !lib.elem v.pname (map (lib.replaceStrings [ "-" ] [ "" ]) done)
      && !lib.elem (lib.toLower n) done
      && !lib.elem (lib.toLower n) (map (lib.replaceStrings [ "-" ] [ "" ]) done)
      && !lib.hasPrefix "xcbutil" n
      && !lib.hasPrefix "libXfont" n
    );

  pnames = lib.mapAttrsToList (_: v: v.pname) pkgs;

  filteredPkgs =
    pkgs
    |> lib.filterAttrs (
      n: v:
      true
      # && !v.meta.unfree
      # && !v.meta.broken
      # && !v.meta.unsupported
      # && !lib.hasPrefix "font" n
      && !lib.hasPrefix "xf86" n
    );
in
filteredPkgs
# get deps
|> lib.mapAttrs (
  _: v:
  v.buildInputs ++ v.nativeBuildInputs ++ v.propagatedBuildInputs ++ v.propagatedNativeBuildInputs
)
# filter deps for xorg packages
|> lib.mapAttrs (_: v: lib.filter (x: x ? pname && lib.elem x.pname pnames) v)
# map deps to list and count
|> lib.mapAttrsToList (
  name: value: {
    inherit name;
    deps = map (x: x.pname or "error") value |> lib.unique;
    count = lib.length value;
  }
)
# sort
|> lib.sort (
  x: y: x.count < y.count || (x.count == y.count && (lib.toLower x.name) > (lib.toLower y.name))
)
|> lib.reverseList
# represent as string
|> map (x: "${toString x.count} - ${toString x.name}: ${lib.concatStringsSep " " x.deps}")
