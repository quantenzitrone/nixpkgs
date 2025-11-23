#!/usr/bin/env fish

export NIXPKGS_ALLOW_UNFREE=1

set pkgs (eval printf "%s\n" $argv)

set tests (nix eval --impure --expr "with import ./. {}; map (x: map (y: \"\${x.pname}.passthru.tests.\${y}\") (lib.attrNames x.passthru.tests or {})) [ $pkgs ] |> lib.flatten" --json | jq .[] -r)

set builds $tests

for pkg in $pkgs
    for i in {,pkgsCross.aarch64-multiplatform.}{,pkgsStatic.}
        if ! eval (nix eval .#$i$pkg.meta.broken) && ! eval (nix eval .#$i$pkg.meta.unsupported)
            set builds $builds .#$i$pkg
        end
    end
end

echo (set_color red)building:(set_color normal) $builds

nom build --impure --no-link $builds || exit 1

nixpkgs-hammer -e maintainers-missing $pkgs

for p in $pkgs
    echo (set_color red)nix-check-deps(set_color normal)
    nix-check-deps .#$p --impure 2>/dev/null
    echo (set_color red)update(set_color normal)
    nix-shell maintainers/scripts/update.nix --argstr package $p --argstr skip-prompt true
end
