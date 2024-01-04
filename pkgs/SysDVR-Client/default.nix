{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  ffmpeg_5,
  SDL2,
  SDL2_image,
  gcc,
  # repo version during build
  git,
  # usb streaming
  libusb1,
  # for the builtin player
  pulseaudio,
  libGL,
  CimguiSDL2Cross,
}:
buildDotnetModule rec {
  pname = "SysDVR-Client";
  version = "b68349f9c6896ecdaf420cd53e298f914f2e5400";

  src =
    fetchFromGitHub {
      owner = "exelix11";
      repo = "SysDVR";
      rev = "${version}";
      hash = "sha256-QUuKZKuuMHxmyloAIiDxwZBZOQbOPqvo/EtSfPTtWvU=";
      name = "${pname}-git-${version}";
      leaveDotGit = true;
    }
    + "/Client";

  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  preBuildPhase = ''
    mkdir -p Resources/linux-x64/native
    cp ${CimguiSDL2Cross}/lib/cimgui.so Resources/linux-x64/native
  '';

  buildInputs = [git gcc];
  nugetDeps = ./deps.nix;
  runtimeDeps = [ffmpeg_5 SDL2 SDL2_image libusb1 pulseaudio libGL CimguiSDL2Cross];
  buildType = "Release";
  dotnetFlags = ["-property:PublishAot=false"];

  executables = ["SysDVR-Client"];

  meta = with lib; {
    description = "Stream switch games to your PC via USB or network";
    homepage = "https://github.com/exelix11/SysDVR";
    license = licenses.gpl2;
    maintainers = [];
    platforms = ["x86_64-linux"];
  };
}
