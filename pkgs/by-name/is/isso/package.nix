{
  lib,
  python3Packages,
  fetchFromGitHub,
  nixosTests,
  fetchNpmDeps,
  nodejs_20,
  npmHooks,
}:

python3Packages.buildPythonApplication rec {
  pname = "isso";
  version = "0.13.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "posativ";
    repo = "isso";
    tag = version;
    sha256 = "sha256-kZNf7Rlb1DZtQe4dK1B283OkzQQcCX+pbvZzfL65gsA=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-RBpuhFI0hdi8bB48Pks9Ac/UdcQ/DJw+WFnNj5f7IYE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  postPatch = ''
    # Remove when https://github.com/posativ/isso/pull/973 is available.
    substituteInPlace isso/tests/test_comments.py \
      --replace "self.client.delete_cookie('localhost.local', '1')" "self.client.delete_cookie(key='1', domain='localhost')"
  '';

  propagatedBuildInputs = with python3Packages; [
    itsdangerous
    jinja2
    misaka
    html5lib
    werkzeug
    bleach
    flask-caching
  ];

  nativeBuildInputs = [
    python3Packages.cffi
    python3Packages.sphinxHook
    python3Packages.sphinx
    nodejs_20
    npmHooks.npmConfigHook
  ];

  NODE_PATH = "$npmDeps";

  preBuild = ''
    ln -s ${npmDeps}/node_modules ./node_modules
    export PATH="${npmDeps}/bin:$PATH"

    make js
  '';

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pytest-cov-stub
  ];

  passthru.tests = { inherit (nixosTests) isso; };

  meta = {
    description = "Commenting server similar to Disqus";
    mainProgram = "isso";
    homepage = "https://posativ.org/isso/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
