#!/usr/bin/env fish

set attrname $argv[1]

set pkggrep $attrname' = callPackage \([^()]*(\([^()]*(\([^()]*\))*[^()]*\))*[^()]*\)'

set pname (grep -zoE $pkggrep pkgs/servers/x11/xorg/default.nix | string trim | grep -a pname | cut -c 10- | rev | cut -c 3- | rev)

echo attrname is currently $attrname
echo pname is currently $pname
echo change?
set newname (read -c $attrname)
set newpath pkgs/by-name/(string sub -e 2 $newname)/$newname

set version_ (grep -zoE $pkggrep pkgs/servers/x11/xorg/default.nix | string trim | grep -a '^version = ' | cut -c 12- | rev | cut -c 3- | rev)
set url (grep -zoE $pkggrep pkgs/servers/x11/xorg/default.nix | string trim | grep -a '^url = ')
set hash (nix-prefetch -q "fetchurl { $url hash = \"\"; }")
set url (echo $url | string replace $version_ '${finalAttrs.version}')
set urlpath (echo $url | cut -d / -f 4-5)
set urlpname (echo $url | cut -d / -f 6 | rev | cut -d - -f 2- | rev)
if test $urlpname = $newname
    set urlpname "\${finalAttrs.pname}"
end

mkdir -p $newpath

cat pkgs/servers/x11/xorg/default.nix |
    grep -zoE $pkggrep | head -n-1 | tail -n+2 | string trim |
    # add lib to args and swap pkg-config with fetchurl
    sed -z 's/stdenv,\npkg-config,\nfetchurl,/lib,\nstdenv,\nfetchurl,\npkg-config,/g' |
    # add writeScript
    sed 's/testers,/writeScript,\ntesters,/g' |
    # correct pname
    sed 's/^pname = .*$/pname = "'$newname'";/g' |
    # remove builder
    sed 's/^builder = .*$//g' |
    # remove hardeningDisable
    sed -z 's/hardeningDisable = \[[\"\na-z]*\];\n//g' |
    # make url version dependant
    string replace -r 'url = .*;' (string escape --style=regex $url) |
    # replace sha256 with hash
    sed -E 's|^sha256 = ".*";$|hash = "'$hash'";|g' |
    # replace some common renamed xorg packages
    sed 's/^libX/libx/g' |
    # passthru parsing
    sed (echo -s s~ \
        'passthru.\(.*\)~' \
        'passthru = {updateScript = writeScript "update-${finalAttrs.pname}" \'\'\n' \
        '#!/usr/bin/env nix-shell\n' \
        '#!nix-shell -i bash -p common-updater-scripts\n' \
        "version=\"\$(list-directory-versions --pname $urlpname \\\\\n" \
        "  --url https://xorg.freedesktop.org/releases/$urlpath/ \\\\\n"\
        '  | sort -V | tail -n1)"\n'\
        'update-source-version ${finalAttrs.pname} "$version"\n' \
        '\'\';\n\1\n}; ~g') |
    # add meta
    sed 's/^meta = {$/\nmeta = {\ndescription = "";\nhomepage = "";license = \[\];maintainers = \[\];/g' |
    # add some new lines
    sed 's/^strictDeps/\nstrictDeps/g' |
    sed 's/^nativeBuildInputs/\nnativeBuildInputs/g' |
    sed 's/^buildInputs/\nbuildInputs/g' |
    sed 's/^passthru/\npassthru/g' |
    # put it into the new path
    cat >$newpath/package.nix

# remove pkgConfigModules if they are empty
if grep 'pkgConfigModules = \[ \];' $newpath/package.nix >/dev/null
    sed -i '/pkgConfigModules = /d' $newpath/package.nix
    sed -i '/tests\.pkg-config = /d' $newpath/package.nix
    sed -i '/testers,/d' $newpath/package.nix
end

# mainProgram if it is that simple
if grep "$attrname = addMainProgram super\.$attrname { };" pkgs/servers/x11/xorg/overrides.nix
    sed -i "/$attrname = addMainProgram super\.$attrname { };/d" pkgs/servers/x11/xorg/overrides.nix
    nixfmt pkgs/servers/x11/xorg/overrides.nix
    sed -i 's/maintainers = /mainProgram = "'$attrname'";\nmaintainers = /g' $newpath/package.nix
end

# format
nixfmt $newpath/package.nix
