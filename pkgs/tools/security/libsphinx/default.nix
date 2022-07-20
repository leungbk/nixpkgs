{ lib
, stdenv
, fetchFromGitHub
, libsodium
, pkgconf
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libsphinx";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "libsphinx";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-1AuHrjMN0vDEvv9EHzaD8PNwq9GtOCVc/kAOryUEBBU=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  sourceRoot = "${finalAttrs.src.name}/src";

  buildPhase = ''
    runHook preBuild

    make bin
    make libsphinx.so

    runHook postBuild
  '';

  # XXX: when install is run, it tries to cp some files for some reason
  preInstall = ''
    mkdir -p $out/lib $out/include
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
    description = "a password Store that Perfectly Hides from Itself (No Xaggeration)";
    homepage = "https://github.com/stef/libsphinx";
    license = licenses.gpl3Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
