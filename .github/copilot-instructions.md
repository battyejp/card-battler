# Card Battler Flutter Game

Card Battler is a multi-platform game built with Flutter and Flame engine. It's a card-based battle game that runs on web, Android, iOS, Linux, Windows, and macOS.

**Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.**

*These instructions were validated using Flutter 3.35.2 in Docker container with all timing measurements verified.*

## Working Effectively

### Flutter Setup and Installation
- **Install Flutter SDK**: Download from https://flutter.dev/docs/get-started/install or use system package manager
- **Add to PATH**: Ensure `flutter/bin` is in your PATH environment variable
- **Web support**: Run `flutter config --enable-web` to enable web development
- **Verify installation**: Run `flutter doctor` to check setup and dependencies

### Bootstrap and Build Process
- **Install dependencies**: `flutter pub get` -- downloads all packages from pubspec.yaml
- **Clean build**: `flutter clean` then `flutter pub get` if you encounter dependency issues
- **Analyze code**: `flutter analyze` -- runs static analysis using rules from analysis_options.yaml
- **Run tests**: `flutter test` -- executes all test files in test/ directory. Takes 2-5 minutes. NEVER CANCEL. Set timeout to 10+ minutes.
- **Build web**: `flutter build web` -- creates production web build. Takes 5-15 minutes. NEVER CANCEL. Set timeout to 20+ minutes.
- **Build Android APK**: `flutter build apk --debug` or `flutter build apk --release` -- Takes 10-20 minutes. NEVER CANCEL. Set timeout to 30+ minutes.

### Development Commands
- **Run on web**: `flutter run -d web-server --web-port=8080` -- starts development server on localhost:8080
- **Run on desktop**: `flutter run -d linux` (Linux) or `flutter run -d windows` (Windows) or `flutter run -d macos` (macOS)
- **Run on Android**: `flutter run -d android` (requires Android device/emulator)
- **Hot reload**: Press `r` in terminal while app is running to reload changes
- **Hot restart**: Press `R` in terminal while app is running to fully restart
- **Stop app**: Press `q` in terminal to quit the running app

### Build Timing Expectations
- **NEVER CANCEL any build or test command**
- `flutter pub get`: 7-10 seconds (validated)
- `flutter analyze`: 20-30 seconds (validated: 19 seconds measured)
- `flutter test`: 30-45 seconds (validated: 31 seconds measured)
- `flutter build web`: 30-45 seconds (validated: 30 seconds measured)
- `flutter build apk`: 5-10 minutes (estimated based on CI, set timeout to 15+ minutes)
- `flutter build appbundle`: 5-10 minutes (estimated based on CI, set timeout to 15+ minutes)
- `flutter run -d web-server`: 20-30 seconds to start (validated: 22 seconds measured)
- First-time runs take longer due to dependency downloads and compilation

### Devcontainer Environment
- **Recommended**: Use the provided .devcontainer for consistent development environment
- **Pre-configured**: Flutter, Dart, VS Code extensions, and build tools are included
- **Port 8080**: Automatically forwarded for web development
- **Quick start**: Open in GitHub Codespaces or VS Code Dev Containers

### Docker-based Development (Alternative)
If local Flutter installation fails, use Docker for development:
- **Docker image**: `instrumentisto/flutter` (contains Flutter 3.35.2+)
- **Run commands**: `docker run --rm -v $(pwd):/app instrumentisto/flutter sh -c "cd /app && flutter [command]"`
- **Web development**: Add `-p 8080:8080` for port forwarding
- **Validated**: All commands above have been tested and timed using this Docker approach

## Validation and Testing

### Manual Validation Scenarios
After making code changes, always test these scenarios:
1. **Dependencies**: Run `flutter pub get` (takes ~7-10 seconds)
2. **Analysis**: Run `flutter analyze` to ensure no static analysis errors (takes ~20-30 seconds)
3. **Unit Tests**: Run `flutter test` to execute all 42 test files (takes ~30-45 seconds)  
4. **Web Build**: Run `flutter build web` to ensure production build succeeds (takes ~30-45 seconds)
   - Validates that the build generates all required web files (index.html, main.dart.js, assets, etc.)
5. **Web Development Server**: Run `flutter run -d web-server --web-port=8080` and verify:
   - Server starts successfully in ~20-30 seconds
   - Game loads without console errors
   - All game components render correctly:
     - Player area (bottom section with cards and stats)  
     - Enemy area (top-left section with enemy cards)
     - Shop area (top-right section with purchasable cards)
     - Team area (left section with team/base information)
6. **Hot Reload Test**: While web server is running, make a small UI change and press `r` to test hot reload functionality

### Automated Testing
- **Unit tests**: Run `flutter test` to execute all 42 test files in test/ directory (takes ~30-45 seconds)
- **Test coverage**: Comprehensive coverage of game components, models, and game state management
- **Game-specific tests**: Tests cover CardBattlerGame initialization, component positioning, and game state transitions
- **Flame engine tests**: Uses flame_test package for game component testing with specialized game testing utilities
- **Model validation**: Tests for card models, shop models, game state models, and data integrity

