self: super: {

  cbor2WithoutCExtensions = self.cbor2.override {
    withCExtensions = false;
  };

  conduit-mpi = self.conduit.override {
    mpiSupport = true;
  };

  sudachidict-full = self.sudachidict-core.override {
    sudachidict = self.pkgs.sudachidict.override { dict-type = "full"; };
  };

  sudachidict-small = self.sudachidict-core.override {
    sudachidict = self.pkgs.sudachidict.override { dict-type = "small"; };
  };

  qscintilla = self.pyqt6-qscintilla.override {
    useQt6 = false;
  };

}
