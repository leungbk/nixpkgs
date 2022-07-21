{ buildPythonPackage
, fetchPypi
, lib
, openssl
}:

buildPythonPackage rec {
  pname = "SecureString";
  version = "0.2";
  src = fetchPypi {
    inherit pname version;
    sha256 = "6432f341c941731caf1f9622e2db79d10c3779c0384cc1722fc8bc9e2a203d85";
  };

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Clear the contents of strings containing cryptographic material";
    homepage = "https://github.com/dnet/pysecstr";
    license = [ licenses.mit ];

    maintainers = [ ];
  };
}
