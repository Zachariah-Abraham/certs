# Certs

A free certificate / document emailing solution.

A working web deployment of this is available at [certs.zac.ac](https://certs.zac.ac)

## Demo

A video demo of the application can be found [here](https://www.linkedin.com/posts/zaca_softwareengineering-innovation-technology-activity-6823358703325073408-97QL?utm_source=linkedin_share&utm_medium=member_desktop_web)

## Getting Started

1. Clone the repository
2. Run `flutter create .` to generate the Flutter project. 
3. Create new credentials for this application to access the Gmail API (refer [this google support link](https://support.google.com/googleapi/answer/6158849?hl=en))
4. Get the OAuth client ID from step #3, and set it in the .env.template file, then rename ".env.template" to ".env"

That's it. You should now be able to run the application. Try `flutter run -d chrome` to run the web version in debug mode.

## Common problems

##### idpiframe_initialization_failed
Refer [this stackoverflow answer](https://stackoverflow.com/a/53899196/6841962)