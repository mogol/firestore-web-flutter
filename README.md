# Firestore Offline Persistence

Firestore rules:

```
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /test-collection/{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

Steps:

* Launch the web app
* Click `+` -> The value is increased.
* Delete site data in Chrome: Settings -> Privacy & Security -> See all site data and permissions -> Delete `localhost`
* As expected an error with Permissions is shown.
* Refresh the tab
* It shows that the doc doesn't exit. Expected: it should display the latest value. 
* Click `+` -> The value is increased and updated.

If persistence is off, it works as expected: it shows the latest value after tab refresh.

```
FirebaseFirestore.instance.settings =
       const Settings(persistenceEnabled: false);
```