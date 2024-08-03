# Food Reservation App
## Overview
The Tavanir Food Reservation App is designed to streamline meal reservations for staff within the company. Built with a Django backend and a Flutter frontend, this application allows users to manage meal reservations efficiently with different privilege levels, including Shift Managers, Supervisors, and Common Users.

## Features
* **shiftmanager**
    - Assigns a supervisor for a specified period.
* **supervisor**
  - Sets daily meal options.
  - Creates and manages lunch and dinner menus.
  - Views meal reservations made by users for specific days.
* **common user**
  - Reserves one lunch and one dinner from the available menu for themselves.
 
## Technologies
* **backend**: django
* **frotend**: flutter
* **Database**: sqlite for dev environment and postgresql for production mode
* **Version Control**: GitHub

## installation
### **Prerequisites**
* Python 3.x
* Django 4.x
* Flutter SDK

### backend setup
```
git clone
cd backend
```
`then install the requirements`
```
python -m pip install -r requirements.txt
```
`and finally run the backend`
```
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

### frontend setup
`note`: at first you must be in the backend folder
```
cd ../frontend
flutter pub get
flutter run
```
## Usage 
1. **For Shift Managers:**
   * Log in and use the Shift Manager dashboard to assign a supervisor.
2. **For Supervisors:**
   * Log in to create daily menus and manage meal options.
   * Review user reservations for lunch and dinner.
3. **For Common Users:**
   * Log in and reserve your meals from the available menu options.

## Contributing
We welcome contributions! Please fork the repository and submit a pull request with your changes. Be sure to follow the code style and include tests where applicable.




