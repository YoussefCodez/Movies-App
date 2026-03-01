# Movies App

### Architecture

lib
├── core        # shared and const folders
│   ├── theme
│   └── constants
├── features    # all app features (auth, onboarding, home, search, movie details)
│   └── auth    # auth feature (login, sign up)
│       ├── data         # data source
│       ├── domain       # business logic
│       └── presentation # UI
│           ├── screens  # feature screens
│           │   └── widgets # screen widgets
│           └── cubit    # logic
