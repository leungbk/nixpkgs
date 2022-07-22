{ lib, stdenv, fetchFromGitHub, makeWrapper, maven, openjdk, callPackage }:

stdenv.mkDerivation (finalAttrs: {
  pname = "odftools";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "tdf";
    repo = "odftoolkit";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hsrZt2y/IB+rMZkGyrW0UNCy7Tf2mCfYof4cfgi/Gdw=";
  };

  patches = [
    ./remove-housekeeping.patch
  ];

  deps = stdenv.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-deps";
    inherit (finalAttrs) src patches;

    nativeBuildInputs = [ maven ];

    buildPhase = ''
      runHook preBuild

      mvn package -Dmaven.repo.local=$out

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      find $out -type f \
        -name \*.lastUpdated -or \
        -name resolver-status.properties -or \
        -name _remote.repositories \
        -delete

      runHook postInstall
    '';

    dontFixup = true;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-qXS0Xogpox7lly2tpUPX4Z2fZHEcCm5g90g6foRdXz8=";
  };

  nativeBuildInputs = [
    makeWrapper
    maven
  ];

  buildInputs = [ openjdk ];

  # TODO:
  #   Constructing Javadoc information...
  #   error: Error fetching URL: https://xerces.apache.org/xerces-j/apiDocs/ (java.net.UnknownHostException: xerces.apache.org)

  buildPhase = ''
    runHook preBuild

    echo "Using repository ${finalAttrs.deps}"
    mvn --offline -Dmaven.repo.local=${finalAttrs.deps} package;

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/java

    cp odfdom/target/odfdom-java-${finalAttrs.version}-jar-with-dependencies.jar $out/share/java
    cp xslt-runner/target/xslt-runner-${finalAttrs.version}-jar-with-dependencies.jar $out/share/java
    cp validator/target/odfvalidator-${finalAttrs.version}-jar-with-dependencies.jar $out/share/java

    makeWrapper ${openjdk}/bin/java $out/bin/odfxsltrunner --add-flags "-jar \"$out/share/java/xslt-runner-${finalAttrs.version}-jar-with-dependencies.jar\""
    makeWrapper ${openjdk}/bin/java $out/bin/odfvalidator --add-flags "-jar \"$out/share/java/odfvalidator-${finalAttrs.version}-jar-with-dependencies.jar\""

    runHook postInstall
  '';
})
