# Nägel
> A cross-platform mobile application designed to assist users in understanding and managing nail-related health conditions, offering distinct experiences for patients and medical professionals. Patients can upload images for analysis, explore disease information, and connect with doctors, while doctors can manage their profiles, availability, and review licensing information.

![GitHub stars](https://img.shields.io/github/stars/Mo277210/final_year_project?style=social)

## ✨ Key Features
*   **Patient & Doctor Portals:** Separate user flows and interfaces tailored for patients and medical doctors.
*   **Nail Image Upload:** Patients can upload images of their nails, presumably for analysis or consultation, providing a visual aid for diagnosis.
*   **Disease Information Hub:** Comprehensive details on various nail diseases (e.g., Onycholysis, Nail Psoriasis, Brittle Splitting Nails), including causes, symptoms, and treatment options.
*   **Doctor Search & Directory:** Patients can search for doctors, filter by specialty, view their profiles, ratings, contact information, clinic locations, and available hours.
*   **Personalized History:** Patients can review a history of their past image uploads and associated diagnostic information.
*   **Doctor Profile Management:** Doctors can manage their personal profiles, including updating their professional image, contact details, clinic addresses (main and branch), and specifying their available hours.
*   **Account Settings:** Both patient and doctor users can update their personal information, such as name, email, phone number, and password.
*   **Medical License Upload:** During doctor registration, a dedicated screen allows for the upload of medical licensing images, indicating a verification process.

## 🛠️ Tech Stack
*   **Flutter:** Cross-platform UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
*   **file_picker:** A Flutter plugin for picking files from the device storage.
*   **flutter_rating_bar:** A Flutter widget to display and collect star ratings.
*   **url_launcher:** A Flutter plugin for launching URLs.
*   **intl:** A Flutter package for internationalization and localization, used for date formatting.

## 🚀 Installation
To get started with this project, ensure you have Flutter installed and set up on your development machine.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Mo277210/final_year_project.git
    cd final_year_project
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the application:**
    ```bash
    flutter run
    ```

## Usage
The application features two main user roles: Patients and Doctors.

*   **For Patients:**
    *   Register or log in as a Patient.
    *   Navigate through the tabs to upload nail images, explore disease information, view your history, search for doctors, and manage your settings.
*   **For Doctors:**
    *   Register or log in as a Doctor, which includes an additional step to upload your medical license.
    *   Access your profile to manage clinic information, available hours, and contact details.
    *   Use the settings page to update your account information.

## 🔧 How It Works
The application is built using Flutter, providing a unified codebase for different platforms. The core functionality revolves around two distinct user experiences:

1.  **Authentication and User Roles:** The application begins with a `SplashScreen` that transitions to a login screen (`LoginScreenPatient`). Users can choose to log in or sign up as either a `Patient` or a `Doctor`. Doctor signup (`SignUpScreenDoctor`) includes an additional step (`LicenseUploadScreen`) for uploading a medical license, indicating a potential backend verification process.

2.  **Patient Workflow (`Homepagepatient`):**
    *   Upon logging in, patients are directed to a tab-based navigation (`Homepagepatient`) which includes:
        *   **Image Upload (`Nagelimage`):** Allows users to pick and upload nail images from their device, using `file_picker`. While the analysis logic isn't present, the UI for submission is.
        *   **History (`Historypage`):** Displays a list of previously recorded nail conditions (e.g., Onycholysis, Nail Psoriasis) with associated data and dates, suggesting a historical record of observations.
        *   **Doctor Search (`DoctorSearchPage`):** Provides a comprehensive interface for finding medical professionals. Patients can search by name, filter by medical specialty using choice chips, and view detailed doctor cards that include ratings (using `flutter_rating_bar`), contact info, and clinic details with clickable links (using `url_launcher`).
        *   **Disease Information (`InformationNail` & `ExploreDisease`):** Patients can browse through various nail diseases, viewing images and detailed textual information covering causes, symptoms, and treatments. Navigation allows users to cycle through diseases or dive into a detailed `ExploreDisease` view for the currently selected condition.
        *   **Settings (`SettingPatientPage`):** Enables patients to modify their personal details like name, email, phone number, and password through expandable sections.

3.  **Doctor Workflow (`HomepageDoctor`):**
    *   Doctors log in to a simplified tab-based navigation (`HomepageDoctor`) focusing on their professional presence:
        *   **Doctor Profile (`DoctorProfilePage`):** This is the primary interface for doctors to manage their public-facing information. They can upload a profile picture, display their specialization and rating, and manage contact details, clinic locations (main and branch), and available hours. The `_chooseImage`, `_showAddHourBottomSheet`, and `_editClinicBottomSheet` functions allow for dynamic updates to this information.
        *   **Settings (`SettingsPage`):** Similar to the patient settings, doctors can update their name, email, phone number, and password, including validation for new password strength.

The application's navigation primarily uses Flutter's `Navigator` for screen transitions and `DefaultTabController` for tab management, ensuring a consistent user experience across different sections for each user type.
