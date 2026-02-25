# ROCm pre-built binary package
{ pkgs, rocmSources, target }:

let
  source = rocmSources.linux.${target};
in
  if source.url == ""
  then throw "ROCm sources not populated for ${target}. Run: python3 update-rocm.py"
  else
    pkgs.stdenv.mkDerivation {
      pname = "rocm7-bin-${target}";
      version = source.version;

      src = pkgs.fetchurl {
        url = source.url;
        sha256 = source.sha256;
      };

      dontBuild = true;
      dontConfigure = true;

      nativeBuildInputs = with pkgs; [
        gnutar
        gzip
        autoPatchelfHook
      ];

      buildInputs = with pkgs; [
        stdenv.cc.cc.lib
        gfortran.cc.lib
        zlib
        ncurses
        ocl-icd
        expat
        numactl
        libtool.lib
      ];

      autoPatchelfIgnoreMissingDeps = [
        "libtest_linking_lib1.so"
        "libtest_linking_lib2.so"
        "libpython3.10.so.1.0"
        "libpython3.11.so.1.0"
        "libpython3.12.so.1.0"
        "libpython3.13.so.1.0"
        "libpython3.14.so.1.0"
        "libcrypt.so.1"
      ];
      dontCheckForBrokenSymlinks = true;

      unpackPhase = "tar -xzf $src";

      installPhase = ''
        mkdir -p $out
        cp -r * $out/
        chmod -R u+w $out
        find $out -type f -name "*.so*" -exec chmod 755 {} \; 2>/dev/null || true
        find $out/bin -type f -exec chmod 755 {} \; 2>/dev/null || true
      '';

      meta = with pkgs.lib; {
        description = "Pre-built ROCm binaries from TheRock for ${target}";
        homepage = "https://github.com/ROCm/TheRock";
        license = licenses.mit;
        platforms = ["x86_64-linux"];
      };
    }
