{ buildPythonPackage
, qrcodegen
}:

buildPythonPackage {
  inherit (qrcodegen) pname src meta version;

  sourceRoot = "${qrcodegen.src.name}/python";
}
