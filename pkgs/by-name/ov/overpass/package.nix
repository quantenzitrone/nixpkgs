{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "overpass";
  version = "3.0.5";

  src = fetchzip {
    url = "https://github.com/RedHatOfficial/Overpass/releases/download/v${finalAttrs.version}/overpass-${finalAttrs.version}.zip";
    hash = "sha256-8AWT0/DELfNWXtZOejC90DbUSOtyGt9tSkcSuO7HP2o=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 */*/*.otf -t $out/share/fonts/opentype
    install -Dm644 */*/*.ttf -t $out/share/fonts/truetype
    install -Dm644 *.md  -t $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}

    runHook postInstall
  '';

  meta = {
    homepage = "https://overpassfont.org/";
    description = "Font heavily inspired by Highway Gothic";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.rycee ];
  };
})
