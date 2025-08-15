# Flutter Flame Game Dev Container

This dev container is pre-configured with everything you need to develop Flutter Flame games in GitHub Codespaces or VS Code Dev Containers.

## What's Included

### Build Tools
- CMake
- Ninja build system
- Build-essential (gcc, g++, make)
- Clang/LLVM toolchain

### Flutter Dependencies
- Flutter SDK (latest stable)
- Dart SDK
- Web support enabled
- All necessary Flutter development tools

### Linux Desktop Dependencies
- GTK3 development libraries
- OpenGL/EGL libraries
- X11 development libraries
- Required system libraries for Flutter Linux apps

### VS Code Extensions
- Dart-Code.dart-code (Dart language support)
- Dart-Code.flutter (Flutter development tools)
- GitHub Copilot
- GitHub Pull Request integration
- GitHub Actions support

## Quick Start

1. **Open in Codespaces**: The container will automatically build and set up everything
2. **Run the game**: `flutter run -d web-server --web-port=8080`
3. **Open your browser**: Navigate to `http://localhost:8080`

## Commands

```bash
# Run the app on web
flutter run -d web-server --web-port=8080

# Run the app on Linux desktop (if display is available)
flutter run -d linux

# Hot reload (when app is running)
r

# Hot restart (when app is running)
R

# Build for web
flutter build web

# Check Flutter installation
flutter doctor
```

## Port Forwarding

Port 8080 is automatically forwarded and labeled as "Flutter Web Server" for easy access.

## Environment Variables

- `CXX=clang++` - C++ compiler
- `CC=clang` - C compiler
- `PATH` includes Flutter SDK

## Troubleshooting

If you encounter any issues:

1. **Rebuild the container**: Use VS Code command palette → "Dev Containers: Rebuild Container"
2. **Check Flutter doctor**: Run `flutter doctor` to verify installation
3. **Clear Flutter cache**: Run `flutter clean` then `flutter pub get`

## File Structure

```
.devcontainer/
├── devcontainer.json    # Dev container configuration
├── Dockerfile          # Container image definition
└── setup.sh            # Post-creation setup script
```

This configuration ensures that every time you open the workspace in a dev container, you'll have a fully functional Flutter Flame game development environment ready to go!
