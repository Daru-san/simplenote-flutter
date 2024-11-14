{
  flutter,
  lib,
  pkg-config,
  gtk3,
  enableDebug ? true,
}:
flutter.buildFlutterApplication {
  pname = "simplenote-flutter";

  version = "0.0.1-dev" + lib.optionalString enableDebug "-debug";

  src = ../.;

  nativeBuildInputs = [
    pkg-config
  ];

  flutterMode = lib.optionalString enableDebug "debug";

  buildInputs = [ gtk3 ];

  autoPubspecLock = ../pubspec.lock;

  meta = {
    description = "Simplenote app written in flutter.";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.daru-san ];
    mainProgram = "simplenote-flutter";
  };
}
