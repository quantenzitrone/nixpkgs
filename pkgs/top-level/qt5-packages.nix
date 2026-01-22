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
  pkgsHostTarget,
}:

let
  pkgs = __splicedPackages;
  # qt5 set should not be pre-spliced to prevent spliced packages being a part of an unspliced set
  # 'pkgsCross.aarch64-multiplatform.pkgsBuildTarget.targetPackages.libsForQt5.qtbase' should not have a `__spliced` but if qt5 is pre-spliced then it will have one.
  # pkgsHostTarget == pkgs
  qt5 = pkgsHostTarget.qt5;
in

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "libsForQt5";
  f = (
    self:
    let
      libsForQt5 = self;
      callPackage = self.callPackage;

      kdeFrameworks =
        let
          mkFrameworks = import ../qt-packages/kde-frameworks;
          attrs = {
            inherit config;
            inherit libsForQt5;
            inherit (pkgs) lib fetchurl;
          };
        in
        (lib.makeOverridable mkFrameworks attrs);

      noExtraAttrs =
        set:
        lib.attrsets.removeAttrs set [
          "extend"
          "override"
          "overrideScope"
          "overrideDerivation"
        ];

    in
    (noExtraAttrs (
      kdeFrameworks
      // qt5
      // {

        inherit
          kdeFrameworks
          qt5
          ;

        ### LIBRARIES

        accounts-qml-module = callPackage ../qt-packages/accounts-qml-module { };

        accounts-qt = callPackage ../qt-packages/accounts-qt { };

        appstream-qt = callPackage ../qt-packages/appstream/qt.nix { };

        dxflib = callPackage ../qt-packages/dxflib { };

        drumstick = callPackage ../qt-packages/drumstick { };

        fcitx5-qt = callPackage ../qt-packages/fcitx5/fcitx5-qt.nix { };

        futuresql = callPackage ../qt-packages/futuresql { };

        qgpgme = callPackage ../qt-packages/qgpgme { };

        grantlee = callPackage ../qt-packages/5 { };

        qtcurve = callPackage ../qt-packages/qtcurve { };

        herqq = callPackage ../qt-packages/herqq { };

        kdb = callPackage ../qt-packages/kdb { };

        kcolorpicker = callPackage ../qt-packages/kcolorpicker { };

        kdiagram = callPackage ../qt-packages/kdiagram { };

        kdsoap = callPackage ../qt-packages/kdsoap { };

        kirigami-addons = libsForQt5.callPackage ../qt-packages/kirigami-addons { };

        kimageannotator = callPackage ../qt-packages/kimageannotator { };

        kproperty = callPackage ../qt-packages/kproperty { };

        kquickimageedit = callPackage ../qt-packages/kquickimageedit/0.3.0.nix { };

        kuserfeedback = callPackage ../qt-packages/kuserfeedback { };

        ldutils = callPackage ../qt-packages/ldutils { };

        libcommuni = callPackage ../qt-packages/libcommuni { };

        libiodata = callPackage ../qt-packages/libiodata { };

        liblastfm = callPackage ../qt-packages/liblastfm { };

        libopenshot = callPackage ../qt-packages/libopenshot { };

        libopenshot-audio = callPackage ../qt-packages/libopenshot-audio { };

        libqglviewer = callPackage ../qt-packages/libqglviewer { };

        libqofono = callPackage ../qt-packages/libqofono { };

        libqtpas = callPackage ../qt-packages/fpc/libqtpas.nix { };

        libqaccessibilityclient = callPackage ../qt-packages/libqaccessibilityclient { };

        mapbox-gl-native = libsForQt5.callPackage ../qt-packages/mapbox-gl-native { };

        mapbox-gl-qml = libsForQt5.callPackage ../qt-packages/mapbox-gl-qml { };

        maplibre-gl-native = callPackage ../qt-packages/maplibre-gl-native { };

        maplibre-native-qt = callPackage ../qt-packages/maplibre-native-qt { };

        maui-core = libsForQt5.callPackage ../qt-packages/maui-core { };

        mlt = pkgs.mlt.override {
          qt = qt5;
        };

        phonon = callPackage ../qt-packages/phonon { };

        phonon-backend-gstreamer = callPackage ../qt-packages/phonon/backends/gstreamer.nix { };

        phonon-backend-vlc = callPackage ../qt-packages/phonon/backends/vlc.nix { };

        plasma-wayland-protocols = callPackage ../qt-packages/plasma-wayland-protocols { };

        polkit-qt = callPackage ../qt-packages/polkit-qt-1 { };

        poppler = callPackage ../qt-packages/poppler {
          lcms = pkgs.lcms2;
          qt5Support = true;
          suffix = "qt5";
        };

        pulseaudio-qt = callPackage ../qt-packages/pulseaudio-qt { };

        qca = callPackage ../qt-packages/qca {
          inherit (libsForQt5) qtbase;
        };
        qca-qt5 = self.qca;

        qcoro = callPackage ../qt-packages/qcoro { };

        qcustomplot = callPackage ../qt-packages/qcustomplot { };

        qjson = callPackage ../qt-packages/qjson { };

        qmltermwidget = callPackage ../qt-packages/qmltermwidget { };

        qoauth = callPackage ../qt-packages/qoauth { };

        qt5ct = callPackage ../qt-packages/qt5ct { };

        qtdbusextended = callPackage ../qt-packages/qtdbusextended { };

        qtfeedback = callPackage ../qt-packages/qtfeedback { };

        qtforkawesome = callPackage ../qt-packages/qtforkawesome { };

        qtutilities = callPackage ../qt-packages/qtutilities { };

        qtinstaller = callPackage ../qt-packages/qtinstaller { };

        qtkeychain = callPackage ../qt-packages/qtkeychain { };

        qtmpris = callPackage ../qt-packages/qtmpris { };

        qtpbfimageplugin = callPackage ../qt-packages/qtpbfimageplugin { };

        qtstyleplugins = callPackage ../qt-packages/qtstyleplugins { };

        qtstyleplugin-kvantum = callPackage ../qt-packages/qtstyleplugin-kvantum {
          qt6Kvantum = pkgs.qt6Packages.qtstyleplugin-kvantum;
        };

        quazip = callPackage ../qt-packages/quazip { };

        quickflux = callPackage ../qt-packages/quickflux { };

        qscintilla = callPackage ../qt-packages/qscintilla { };

        qwt = callPackage ../qt-packages/qwt/default.nix { };

        qwt6_1 = callPackage ../qt-packages/qwt/6_1.nix { };

        qxlsx = callPackage ../qt-packages/qxlsx { };

        qzxing = callPackage ../qt-packages/qzxing { };

        rlottie-qml = callPackage ../qt-packages/rlottie-qml { };

        sailfish-access-control-plugin = callPackage ../qt-packages/sailfish-access-control-plugin { };

        telepathy = callPackage ../qt-packages/qt { };

        qtwebkit-plugins = callPackage ../qt-packages/qtwebkit-plugins { };

        signond = callPackage ../qt-packages/signond { };

        timed = callPackage ../qt-packages/timed { };

        xp-pen-deco-01-v2-driver = callPackage ../qt-packages/deco-01-v2 { };
      }
      // lib.optionalAttrs config.allowAliases {
        kf5gpgmepp = throw ''
          'libsForQt5.kf5gpgmepp' has been removed because it has been unmaintained upstream since 2017.
          Consider switching to the gpgmepp included in gpgme (gpgme <2), or to the GnuPG fork of gpgmepp (gpgme 2+), instead.
        ''; # Added 2025-10-25
      }
    ))
  );
}
