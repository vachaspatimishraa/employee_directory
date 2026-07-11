# Employee Directory

A modern Flutter application built as part of a Flutter interview assignment. The app displays employees fetched from a REST API, supports offline caching, favorites, dark mode, and follows a clean **MVVM + Repository** architecture using **Riverpod**.

---

## 📸 Preview

| Login | Home | Employee Details |
|--------|------|------------------|
| *(Add Screenshot)* | *(Add Screenshot)* | *(Add Screenshot)* |

---

# ✨ Features

## Required Features

- 🔐 Login Screen (UI Only)
- 📧 Email Validation
- 🔑 Password Validation
- 💾 Login Session Persistence using SharedPreferences
- 🚀 Auto Login
- 👨‍💼 Employee List
- 👤 Employee Detail Screen
- 🔍 Search Employees
- 🔄 Pull-to-Refresh
- ⏳ Loading Indicator
- ⚠️ Error Handling
- 📱 Responsive Material 3 UI

---

## Bonus Features

- 🌙 Dark Mode
- ❤️ Favorite Employees
- 📦 Offline Caching (Isar)
- 📄 Client-side Pagination
- 🧪 Unit Tests

---

# 🏗️ Architecture

The application follows **MVVM (Model–View–ViewModel)** with the **Repository Pattern**.

```text
                 UI (Screens)
                       │
                       ▼
            Riverpod ViewModels
                       │
                       ▼
                Repository Layer
                 ┌────────────┐
                 │            │
                 ▼            ▼
          Remote API      Local Database
             (Dio)            (Isar)
```

### Why This Architecture?

- Separation of Concerns
- Scalable Project Structure
- Easy to Test
- Easy to Maintain
- Reusable Business Logic

---

# 📂 Folder Structure

```text
lib
│
├── app
│
├── core
│   ├── constants
│   ├── database
│   ├── network
│   ├── services
│   ├── utils
│   └── widgets
│
├── features
│   ├── auth
│   ├── employee
│   └── settings
│
├── routes
│
├── generated
│
└── main.dart
```

---

# 🛠️ Tech Stack

| Technology | Usage |
|------------|-------|
| Flutter | UI Development |
| Dart | Programming Language |
| Riverpod | State Management |
| Dio | REST API Client |
| Isar | Offline Database |
| SharedPreferences | Local Storage |
| GoRouter | Navigation |
| Material 3 | UI Design |
| Connectivity Plus | Network Monitoring |

---

# 📦 Packages Used

| Package | Purpose |
|---------|---------|
| flutter_riverpod | State Management |
| dio | HTTP Client |
| go_router | Navigation |
| isar | Local Database |
| isar_flutter_libs | Native Isar Support |
| shared_preferences | Login Persistence |
| connectivity_plus | Connectivity Monitoring |
| path_provider | Database Path |
| path | File System Utilities |
| flutter_svg | SVG Support |
| intl | Formatting |
| url_launcher | Launch Website & Maps |
| shimmer | Loading Animation |
| equatable | Value Equality |
| build_runner | Code Generation |
| isar_generator | Isar Model Generation |
| mocktail | Unit Testing |

---

# 🌐 API

The application fetches employee data from:

```
https://jsonplaceholder.typicode.com/users
```

---

# 📱 Screens

## Login

- Email Validation
- Password Validation
- Login Button
- Password Visibility Toggle
- Session Persistence

---

## Home

- Employee List
- Search
- Pull-to-Refresh
- Loading State
- Error State
- Empty State
- Offline Banner
- Favorites
- Pagination

---

## Employee Details

Displays:

- Avatar
- Name
- Username
- Email
- Phone
- Website
- Company
- Address
- Google Maps
- Favorite Button

---

# 📦 Offline Caching

Employee data is automatically cached using **Isar**.

### Online

```text
API
   │
   ▼
Save into Isar
   │
   ▼
Display Latest Data
```

### Offline

```text
Read from Isar
      │
      ▼
Display Cached Employees
```

A banner is displayed when cached data is being shown.

---

# ❤️ Favorites

Users can

- Mark Employees as Favorite
- Remove Favorites
- Persist Favorites Locally
- Filter Favorite Employees

---

# 🌙 Dark Mode

Supports

- Light Theme
- Dark Theme
- System Theme

Theme preference is saved locally.

---

# 📄 Pagination

The JSONPlaceholder API contains only 10 employees.

Client-side pagination is implemented by loading employees in batches.

---

# ⚙️ Setup Instructions

## Prerequisites

- Flutter SDK **3.35.x**
- Dart SDK **3.9.x**
- Android Studio / VS Code
- Git

Verify Flutter installation:

```bash
flutter doctor
```

---

## Installation

Clone the repository

```bash
git clone https://github.com/yourusername/employee-directory.git
```

Navigate to the project

```bash
cd employee-directory
```

Install dependencies

```bash
flutter pub get
```

Generate Isar files

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application

```bash
flutter run
```

---

# 🧪 Running Tests

Run all tests

```bash
flutter test
```

---

# 📦 Build APK

Debug APK

```bash
flutter build apk
```

Release APK

```bash
flutter build apk --release
```

Generated APK

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

# 📌 Flutter Version

| Tool | Version |
|------|---------|
| Flutter | 3.35.x |
| Dart | 3.9.x |

> Replace these with the exact versions from `flutter --version` before submitting.

---

# 📋 Assumptions

- Authentication is UI-only; no backend authentication is implemented.
- Employee data is fetched from the public JSONPlaceholder API.
- Pagination is implemented on the client side because the API returns only 10 records.
- Favorites are stored locally on the device.
- Cached employee data is shown when the device is offline.
- Google Maps functionality depends on the availability of latitude and longitude from the API.
- Theme preference and login session persist across app restarts.

---

# 🚀 Future Improvements

- Backend Authentication
- Infinite Scrolling API
- Employee Editing
- Profile Images
- Sorting Employees
- Multi-language Support
- Integration Tests
- CI/CD Pipeline
- Push Notifications

---

# 📖 Design Principles

- MVVM Architecture
- Repository Pattern
- Single Responsibility Principle
- Clean Code Practices
- Reusable Widgets
- Responsive Design
- Material 3 Guidelines

---

# 👨‍💻 Developer

**Vachaspati Mishra**

Flutter Developer

---

# 📄 License

This project was developed for a Flutter interview assessment and is intended for demonstration and evaluation purposes.