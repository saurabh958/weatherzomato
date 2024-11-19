# WeatherZomato 🌤️

A Flutter-based weather app that utilizes the **WeatherUnion API** to provide real-time weather updates for your location. With an intuitive design and precise geolocation features, this app ensures you stay updated on current weather conditions wherever you go.

---

## Features 🚀

- **Real-Time Weather Updates**: Get accurate weather data based on your current location.
- **Geolocation**: Automatically fetches weather details using GPS.
- **Responsive Design**: Optimized for all screen sizes.
- **Offline Mode**: Basic functionality when the network is unavailable.

---

## Screenshots 📸

![weatherdata](https://github.com/user-attachments/assets/548aab27-a237-4dd4-9c77-95e852669c6f)
![Screenshot_20241119_135450](https://github.com/user-attachments/assets/dc4b22a9-8e45-4518-8a37-333eb638f046)


---

## Tech Stack 🛠️

- **Flutter**: For creating a responsive and performant mobile UI.
- **WeatherUnion API**: For fetching live weather data.
- **Geolocator & Geocoding**: For accurate user location detection.
- **Provider**: For state management.
- **HTTP**: For API requests.

---

## Installation & Setup 💻

### Prerequisites
- Flutter SDK installed ([Get started with Flutter](https://flutter.dev/docs/get-started))
- An API key from **WeatherUnion API**

### Steps to Run
1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/weatherzomato.git

bash```

2. Navigate to the project directory:
    ```bash
    cd weatherzomato

3. Install dependencies:
    ```bash
    flutter pub get

4. Add your WeatherUnion API Key in the project:
- Locate the API key placeholder in the code (e.g., lib/services/api_service.dart) and replace it with your key:
    ```dart
    const String weatherUnionApiKey = 'YOUR_API_KEY';

5. Run the project:
    ```bash
    flutter run


## Dependencies 📦

This project uses the following dependencies:

- **permission_handler**: Handles runtime permissions.
  ```yaml
  permission_handler: ^11.3.1
  ```
- **geolocator**: Provides access to the device's location services.
  ```yaml
  geolocator: ^13.0.1
  ```
- **geocoding**: Converts geographic coordinates into readable addresses.
  ```yaml
  geocoding: ^3.0.0
  ```
- **http**: For making HTTP requests to APIs.
  ```yaml
  http: ^1.2.2
  ```
- **intl**: Facilitates date and time formatting.
  ```yaml
  intl: ^0.19.0
  ```
- **provider**: Manages state efficiently.
  ```yaml
  provider: ^6.1.2
  ```

---

## Assets 🎨

Ensure the following assets are included in the project:

- `assets/` - General assets folder.
- `assets/images/` - Contains app images and icons.

---

## Contributing 🤝

Contributions are welcome! Follow these steps to contribute:

1. Fork the project.
2. Create a new branch:
   ```bash
   git checkout -b feature/your-feature
   ```
3. Make changes and commit:
   ```bash
   git commit -m "Add your feature"
   ```
4. Push to your branch:
   ```bash
   git push origin feature/your-feature
   ```
5. Open a pull request.

---

## License 📄

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

---

## Acknowledgements 🙌

- **WeatherUnion API** for weather data.
- Flutter community for the amazing resources.





