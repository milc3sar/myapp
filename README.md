# Supervisor App - BLoC Architecture Implementation

## Overview

This project implements the BLoC (Business Logic Component) architecture for the Supervisor App, a Flutter application designed for technical supervisors of electrical works. The app facilitates the structured and automatic generation of reports in PDF format, following the official format of the Loss and Connection Management (GPC) area.

## Architecture

The application follows the BLoC architecture pattern, which separates the business logic from the UI, making the code more maintainable, testable, and scalable. The architecture is organized into the following layers:

### 1. Presentation Layer

- **Screens**: UI components that display data to the user and handle user interactions
- **Widgets**: Reusable UI components
- **BLoCs**: Business Logic Components that manage the state of the application

### 2. Domain Layer

- **Entities**: Business objects that represent the core data structures
- **Repositories (Interfaces)**: Abstract classes that define the contract for data operations

### 3. Data Layer

- **Models**: Data classes that implement the entities and add persistence-specific annotations
- **Repositories (Implementations)**: Concrete implementations of the repository interfaces
- **Data Sources**: Classes that handle the actual data storage and retrieval

## Folder Structure

```
lib/
├── blocs/                  # BLoC components for state management
│   ├── report/             # BLoCs related to reports
│   ├── supply/             # BLoCs related to supplies
│   └── pdf/                # BLoCs related to PDF generation
│
├── data/                   # Data layer
│   ├── models/             # Data models
│   ├── repositories/       # Repository implementations
│   └── datasources/        # Data sources (local storage)
│
├── domain/                 # Domain layer
│   ├── entities/           # Domain entities
│   └── repositories/       # Repository interfaces
│
├── presentation/           # Presentation layer
│   ├── screens/            # Main screens
│   ├── widgets/            # Reusable widgets
│   └── themes/             # App themes
│
├── core/                   # Core functionality
│   ├── utils/              # Utility functions
│   ├── constants/          # App constants
│   └── services/           # Services (PDF, camera, speech-to-text)
│
└── main.dart               # App entry point
```

## BLoC Implementation

The BLoC pattern is implemented using the `flutter_bloc` package. Each feature has its own BLoC with the following components:

### Events

Events are dispatched to the BLoC to trigger state changes. They represent user actions or system events.

### States

States represent the current state of the application. The UI rebuilds when the state changes.

### BLoC

The BLoC receives events, processes them, and emits new states. It contains the business logic of the application.

## Data Persistence

The app uses Hive for local data storage, with the following boxes:

- `reports_box`: Stores report data
- `supplies_box`: Stores supply data
- `evidences_box`: Stores evidence data
- `settings_box`: Stores app settings

## Models and Entities

### Entities (Domain Layer)

- `ReportEntity`: Represents a report with supervisor name, date, subject, activities, supplies, conclusions, and recommendations
- `SupplyEntity`: Represents a supply with a code and a list of evidences
- `EvidenceEntity`: Represents an evidence with an image, voice recording, observation, and location

### Models (Data Layer)

- `Report`: Implements `ReportEntity` with Hive annotations for persistence
- `Supply`: Implements `SupplyEntity` with Hive annotations for persistence
- `Evidence`: Implements `EvidenceEntity` with Hive annotations for persistence

## Repositories

### Repository Interfaces (Domain Layer)

- `ReportRepository`: Defines operations for reports
- `SupplyRepository`: Defines operations for supplies

### Repository Implementations (Data Layer)

- `ReportRepositoryImpl`: Implements `ReportRepository` using Hive for storage
- `SupplyRepositoryImpl`: Implements `SupplyRepository` using Hive for storage

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter pub run build_runner build` to generate the necessary code
4. Run the app with `flutter run`

## Dependencies

- `flutter_bloc`: For implementing the BLoC pattern
- `equatable`: For value equality comparisons
- `hive` and `hive_flutter`: For local storage
- `freezed` and `json_serializable`: For code generation
- `uuid`: For generating unique IDs
- `pdf`: For PDF generation
- `share_plus`: For sharing files
- `speech_to_text`: For voice-to-text conversion
- `geolocator` and `flutter_map`: For location services
- `image_picker`: For capturing images
- `permission_handler`: For handling permissions
- `formz`: For form validation

## Future Improvements

- Implement the PDF generation service
- Add more screens for detailed report viewing and editing
- Implement the speech-to-text functionality
- Add location mapping for evidences
- Implement user authentication and cloud synchronization