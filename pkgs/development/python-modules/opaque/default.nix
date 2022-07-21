{ buildPythonPackage
, libopaque
, pysodium
, python
, substituteAll
}:

buildPythonPackage {
  inherit (libopaque) src meta version;

  pname = "opaque";

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      libopaque = "${libopaque}/lib/libopaque.so";
    })
  ];

  buildInputs = [
    libopaque
    pysodium
  ];

  checkPhase = ''
    ${python.interpreter} test/simple.py
  '';

  sourceRoot = "${libopaque.src.name}/python";
}
