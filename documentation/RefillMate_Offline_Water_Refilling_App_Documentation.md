
# RefillMate (Offline Water Refilling Request App)

## Overview

**RefillMate** is a simple offline mobile application designed for users to request water gallon pickups for refilling. The app is built using Flutter with GetX for state management and SQLite for local data persistence. This offline version focuses on core features and a presentable UI/UX, with provisions for an easy transition to an online version in the future.

---

## Core Features

- **User Registration**  
  - Users can create a new account with basic details.
- **User Login**  
  - Users can log in securely (offline) to access the app.
- **Profile Management**  
  - Users can view and update their profile information (name, email, password, and optionally profile photo).
- **Water Refill Request (Full CRUD)**  
  - **Create**: Users can make a new water refill request by selecting gallon types, quantities, etc.
  - **Read/View**: Users can view a list of their previous refill requests, including details and status.
  - **Update/Edit**: Users can update pending requests (e.g., change quantity, update selected gallons) before they are marked as completed or picked up.
  - **Delete**: Users can delete their requests (only if not yet completed).
- **Animations and Responsive UI**  
  - Key actions such as adding/editing/deleting requests have animated feedback.

---

## Packages Used

- [`get`](https://pub.dev/packages/get)  
  - State management, route handling, and dependency injection.
- [`flutter_animate`](https://pub.dev/packages/flutter_animate)  
  - Smooth animations for transitions and user feedback.
- [`heroicons`](https://pub.dev/packages/heroicons)  
  - Beautiful icons for UI clarity and modern look.
- [`flutter_staggered_grid_view`](https://pub.dev/packages/flutter_staggered_grid_view)  
  - Dynamic grid layout for displaying gallon types attractively.
- [`sqflite`](https://pub.dev/packages/sqflite)  
  - SQLite local database for offline data storage.

---

## App Structure

```
lib/
├── controllers/
│   ├── auth_controller.dart
│   ├── request_controller.dart
├── models/
│   ├── user_model.dart
│   ├── gallon_model.dart
│   ├── request_model.dart
├── views/
│   ├── login_screen.dart
│   ├── registration_screen.dart
│   ├── home_screen.dart
│   ├── create_request_screen.dart
│   ├── my_requests_screen.dart
│   ├── profile_screen.dart
├── widgets/
│   ├── gallon_card.dart
│   ├── animated_button.dart
├── database/
│   ├── db_helper.dart
├── middleware/
│   ├── auth_middleware.dart
├── main.dart
```

---

## Key Screens

### 1. **Login Screen**
- Email/username and password fields
- Simple animation on login button (e.g., loading indicator)
- Uses GetX for authentication flow

### 2. **Registration Screen**
- Fields: Name, Email, Password
- Animated transitions for user engagement

### 3. **Home Screen**
- Welcome message
- Quick access to create new request or view requests
- Heroicons for navigation

### 4. **Profile Screen**
- Displays user's current information (name, email, etc.)
- Allows editing/updating profile details (with animation for feedback)
- Optionally supports profile photo

### 5. **Create Request Screen**
- Staggered grid view of available gallons (image, price, short description)
- Select quantity per item
- Add to request (cart-style)
- Animated “Add” button for better UX

### 6. **My Requests Screen**
- List of user’s past requests (offline data)
- Status indicator for each request (e.g., Pending, Completed)
- **Edit** and **Delete** buttons for each pending request (Edit opens the form pre-filled; Delete shows a confirmation dialog with animation)

---

## Database Schema (SQLite)

**Tables:**

- **users**
  - id, name, email, password (hashed), profile_photo_path
- **gallons**
  - id, name, price, image_path, description
- **requests**
  - id, user_id, datetime, status
- **request_items**
  - id, request_id, gallon_id, quantity

---

## Animation Usage

- **Page transitions**: Use `flutter_animate` for smooth screen changes.
- **Button taps and list loading**: Apply fade or scale effects for feedback.
- **Grid items**: Gallon items animate in (staggered or fade-in).

---

## Authentication Logic (Offline)

- Registration and login are stored locally.
- Simple GetX middleware protects access to main app screens if not authenticated.
- No remote server required.

---

## UI/UX Notes

- Clean, modern UI using Heroicons.
- Responsive design, works on any device size.
- Animations enhance usability but are lightweight to avoid slowdowns.
- Dynamic staggered grid for gallon selection—no fixed item heights.

---

## How to Run

1. Clone the repository.
2. Run `flutter pub get`.
3. Launch on any Android/iOS emulator or device.
4. App will auto-populate sample gallon types on first run (local only).

---

## Migration to Online

- Replace SQLite calls with API calls (future online upgrade).
- Retain GetX structure for easy migration.
- Ready for backend integration when available.

---

## Screenshots / Demo

*(Screenshots and GIFs to be added upon app completion)*

---

## Contact

**Developer:** Brian Orbino  
**Submission for:** RefillMate (Offline Water Refilling Request App), [Course/Subject Name]

---
