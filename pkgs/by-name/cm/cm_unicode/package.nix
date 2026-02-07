{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cm-unicode";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/cm-unicode/cm-unicode/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-otf.tar.xz";
    hash = "sha256-VIp+vk1IYbEHW15wMrfGVOPqg1zBZDpgFx+jlypOHCg=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/opentype *.otf
    install -m444 -Dt $out/share/doc/${finalAttrs.pname}-${finalAttrs.version}    README FontLog.txt

    runHook postInstall
  '';

  meta = {
    homepage = "https://cm-unicode.sourceforge.io/";
    description = "Computer Modern Unicode fonts";
    maintainers = with lib.maintainers; [
      raskin
      rycee
    ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
