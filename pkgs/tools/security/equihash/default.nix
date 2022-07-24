{ lib
, stdenv
, fetchFromGitHub
, libsodium
}:

stdenv.mkDerivation {
  pname = "equihash";
  version = "unstable-2022-06-14";

  src = fetchFromGitHub {
    owner = "stef";
    repo = "equihash";
    rev = "d3a5edec7a650cdfe6084cf4b65a9d8acc43b3c4";
    sha256 = "sha256-4MESq5pD6DXN+jGXvE200MTwDSzWdpIpxytHI+n0g04=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildPhase = ''
    runHook preBuild

    make libequihash.so
    make libequihash.a

    runHook postBuild
  '';

  # XXX: when install is run, it tries to cp some files for some reason
  preInstall = ''
    mkdir -p $out/lib $out/include $out/share/pkgconfig
  '';

  # XXX: this is solely to make this work with zphinx-zerver
  postInstall = ''
    cd $out/lib
    ln -s -T libequihash.so libequihash.so.0
  '';

  buildInputs = [
    libsodium
  ];

  meta = with lib; {
    description = "Asymmetric proof-of-work algorithm";
    homepage = "https://github.com/stef/equihash";
    license = licenses.cc0;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