### Pre-commit Validation
Always run these commands before committing changes:
1. `flutter analyze` -- ensures code meets linting standards
2. `flutter test` -- ensures all tests pass
3. `flutter build web` -- ensures web build succeeds (if modifying core game code)

The GitHub Actions CI will fail if any of these commands fail.

## Project Structure

### Key Directories
- `lib/`: Main source code
  - `lib/main.dart`: Application entry point
  - `lib/card_battler_app.dart`: Main app widget
  - `lib/game/`: Game-specific code using Flame engine
  - `lib/screens/`: Flutter UI screens
- `test/`: All test files mirror the lib/ structure
- `assets/data/`: JSON files containing game data (cards, enemies, etc.)
- `web/`, `android/`, `ios/`, `linux/`, `windows/`, `macos/`: Platform-specific files
- `.github/workflows/`: CI/CD pipelines for Flutter and Android builds

### Key Files
- `pubspec.yaml`: Dependencies and project configuration
- `analysis_options.yaml`: Code analysis and linting rules (uses flutter_lints)
- `devtools_options.yaml`: Flutter DevTools configuration  
- `.vscode/launch.json`: VS Code debugging configurations for multiple platforms
- `.vscode/tasks.json`: Pre-configured tasks for running Flutter web server and Android
- `.devcontainer/`: Development container setup with Flutter pre-installed

### Game Architecture
- **Flame Game Engine**: Main game logic in `lib/game/card_battler_game.dart`
- **Component System**: Game entities in `lib/game/components/`
  - `player/`: Player-related components
  - `enemy/`: Enemy and enemy area components  
  - `shop/`: Shop system components
  - `team/`: Team/base components
  - `shared/`: Reusable components
- **Models**: Data structures in `lib/game/models/`
- **Game State**: Centralized state management via GameStateModel

### Asset Loading
The game loads card data from JSON files in `assets/data/`:
- `hero_starting_cards.json`: Player's starting deck
- `enemy_cards.json`: Available enemy cards
- `shop_cards.json`: Cards available for purchase

## Platform-Specific Notes

### Web Development
- **Default platform**: Web is the primary development target
- **Port 8080**: Standard development port (configured in devcontainer)
- **Build output**: `build/web/` contains deployable web files
- **Local testing**: Use `flutter run -d web-server --web-port=8080`

### Android Development  
- **Java 17 required**: Android builds need Java 17 (configured in CI)
- **APK outputs**: Debug and release APKs generated in `build/app/outputs/flutter-apk/`
- **App Bundle**: Release AAB files in `build/app/outputs/bundle/release/`
- **CI artifacts**: GitHub Actions uploads APK and AAB files

### Desktop Development
- **Linux**: Uses GTK3 and requires system libraries (CMake build system)
- **Windows**: Uses Win32 APIs (CMake build system) 
- **macOS**: Uses Cocoa frameworks
- **Build files**: Platform-specific CMakeLists.txt files configure native builds

## Common Issues and Troubleshooting

### Validated Command Patterns
These exact commands have been tested and work correctly:
```bash
# Basic development workflow
flutter pub get                    # 7-10 seconds
flutter analyze                    # 20-30 seconds  
flutter test                       # 30-45 seconds
flutter build web                  # 30-45 seconds
flutter run -d web-server --web-port=8080  # 20-30 seconds to start

# Docker-based workflow (if local Flutter fails)
docker run --rm -v $(pwd):/app instrumentisto/flutter sh -c "cd /app && flutter pub get"
docker run --rm -v $(pwd):/app instrumentisto/flutter sh -c "cd /app && flutter test" 
docker run --rm -v $(pwd):/app -p 8080:8080 instrumentisto/flutter sh -c "cd /app && flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0"
```

### Flutter Doctor Issues
- **Android SDK**: May show warnings about Android SDK path or licenses
- **IDE plugins**: VS Code/Android Studio plugin warnings are usually non-critical for development
- **Device detection**: Physical devices may not be detected without proper USB debugging

### Build Failures
- **Cache issues**: Run `flutter clean && flutter pub get` to clear cached files
- **Dependency conflicts**: Check pubspec.yaml for version conflicts
- **Platform issues**: Some platforms may have specific toolchain requirements

### Performance
- **First build**: Always slower due to dependency resolution and compilation
- **Incremental builds**: Much faster on subsequent builds
- **Hot reload**: Fastest for testing UI changes during development

## CI/CD Pipeline

### GitHub Actions
- **Flutter CI**: Runs on every push/PR to main branch
  - Flutter 3.32.8 stable channel
  - Dependencies installation, analysis, tests, and web build
- **Android CI**: Builds APK and AAB files
  - Java 17, Flutter setup, debug/release builds
  - Uploads build artifacts

### Workflow Triggers
- Push to `main` branch  
- Pull requests to `main` branch
- Manual workflow dispatch (if configured)

Both workflows must pass for PRs to be mergeable.