## What parts of mobile are integrated with the backend

### User authentication (Settings -> User Information)
POST `/auth/register`
- Registering users is functional

POST `/auth/login`
- Logins are functional

GET `/api/v1/users/me`
- Refresh user info data when opening the app.

The auth access token is stored on the device and preserved until the user logs out.

### Map
GET `/api/v1/segments`
- Fetches segments and displays then on the map.
- Display review information by clicking on segments.

GET `/api/v1/snow-types`
- Fetches snow types and connects those to review form / displaying review information.

POST `/api/v1/segments/{id}/reviews`
- Sends an user review using the area card form. Click on segments on the map to submit a review. Requires logging in.

### Which parts are not fully functional
- Guide updates are not implemented
- There is no admin/rescue/guide dashboard view for mobile
- Weather view uses mock data
- Rescue view is in a mock state and not integrated to backend

### Other features not dependent on backend
- Localization (Settings -> Language)
- Snow definitions (Settings -> Snow definitions, static page)
- Map content filtering and location switching (bottom buttons on map)

### Known unresolved issues
- Can't click on inner segments (ones for which isLowerSegment field is not null) that are inside another
