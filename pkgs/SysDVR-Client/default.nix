{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  ffmpeg_5,
  SDL2,
  SDL2_image,
  # usb streaming
  libusb1,
  # for the builtin player
  pulseaudio,
  libGL,
  CimguiSDL2Cross,
}:
buildDotnetModule rec {
  pname = "SysDVR-Client";
  version = "b923f068eda208e7129bd3cd04aa8b27b79ca6b2";

  src =
    fetchFromGitHub {
      owner = "exelix11";
      repo = "SysDVR";
      rev = "${version}";
      hash = "sha256-bLNUD5YQf72a8fGYxYbizg98S+fnbKyb4TgexUUwtKg=";
      name = "${pname}-git-${version}";
    }
    + "/Client";

  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  preBuildPhase = ''
    mkdir -p Resources/linux-x64/native
    cp ${CimguiSDL2Cross}/lib/cimgui.so Resources/linux-x64/native
  '';

  nugetDeps = ./deps.nix;
  runtimeDeps = [ffmpeg_5 SDL2 SDL2_image libusb1 pulseaudio libGL CimguiSDL2Cross];
  buildType = "Release";
  dotnetFlags = [
    "-property:PublishAot=false"
    "-property:GitCommitHash=${builtins.substring 0 7 version}-nix"
  ];

  executables = ["SysDVR-Client"];

  meta = with lib; {
    description = "Stream switch games to your PC via USB or network";
    homepage = "https://github.com/exelix11/SysDVR";
    license = licenses.gpl2;
    maintainers = [];
    platforms = ["x86_64-linux"];
  };
}
