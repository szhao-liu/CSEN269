# 🎓 CollegeFinder App

CollegeFinder is a Flutter app that helps students and aspiring applicants find the best colleges suited to their academic interests, budget, and location preferences. With a user-friendly interface and comprehensive filters, CollegeFinder simplifies the college search process by delivering relevant information and recommendations at the user's fingertips.

## 🚀 Features

- **Search Colleges**: Find colleges by name, location, or specific criteria.
- **Filter Options**: Filter results based on factors like ranking, tuition cost, location, program, and more.
- **College Details**: View detailed information for each college, including programs offered, tuition fees, admission requirements, and campus facilities.
- **Favorites**: Save favorite colleges for quick access later.
- **Recommendations**: Get personalized college recommendations based on profile preferences.
- **Location-Based Search**: Find colleges close to your current location.

## 📱 Screenshots

_Add screenshots of the main screens to showcase the UI and app functionality._

## 🛠️ Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/username/CollegeFinder.git
   cd CollegeFinder

2. **Install dependencies**:
   ```bash
   flutter pub get
   
3. **Configure API keys**:
- Add your API keys (e.g., for college data API, map APIs) in a .env file for secure management.
- Set up environment variables by adding a .env file in the project root.

4. **Run the app**:
   ```bash
   flutter run

5. **🔑 Environment Variables**:
Create a .env file in the root directory with the following:
    ```bash
   COLLEGE_API_KEY=your_college_api_key
   MAP_API_KEY=your_map_api_key

6. **🧩 Dependencies**: 
   flutter_riverpod: For state management
   http: For API calls
   flutter_dotenv: For managing API keys and environment variables
   geolocator: For location-based services
   cached_network_image: To cache college images

7. **📂 Folder Structure**
   lib/
      screens/: Contains all screen widgets (e.g., home screen, details screen, search screen).
      widgets/: Contains reusable widgets.
      models/: Defines data models for College, Program, and other related entities.
      providers/: State management providers (e.g., college provider, search provider).
      services/: API services and external data-fetching logic.
      utils/: Utility functions and constants.

8. **🔍 Usage**:
   Search for Colleges:
      On the home screen, enter keywords or use filters to search for colleges.
   View College Details:
      Tap on any college in the list to view its details.
   Save Favorites:
      Use the "favorite" icon to save a college for later reference.
   View Recommended Colleges:
      Get recommendations based on saved preferences and search history.

9. **🌐 API Usage**:
   CollegeFinder relies on third-party APIs to fetch college data. Ensure you have valid API keys, as noted in the installation section.

10.   **🛠️ Development & Contribution**
   Fork the repository.
      Create a new branch for your feature:
   bash
      git checkout -b feature-name
    Commit your changes and push to the branch:
   bash
      git commit -m "Add new feature"
      git push origin feature-name
      Open a pull request.
   
11. **👥 Contributors**: 
   Your Name - Sudarshan Mehta, Sonam Yegde, Anwitha Arbi
📜 License
   This project is licensed under the MIT License.