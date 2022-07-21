{ buildPythonPackage
, fetchPypi
, lib
, libsphinx
, pyequihash
, pysodium
, qrcodegen
, SecureString
, substituteAll
, zxcvbn
}:

buildPythonPackage rec {
  pname = "pwdsphinx";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f757c7de65e16d41d062a0c8c76afb55d0d62b0ef58b1798199b32bde8aa0b3";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      libsphinx = "${libsphinx}/lib/libsphinx.so";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "zxcvbn-python" "zxcvbn"
  '';

  # XXX: tests 1) require a config file in the right place 2) fail to import pwdsphinx.bin2pass
  doCheck = false;

  pythonImportsCheck = [
    "pwdsphinx.bin2pass"
    # # this requires a config file to be defined in the right place
    # "pwdsphinx.sphinx"
  ];

  buildInputs = [
    libsphinx
    pyequihash
    pysodium
    qrcodegen
    SecureString
    zxcvbn
  ];

  meta = with lib; {
    description = "Python wrapper for a password Store that Perfectly Hides from Itself (No Xaggeration)";
    homepage = "https://github.com/stef/pwdsphinx";
    license = [ licenses.gpl3Plus ];

    maintainers = [ ];
  };
}
