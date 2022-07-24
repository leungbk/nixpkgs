{ stdenv
, lib
, fetchFromGitHub
, zig
, equihash
, libsodium
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zphinx-zerver";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "zphinx-zerver";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-3MxNIRfASIEe4fp5bX65LIeFogFMhZ5UqCZLKmKZnf0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    zig
  ];

  buildInputs = [
    equihash
    libsodium
  ];

  preBuild = ''
    export HOME=$TMPDIR
  '';

  installPhase = ''
    runHook preInstall

    zig build -Drelease-safe -Dcpu=baseline --prefix $out install

    runHook postInstall
  '';

  meta = with lib; {
    description = "Opaque server for a cryptographic password store";
    homepage = "https://github.com/stef/zphinx-zerver";
    license = licenses.agpl3;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
