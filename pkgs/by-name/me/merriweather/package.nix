{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "merriweather";
  version = "2.005";

  src = fetchFromGitHub {
    owner = "SorkinType";
    repo = "Merriweather";
    rev = "4fd88c9299009d1c1d201e7da3ff75cf1de5153a";
    sha256 = "1ndycja2jzhcfbqbm0p6ka2zl1i1pdbkf0crw2lp3pi4k89wlm29";
  };

  # TODO: it would be nice to build this from scratch, but lots of
  # Python dependencies to package (fontmake, gftools)

  installPhase = ''
    install -m444 -Dt $out/share/fonts/opentype/${finalAttrs.pname} fonts/otf/*.otf
    install -m444 -Dt $out/share/fonts/truetype/${finalAttrs.pname} fonts/ttfs/*.ttf
    install -m444 -Dt $out/share/fonts/woff/${finalAttrs.pname} fonts/woff/*.woff
    install -m444 -Dt $out/share/fonts/woff2/${finalAttrs.pname} fonts/woff2/*.woff2
    # TODO: install variable version?
  '';

  meta = {
    homepage = "https://github.com/SorkinType/Merriweather";
    description = "Text face designed to be pleasant to read on screens";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ emily ];
  };
})
