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

## Project Architecture and Structure

### MVVM Pattern
This project implements the Model-View-ViewModel (MVVM) architectural pattern. MVVM is chosen for its ability to:
- Organize code more effectively
- Separate concerns between UI and business logic
- Manage complex UI states more efficiently
- Improve testability of the codebase

### Domain-Driven Folder Structure
The project's folder structure is organized based on business domains. This approach offers several benefits:
- Easier application of modularization concepts
- Improved code navigation and maintenance
- Better scalability for large projects
- Clear separation of concerns between different features or modules

### Core Functionality
Reusable code and core functions are centralized in the `/core` directory. This organization:
- Promotes code reuse across the application
- Keeps common utilities and services in one place
- Simplifies maintenance of shared functionality

## Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── base/
│   │   └── base_view_model.dart
│   ├── di/
│   │   └── dependency_injection.dart
│   ├── provider/
│   │   ├── checkout_provider.dart
│   │   └── movie_provider.dart
│   ├── services/
│   │   ├── checkout_service.dart
│   │   └── movie_service.dart
│   ├── network/
│   │   └── network_client.dart
│   └── utils/
│       ├── validators.dart
│       ├── helpers.dart
│       ├── logger.dart
│       └── extension.dart
│
├── modules(features)/
│   └── movie/
│   │   ├── movie_list/
│   │   │   ├── page/
│   │   │   ├── state/
│   │   │   ├── view_model/
│   │   │   └── widget/
│   │   └── movie_detail/
│   │       ├── page/
│   │       ├── state/
│   │       ├── view_model/
│   │       └── widget/
│   ├── checkout/
│   │   ├── page/
│   │   ├── state/
│   │   ├── view_model/
│   │   └── widget/
│   └── payment/
│   └── order/
├── tests/
pubspec.yaml
```

## Project Dependencies

This project uses several key dependencies to enhance functionality and improve development efficiency:

### State Management
- **flutter_riverpod (^2.6.1)** and **riverpod_annotation (^2.6.1)**
  - Riverpod is a powerful state management library for Flutter.
  - It provides a robust and scalable way to manage app state, making it easier to share and update data across different parts of your application.

### UI Components
- **carousel_slider (5.0.0)**
  - A Flutter widget for creating image carousels.
  - It allows for easy implementation of scrollable image galleries or slideshows, enhancing the user interface and experience.

### Configuration Management
- **flutter_dotenv (^5.2.1)**
  - A package for loading environment variables from a .env file.
  - It allows storing sensitive information (like API keys) outside of the source code, improving security and making it easier to manage different configurations.

### Dependency Injection
- **get_it (^8.0.1)**
  - A simple service locator for dependency injection.
  - It simplifies the process of managing dependencies in the app, making it easier to create and access shared instances of objects throughout the codebase.

### Networking
- **dio (^5.7.0)**
  - A powerful HTTP client for Dart.
  - It provides an easy-to-use interface for making API calls, with features like interceptors, form data, request cancellation, and more.

### Data Serialization
- **json_annotation (^4.9.0)** and **json_serializable (^6.8.0)**
  - Libraries for JSON serialization and deserialization.
  - They simplify the process of converting Dart objects to JSON and vice versa, reducing boilerplate code and potential errors in data handling.

### Code Generation
- **freezed (^2.5.7)** and **freezed_annotation (^2.4.4)**
  - A code generation package for creating immutable classes.
  - It automates the creation of data classes, reducing boilerplate and ensuring consistency in data models.

### Logging
- **logger (^2.4.0)**
  - A flexible logging package for Dart.
  - It provides an easy way to add logging to the app, which is crucial for debugging and monitoring app behavior.

### Internationalization
- **intl (^0.19.0)**
  - A package for internationalization and localization.
  - It provides tools for translating app content, formatting dates, numbers, and plurals, making it easier to create apps for multiple languages and regions.

These dependencies work together to provide a robust foundation for the app, enabling efficient development, maintainable code, and a rich user experience.

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
