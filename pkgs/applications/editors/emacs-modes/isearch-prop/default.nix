{ stdenv, fetchFromGitHub, emacs }:

stdenv.mkDerivation {
  name = "isearch-prop";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-prop";
    rev = "4a2765f835dd115d472142da05215c4c748809f4";
    sha256 = "06gdk5m84q6pxwng8rjxny1zkll8f3m2x6lw4xyib2dvg7iaslh3";
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
