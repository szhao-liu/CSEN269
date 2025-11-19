# 🎓 Track2College App

Track2College is a Flutter app that helps students and aspiring applicants find the best colleges suited to their academic interests, budget, and location preferences. With a user-friendly interface and comprehensive filters, Track2College simplifies the college search process by delivering relevant information and recommendations at the user's fingertips.

## 🚀 Features

- **Tasks**: Complete each task to reach the college of your choice.
- **Upload Resumes**: Keep a track of build resumes for college applications.

## 🛠️ Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/username/CollegeFinder.git
   cd CollegeFinder

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

## 🌐 Running the App in Chrome (Demo)

To demo the app in your Chrome browser:

1. **Check available devices**:
   ```bash
   flutter devices
   ```

2. **Run the app in Chrome**:
   ```bash
   flutter run -d chrome
   ```

   The app will:
   - Compile for web (this may take a minute or two on first run)
   - Automatically open in Chrome browser
   - Start a local web server (usually on `http://localhost:xxxxx`)

3. **Stop the app**:
   - Press `q` in the terminal, or
   - Close the Chrome browser window

### Troubleshooting Chrome Demo

- If Chrome doesn't open automatically, look for the URL in the terminal output and open it manually
- Make sure you have Chrome installed on your system
- If you encounter build errors, try: `flutter clean && flutter pub get`
- For hot reload: Press `r` in the terminal while the app is running
- For hot restart: Press `R` in the terminal while the app is running

## 📦 Release Maintenance

Builds for both iOS and Android are configured using GitHub that dumps both the iOS and Android builds to Firebase distribution:
https://console.firebase.google.com/project/college-finder-54f2c/appdistribution/app/android:com.frugal.CollegeFinder/releases

Versioning is taken care of automatically by Fastlane in GitHub itself.

**To release, follow these steps:**
1. Push the changes to the branch `main`
2. Once the build completes, go to the distribution section
3. **For Play Store**: Download the latest `.aab` from the distribution section and upload directly to Play Store after logging into the dev account
4. **For Apple Store**: Download the latest `.ipa` file from the distribution section and upload using the TRANSPORTER app on Mac after logging into the dev account
5. Yay! Build released - it's that easy! 🎉
   
## 👥 Contributors

- Sudarshan Mehta
- Sonam Yedge

## 📜 License

This project is licensed under the MIT License.
