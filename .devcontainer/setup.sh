#!/bin/bash

# Flutter Flame Game Dev Container Setup Script
echo "🚀 Setting up Flutter Flame Game development environment..."

# Configure Flutter for web development
echo "📱 Configuring Flutter for web..."
flutter config --enable-web

# Install project dependencies
echo "📦 Installing project dependencies..."
flutter pub get

# Verify setup
echo "🔍 Verifying Flutter installation..."
flutter doctor

echo "✅ Setup complete! You can now run:"
echo "   flutter run -d web-server --web-port=8080"
echo ""
echo "🌐 Your app will be available at: http://localhost:8080"
echo ""
echo "🎮 Happy coding! Your Flutter Flame game environment is ready!"