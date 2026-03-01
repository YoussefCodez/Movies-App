# Movies App

### Architecture

lib
- core -> shared and const folders
- - theme       -> app theming (colors, fonts, styles)
- - constants   -> app-wide constants and shared values
- features -> all app features (auth, onboarding, home, search, movie details)
-  - auth -> auth feature (login, sign up)
-  - - - data         -> data source (API, local storage, models)
-  - - - domain       -> business logic (use cases, entities, repositories)
-  - - - presentation -> UI layer
-  -  -  - - screens  -> feature screens (pages)
-  -  -  - - widgets -> reusable widgets for screens
-  - - - - cubit    -> state management logic
 
