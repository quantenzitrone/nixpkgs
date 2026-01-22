# Qt packages set.
#
# Attributes in this file are packages requiring Qt and will be made available
# for every Qt version. Qt applications are called from `all-packages.nix` via
# this file.

{
  lib,
  config,
  __splicedPackages,
  makeScopeWithSplicing',
  generateSplicesForMkScope,
  stdenv,
  pkgsHostTarget,
  kdePackages,
}:

let
  pkgs = __splicedPackages;
  # qt6 set should not be pre-spliced to prevent spliced packages being a part of an unspliced set
  # 'pkgsCross.aarch64-multiplatform.pkgsBuildTarget.targetPackages.qt6Packages.qtbase' should not have a `__spliced` but if qt6 is pre-spliced then it will have one.
  # pkgsHostTarget == pkgs
  qt6 = pkgsHostTarget.qt6;
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "qt6Packages";
  f = (
    self:
    let
      inherit (self) callPackage;
      noExtraAttrs =
        set:
        lib.attrsets.removeAttrs set [
          "extend"
          "override"
          "overrideScope"
          "overrideDerivation"
        ];
    in
    (noExtraAttrs qt6)
    // {

      # LIBRARIES
      accounts-qt = callPackage ../qt-packages/accounts-qt { };
      appstream-qt = callPackage ../qt-packages/appstream/qt.nix { };

      drumstick = callPackage ../qt-packages/drumstick { };

      fcitx5-chinese-addons = callPackage ../qt-packages/fcitx5-chinese-addons.nix { };

      fcitx5-configtool = kdePackages.callPackage ../qt-packages/fcitx5-configtool.nix { };

      fcitx5-qt = callPackage ../qt-packages/fcitx5-qt.nix { };

      fcitx5-skk-qt = callPackage ../qt-packages/fcitx5-skk.nix { enableQt = true; };

      fcitx5-unikey = callPackage ../qt-packages/fcitx5-unikey.nix { };

      fcitx5-with-addons = callPackage ../qt-packages/with-addons.nix { };

      kdsoap = callPackage ../qt-packages/kdsoap { };

      kcolorpicker = callPackage ../qt-packages/kcolorpicker { };
      kimageannotator = callPackage ../qt-packages/kimageannotator { };

      futuresql = callPackage ../qt-packages/futuresql { };
      kquickimageedit = callPackage ../qt-packages/kquickimageedit { };

      libiodata = callPackage ../qt-packages/libiodata { };

      libqaccessibilityclient = callPackage ../qt-packages/libqaccessibilityclient { };

      libqglviewer = callPackage ../qt-packages/libqglviewer { };

      libqtpas = callPackage ../qt-packages/libqtpas.nix { };

      libquotient = callPackage ../qt-packages/libquotient { };
      mlt = pkgs.mlt.override {
        qt = qt6;
      };

      maplibre-native-qt = callPackage ../qt-packages/maplibre-native-qt { };

      qca = callPackage ../qt-packages/qca {
        inherit (qt6) qtbase qt5compat;
      };
      qcoro = callPackage ../qt-packages/qcoro { };
      qcustomplot = callPackage ../qt-packages/qcustomplot { };
      qgpgme = callPackage ../qt-packages/qgpgme { };
      qhotkey = callPackage ../qt-packages/qhotkey { };
      qmlbox2d = callPackage ../qt-packages/qmlbox2d { };
      packagekit-qt = callPackage ../qt-packages/qt.nix { };

      qodeassist-plugin = callPackage ../qt-packages/qodeassist-plugin { };

      qt6ct = callPackage ../qt-packages/qt6ct { };

      qt6gtk2 = callPackage ../qt-packages/qt6gtk2 { };

      qt-color-widgets = callPackage ../qt-packages/qt-color-widgets { };

      qtforkawesome = callPackage ../qt-packages/qtforkawesome { };

      qtkeychain = callPackage ../qt-packages/qtkeychain { };

      qtpbfimageplugin = callPackage ../qt-packages/qtpbfimageplugin { };

      qtstyleplugin-kvantum = kdePackages.callPackage ../qt-packages/qtstyleplugin-kvantum { };

      qtutilities = callPackage ../qt-packages/qtutilities { };

      qt-jdenticon = callPackage ../qt-packages/qt-jdenticon { };

      quazip = callPackage ../qt-packages/quazip { };

      qscintilla = callPackage ../qt-packages/qscintilla { };

      qtspell = callPackage ../qt-packages/qtspell { };

      qwlroots = callPackage ../qt-packages/qwlroots {
        wlroots = pkgs.wlroots_0_18;
      };

      qwt = callPackage ../qt-packages/qwt/default.nix { };

      qxlsx = callPackage ../qt-packages/qxlsx { };

      qzxing = callPackage ../qt-packages/qzxing { };

      poppler = callPackage ../qt-packages/poppler {
        lcms = pkgs.lcms2;
        qt6Support = true;
        suffix = "qt6";
      };

      sailfish-access-control-plugin = callPackage ../qt-packages/sailfish-access-control-plugin { };

      sddm-unwrapped = kdePackages.callPackage ../qt-packages/unwrapped.nix { };
      sddm = kdePackages.callPackage ../qt-packages { };

      sierra-breeze-enhanced =
        kdePackages.callPackage ../qt-packages/kwin-decorations/sierra-breeze-enhanced
          { };

      signond = callPackage ../qt-packages/signond { };

      timed = callPackage ../qt-packages/timed { };

      waylib = callPackage ../qt-packages/waylib { };

      wayqt = callPackage ../qt-packages/wayqt { };
    }
  );
}
