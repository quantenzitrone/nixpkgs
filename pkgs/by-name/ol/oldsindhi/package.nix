{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "oldsindhi";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/MihailJP/${finalAttrs.pname}/releases/download/v${finalAttrs.version}/OldSindhi-${finalAttrs.version}.tar.xz";
    hash = "sha256-jOcl+mo6CJ9Lnn3nAUiXXHCJssovVgLoPrbGxj4uzQs=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf
    install -m444 -Dt $out/share/doc/${finalAttrs.pname}-${finalAttrs.version} README *.txt

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/MihailJP/oldsindhi";
    description = "Free Sindhi Khudabadi font";
    maintainers = with lib.maintainers; [ mathnerd314 ];
    license = with lib.licenses; [
      mit
      ofl
    ];
    platforms = lib.platforms.all;
  };
})
