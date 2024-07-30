# Locations

## Description
Test project.

**Requirements:**
1. Small test app with a list of locations. The app should fetch the locations from https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json
2. Once opened, the app should show the list of locations in a list view
3. The app should be able to open locations in the modified Wikipedia app (also supporting custom locations)
4. Use UIKit for UI and layout
5. Modularization
6. Unit Tests for all the business logic
7. Offline mode (Persistent cache)
8. MVVM architecture design pattern

## High-Level Design
![123](https://github.com/user-attachments/assets/44efb054-3d8d-4c8e-be0b-60dc717d752c)

## Installation
To clone and set up this project, follow these steps:

```bash
git clone https://github.com/yurovmd/locations.git
cd locations
open Locations.xcodeproj
```
Ensure you have Xcode installed on your machine.

## Usage
Open the project in Xcode, and you can build and run it on an iOS simulator or a connected iOS device. The app should provide location-based functionalities, though specifics aren't detailed here.

## Project Structure
- `Locations.xcodeproj`: Xcode project file.
- `Locations`: Contains main app source code.
- `LocationsCore`: Core functionality and business logic.
- `LocationsCoreModels`: Models used in the core functionality.
- `LocationsCoreTests`: Tests for the core functionality.
- `LocationsList`: Handles location list features.
- `LocationsListTests`: Tests for the location list features.
- `LocationsUIComponents`: Reusable UI components.
- `.gitignore`: Git ignore file.
- `Locations.xctestplan`: Xcode test plan.

## Screenshots
| List Fetched | Error State | Custom Coordinate Entering |
|--------------|--------------|--------------|
| ![Screenshot 1](https://github.com/yurovmd/locations/assets/19597491/d6bafcb2-084b-496d-8919-ba6cebc0efb6) | ![Screenshot 2](https://github.com/yurovmd/locations/assets/19597491/3d94b157-ac4e-4c2b-a64b-592460505906) | ![Monosnap iPhone 15 Pro 2024-07-30 21-07-31](https://github.com/user-attachments/assets/fbec51fa-adce-4c1a-a9c9-0f4e52656350) |


## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
