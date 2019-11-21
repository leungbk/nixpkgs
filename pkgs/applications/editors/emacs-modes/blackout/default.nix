{ stdenv, fetchFromGitHub, emacs }:

stdenv.mkDerivation {
  name = "blackout";

  src = fetchFromGitHub {
    owner = "raxod502";
    repo = "blackout";
    rev = "4bac44671fca4c98d96aa94c79946bf4d4baf0ee";
    sha256 = "1wnh0nwy6r3a18sy9sqmrwv04vnmaflxy4g7mq8jiyyjijri7l1b";
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
