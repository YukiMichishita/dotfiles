{
  # Common kanata keymap configuration
  # dws.nix timing values take priority: 50 230 for most keys, 1 230 for f key

  kanataKeymap = ''
    (defsrc
      tab  q w e r t y u i o p bspc
      lctl a s d f g h j k l ; '
      lsft z x c v b n m , . / esc
         lmet caps spc ret del rmet
    )

    (defalias
        JP_ON_CMD  C-spc
        EN_CMD     C-spc
    )

    (deflayer base
      _  q w e r t y u i o p _
      _
        (tap-hold-release 100 230 a lalt)
        (tap-hold-release 100 230 s lmet)
        (tap-hold-release 100 230 d lctl)
        (tap-hold-release  1 230 f lsft)
        g h
        (tap-hold-release 100 230 j lsft)
        (tap-hold-release 100 230 k lctl)
        (tap-hold-release 100 230 l lmet)
        (tap-hold-release 50 230 ; lalt)
      '
      _ z x c v b n m , . / _
      C-spc
      (tap-hold 50 230 spc (layer-toggle raise))
      esc
      rsft
      (tap-hold 50 230 ret (layer-toggle lower))
      bspc
    )

    (deflayer lower
      _ f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11
      _ _ _ _ _ _ _ _ _ _ f12 _
      _ _ _ _ _ _ _ _ _ _ _ _
          _ esc _ _ _ _
    )

    (deflayer raise
      _ 1 2 3 4 5   6    7    8  9   0 _
      _ _ _ _ _ tab left down up right - =
      _ _ _ _ _ _ _ _ [ ] bksl `
          _ _ _ _ _ _
    )

    (deflayer util
      _ 1 2 3 4 5   6    7    8  9     0 _
      _ M-a _ _ _ _ home down up end _ _
      _ M-z M-x M-c M-v _ _ _ pgup pgdn _ _
          _ _ _ _ _ _
    )
  '';
}
