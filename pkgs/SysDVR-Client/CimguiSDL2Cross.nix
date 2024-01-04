{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  luajit,
  SDL2,
}:
stdenv.mkDerivation rec {
  pname = "CimguiSDL2Cross";
  version = "c8c3ab89d8da93c268e4fdcfb1d257af43b038c7";
  src = fetchFromGitHub {
    owner = "exelix11";
    repo = pname;
    rev = version;
    hash = "sha256-g5VAg8HmL6WlWTQ1juxvFAmgVNJ18/grcMYNuR0flKI=";
    name = "${pname}-git-${version}";
    fetchSubmodules = true;
  };

  buildInputs = [cmake luajit SDL2];

  configurePhase = ''
    pushd cimgui/generator
    export LUA_PATH="?;?.lua;$LUA_PATH"
    bash ./generator.sh
    popd

    mkdir build
    cd build
    cmake ../cimgui/
  '';

  buildPhase = ''
    cmake --build . --config Release
  '';

  installPhase = ''
    mkdir -p $out/lib
    cp cimgui.so $out/lib/
  '';

  meta = with lib; {
    description = "An hacky attempt at making a cross platform UI-thingy";
    homepage = "https://github.com/exelix11/CimguiSDL2Cross";
#    license = licenses.unfree;
    maintainers = [];
    platforms = ["x86_64-linux"];
  };
}
