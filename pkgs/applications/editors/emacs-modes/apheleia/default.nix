{ stdenv, fetchFromGitHub, emacs }:

stdenv.mkDerivation {
  name = "apheleia";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = "apheleia";
    rev = "8e99a67cc185db01298a282e0d24277249bcfab8";
    sha256 = "02np55c32jy5j7s0qkmrb1qggh4r05y12k10pwd88hl8y64sp35c";
  };

  buildInputs = [ emacs ];

  buildPhase = ''
    emacs -L . --batch -f batch-byte-compile *.el
  '';

  installPhase = ''
    install -d $out/share/emacs/site-lisp
    install *.el *.elc $out/share/emacs/site-lisp
  '';
}
