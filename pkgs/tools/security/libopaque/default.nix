{ lib
, stdenv
, fetchFromGitHub
, pkgconf
, libsodium
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libopaque";
  version = "unstable-2022-07-15";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "libopaque";
    rev = "bc83e13732330af044fd27476b9ee0d68217eff6";
    fetchSubmodules = true;
    sha256 = "sha256-V0j+4NQrC9vARKv1ZJGZ+IzoOjrHqJgD7X743+mDcq8=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  makeFlags = [ "PREFIX=$(out)" ];

  buildPhase = ''
    runHook preBuild

    make libopaque.so
    make libopaque.a
    make utils/opaque

    runHook postBuild
  '';

  # XXX: when install is run, it tries to cp some files for some reason
  preInstall = ''
    mkdir -p $out/lib $out/include $out/bin
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    make tests

    runHook postCheck
  '';

  nativeBuildInputs = [
    pkgconf
  ];

  buildInputs = [
    libsodium
  ];

  meta = with lib; {
    description = "Asymmetric password-authenticated key-exchange protocol";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
