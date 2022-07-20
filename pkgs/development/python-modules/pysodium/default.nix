{ buildPythonPackage
, fetchPypi
, lib
, libsodium
, substituteAll
}:

buildPythonPackage rec {
  pname = "pysodium";
  version = "0.7.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3e9005c770dca021889b2fe77db7ffa3c2e98fcac7e3cc1e8e157b9ed78f1fc8";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      libsodium = "${libsodium}/lib/libsodium.so";
    })
  ];

  buildInputs = [ libsodium ];

  meta = with lib; {
    description = "Python libsodium wrapper";
    homepage = "https://github.com/stef/pysodium";
    license = [ licenses.bsd2 ];

    maintainers = [ ];
  };
}
