# Certs

A free certificate / document emailing solution.

A working web deployment of this is available at [certs.zac.ac](certs.zac.ac)

## Getting Started

1. Clone the repository
2. Run `flutter create .` to generate the Flutter project. 
3. Create new credentials for this application to access the Gmail API (refer [this google support link](https://support.google.com/googleapi/answer/6158849?hl=en))
4. Get the OAuth client ID from step #3, and set it in the .env.template file, then rename ".env.template" to ".env"

That's it. You should now be able to run the application. Try `flutter run -d chrome` to run the web version in debug mode. You may need to add https://localhost to your list of javascript authorized domains

## Common problems

##### idpiframe_initialization_failed
Refer [this stackoverflow answer](https://stackoverflow.com/a/53899196/6841962)