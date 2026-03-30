# Hostel Dayout Management System

A comprehensive Flutter-based solution designed to digitalize and streamline the hostel leave and day-out application process. This platform facilitates seamless communication and approval workflows between students, parents, and hostel administration.

[![Download APK](https://img.shields.io/badge/Download-APK-2ea44f?style=for-the-badge&logo=android)](YOUR_APK_DOWNLOAD_LINK_HERE)

---

## 🌟 Project Overview

This application aims to digitalize the traditional paper-based leave application process. It provides a structured flow for request submission and tracking, ensuring transparency and efficiency for all stakeholders.

### Use Case
Management of student leave/day-out applications. The application supports a multi-step approval workflow:
**Student** ➔ **Parent** ➔ **Assistant Warden** ➔ **Senior Warden**

### Role-Based Access Control (RBAC)
The app features four distinct roles with specific interfaces and permissions:
1.  **Student**: Initiates leave/day-out requests and tracks status.
2.  **Parent**: Reviews and provides the first level of approval/verification for their child's request.
3.  **Assistant Warden**: Reviews requests after parent verification.
4.  **Senior Warden**: Final authority for request approval and management.

---

## 📸 App Screenshots

<p align="center">
  <img src="assets/mockup/WhatsApp%20Image%202026-03-30%20at%201.41.04%20PM.jpeg" width="20%" alt="Dashboard" />
  <img src="assets/mockup/WhatsApp%20Image%202026-03-30%20at%201.41.04%20PM%20%281%29.jpeg" width="20%" alt="Request Form" />
  <img src="assets/mockup/WhatsApp%20Image%202026-03-30%20at%201.41.05%20PM.jpeg" width="20%" alt="Status Tracker" />
  <img src="assets/mockup/WhatsApp%20Image%202026-03-30%20at%201.41.05%20PM%20%281%29.jpeg" width="20%" alt="Approval Flow" />
</p>

---

## 🏗️ Architecture: MVVM (Model-View-ViewModel)

The project follows a clean **MVVM** architecture, further refined into a **Controller-State** pattern for scalability and testability.

### 🧩 Functional Programming with `Either`
I have integrated structural functional programming using the `dartz` package. This helped significantly in robust error handling:
-   **Failure Detection**: By returning `Either<Failure, Success>`, we avoid throwing exceptions for expected errors (like server timeouts or invalid credentials).
-   **Predictable Flow**: The UI can explicitly handle both success and error paths using `.fold()`, leading to a crash-free experience.

### 🛠️ Navigation & Routing
Routing is handled globally using the `go_router` package.
-   **Declarative Routes**: All routes are defined in a centralized `AppRouter` configuration.
-   **Deep Linking**: Support for nested routes and parameter passing.
-   **State-Driven Redirection**: Navigation flow can be controlled based on authentication status (LoginSession).

### 1. View (The Presentation)
-   Located in `lib/presentation/view/`, separated by roles (Student, Parent, Warden).
-   Responsible for the UI logic only.
-   Listens to the **State** objects to rebuild when data changes.

### 2. ViewModel (The Logic & State)
The ViewModel is separated into two components to isolate logic from state management:
-   **State**: Classes extending `ChangeNotifier` (typically found in `state/` folders). They hold observable data and call `notifyListeners()` to trigger UI updates.
-   **Controller**: Classes that contain the business logic (typically in `controllers/` folders). They orchestrate actions (API calls, navigation) and update the corresponding State objects.

### 3. Model (The Data)
-   Centralized in the `lib/models/` folder.
-   Contains plain data classes with `fromJson`, `toJson`, and `copyWith` methods.
-   Defines the structure of API responses for centralized mapping.

---

## ✨ UI/UX & Aesthetics

The application is built with a premium, modern design language to ensure an engaging user experience:

-   **Liquid Glass Renderer**: Advanced shader-based UI elements for a dynamic, fluid look.
-   **Glassmorphism**: Elegant translucent surfaces with background blurs for a futuristic feel.
-   **Google Fonts**: Integrated `Inter` and `Roboto` for crisp, professional typography.
-   **Shimmer Effects**: Smooth loading states for a polished feel during data fetching.
-   **Neumorphism & Inset Shadows**: Subtle depth using `flutter_inset_box_shadow` for custom UI controls.
-   **Smooth Transitions**: Integrated `smooth_page_indicator` and custom animations for screen transitions.

---

## 📂 Folder Structure

### 📁 `lib/core`
The backbone of the application, containing shared resources and configurations:
-   **config**: API base URLs and global constants.
-   **enums**: Fixed value sets used across the app (Role types, Request status, Actor types).
-   **helpers**: Specialized UI helpers like custom SnackBar managers.
-   **routes**: Declarative routing configuration using `GoRouter`.
-   **runtime_state**: Global singleton states like the current `LoginSession`.
-   **theme**: Centralized styling, colors, and typography (Light/Dark themes).
-   **utils**: General-purpose utility functions.

### 📁 `lib/login`
A self-contained feature folder for Authentication:
-   Contains its own View, Controller, State, and Model to keep auth logic isolated from the main dashboard.

### 📁 `lib/presentation`
The modular hub for UI components:
-   **view/**: Contains role-specific dashboards and pages (Student, Parent, Warden).
-   **components/**: Reusable UI components used across the app.
-   **widgets/**: Smaller, stateless atomic widgets.

### 📁 `lib/services`
The **Data Access Layer**:
-   Contains service classes (e.g., `AuthService`, `RequestService`) that interact with the Backend API.
-   Uses functional error handling (via the `dartz` package) to return results as `Either<String, T>`.

### 📁 `lib/models`
-   The centralized repository for all domain models used throughout the application.

---

## 🛠️ Tech Stack & Patterns

-   **State Management**: `Provider` (using `ChangeNotifier`).
-   **Dependency Injection**: `Get` (lightweight service locator).
-   **Routing**: `GoRouter` (Declarative navigation).
-   **Networking**: `http` with functional error handling (`dartz`).
-   **UI Enhancement**: Glassmorphism, Liquid Glass, Shimmer, Smooth Page Indicators.

---

## 🚀 Getting Started

1.  **Initialize Dependencies**: Run `flutter pub get`.
2.  **Run Application**: Use `flutter run` on your preferred device.
