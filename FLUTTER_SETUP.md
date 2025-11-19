# Flutter Setup Guide

## Issue: Flutter Command Not Found

Flutter is not in your system PATH. Here are solutions:

## Option 1: Install Flutter (if not installed)

### macOS Installation:

1. **Download Flutter SDK:**
   ```bash
   cd ~
   git clone https://github.com/flutter/flutter.git -b stable
   ```

2. **Add to PATH:**
   Add this to your `~/.zshrc` file:
   ```bash
   export PATH="$PATH:$HOME/flutter/bin"
   ```

3. **Reload shell:**
   ```bash
   source ~/.zshrc
   ```

4. **Verify installation:**
   ```bash
   flutter doctor
   ```

## Option 2: Install via Homebrew (Recommended)

```bash
brew install --cask flutter
```

Then add to PATH:
```bash
echo 'export PATH="$PATH:/usr/local/share/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

## Option 3: Use Flutter via IDE

If you're using **Cursor** or **VS Code**:

1. Install the Flutter extension
2. The IDE will help you locate/install Flutter
3. Use the IDE's run/debug buttons instead of terminal

## Option 4: Find Existing Flutter Installation

If Flutter is already installed elsewhere:

1. **Search for Flutter:**
   ```bash
   find /Applications -name "flutter" 2>/dev/null
   find ~ -name "flutter" -type f -path "*/bin/flutter" 2>/dev/null
   ```

2. **Add to PATH:**
   Once found, add the `bin` directory to your PATH in `~/.zshrc`

## Quick Fix: Add Flutter to PATH (if already installed)

1. **Edit your zshrc:**
   ```bash
   nano ~/.zshrc
   ```

2. **Add this line (adjust path as needed):**
   ```bash
   export PATH="$PATH:$HOME/flutter/bin"
   ```

3. **Save and reload:**
   ```bash
   source ~/.zshrc
   ```

## Verify Setup

After installation, run:
```bash
flutter doctor
flutter --version
```

## View Your Updated UI

Once Flutter is working:

```bash
cd /Users/lawliu/Desktop/Track2College
flutter pub get
flutter run
```

Then navigate to the Help page in your app to see the new UI!

## Need Help?

- Flutter installation guide: https://docs.flutter.dev/get-started/install/macos
- Flutter doctor will tell you what else needs to be configured





