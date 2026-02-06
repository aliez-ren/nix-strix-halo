{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, zlib
, glibc,
...
}:

stdenv.mkDerivation rec {
  pname = "llamacpp-rocm";
  version = "b1025";

  # GPU target for Strix Halo
  gfxTarget = "gfx1151";

  src = fetchzip {
    url = "https://github.com/lemonade-sdk/llamacpp-rocm/releases/download/${version}/llama-${version}-ubuntu-rocm-${gfxTarget}-x64.zip";
    hash = "sha256-4RNwHQLhUcYSrma4ybAM2Kzp5jhYRlDGbUzPGRBjM34=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc.lib
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    glibc
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin/
    chmod +x $out/bin/*
  '';

  meta = with lib; {
    description = "Llama.cpp with ROCm support for AMD GPUs";
    homepage = "https://github.com/lemonade-sdk/llamacpp-rocm";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ "georgewhewell" ];
  };
}
