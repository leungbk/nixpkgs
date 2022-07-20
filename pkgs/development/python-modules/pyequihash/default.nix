{ buildPythonPackage
, equihash
, substituteAll
}:

buildPythonPackage {
  inherit (equihash) src meta version;

  pname = "pyequihash";

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      libequihash = "${equihash}/lib/libequihash.so";
    })
  ];

  buildInputs = [ equihash ];

  sourceRoot = "${equihash.src.name}/python";
}
