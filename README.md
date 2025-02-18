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
3. **Release maintainence**:
   ```bash
   build for both ios and android are configured using github that dumps both the ios and android build to firebase distribution
   https://console.firebase.google.com/project/college-finder-54f2c/appdistribution/app/android:com.frugal.CollegeFinder/releases

   Versioning is taken care automatically by Fastlane in github itself
   To release follow the below steps:
   - push the changes to the branch main
   - once the build completes go to the distribution section
   - for Play store - download the lastest aab from distribution section and upload directly on playstore after logging in to the dev account
   - for Apple store - download the latest ipa file from distribution section and upload using TRANSPORTER app using mac after logging in to the dev account
   - Yay! build release, yup it's that easy :-)
   
4. **👥 Contributors**: 
   Your Name - Sudarshan Mehta, Sonam Yegde
📜 License
   This project is licensed under the MIT License.
