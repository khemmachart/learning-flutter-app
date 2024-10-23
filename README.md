# Learning Flutter App

This is a Flutter application for learning purposes, featuring movie details and booking functionality.

## Prerequisites

Before you begin, ensure you have met the following requirements:

* You have installed the latest version of [Flutter](https://flutter.dev/docs/get-started/install)
* You have a Windows/Linux/Mac machine with [Git](https://git-scm.com/downloads) installed
* You have your preferred IDE installed (e.g., [Android Studio](https://developer.android.com/studio), or [Visual Studio Code](https://code.visualstudio.com/), or [Cursor AI Text Editor](https://www.cursor.com)),

## Setting up the project

To set up the project, follow these steps:

1. Clone the repository:
   ```
   git clone https://github.com/khemmachart/learning_flutter_app.git
   ```

2. Navigate to the project directory:
   ```
   cd learning_flutter_app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

## Setting up the environment variables

This project uses environment variables to manage sensitive information like API keys. Follow these steps to set up your environment:

1. In the root directory of the project, create a file named `.env`

2. Add the following variables to the `.env` file:

   ```
   API_BASE_URL=https://api.themoviedb.org/3
   API_KEY=your_tmdb_api_key_here
   ```

3. Replace `your_tmdb_api_key_here` and `your_tmdb_read_access_token_here` with the actual values.

**Note:** The `.env` file contains sensitive information and should not be committed to version control. Make sure it's listed in your `.gitignore` file.

### Obtaining API Keys

To obtain the necessary API keys:

1. Sign up for an account at [The Movie Database (TMDb)](https://www.themoviedb.org/)
2. Once logged in, go to your account settings and navigate to the API section
3. Request an API key for developer use
4. Once approved, you'll receive your API key and read access token

If you're having trouble obtaining the API keys or need the correct values for this project, please contact the project maintainer:

**Contact:** John Doe
**Email:** john.doe@example.com
**Subject Line:** Learning Flutter App - API Key Request

Please include your GitHub username and the reason for your request in the email.

## Running the app

To run the app, use the following command:
```
flutter run
```

This will launch the app on your connected device or emulator.

## Testing the app

To run the tests for this app, use the following command:
```
flutter test
```
This will run all the unit and widget tests in the project.

## Building the app

To build a release version of the app, use:
```
flutter build apk # For Android
flutter build ios # For iOS (on macOS only)
```

## Contributing to the project

To contribute to the project, follow these steps:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature-name`)
6. Create a new Pull Request

## Contact

If you want to contact the maintainer of this project, please email [nueve.sr@gmail.com].

## License

This project uses the following license: [MIT License](https://opensource.org/licenses/MIT).
