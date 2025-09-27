{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (python312.withPackages (ps:
      with ps; [
        requests
        numpy
        ipython
        opencv-python
        pip
        black
        debugpy
      ]))
    pyright
  ];
}
