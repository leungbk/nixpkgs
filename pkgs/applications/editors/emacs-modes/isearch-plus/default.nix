{ stdenv, fetchFromGitHub, emacs }:

stdenv.mkDerivation {
  name = "isearch-plus";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-plus";
    rev = "376a8f9f8a9666d7e61d125abcdb645847cb8619";
    sha256 = "0m2sfyq6rziwg403k2j0smahy5wwcx5fqbnb7m4mn8x6xyk6zpi9";
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
