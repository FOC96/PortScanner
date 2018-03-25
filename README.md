<img src="https://bp9rag.dm.files.1drv.com/y4mesAKWKo5t6LAnLk-REkCnmGReOgc1nzmR65qz39n4n6ApKWLq9kENn9Us3VQmQqtclTc_Hz7Eu8fVQ5f9BJeI9F-ezcKRAdGZ2fhVNJmMm4qfsNGY9x9S6x-u1SMQngGDHme5qZAYNDYcb5cf6WhYKA0KvxmY2tDHxL-Dg8of-Mc61jbQiLRs9sY8pOmyk7FBJuRI72js_BoIdFTkibuDQ?width=1300&height=100&cropmode=none" width="100%"/>

# PortScanner
PortScanner is our midterm project for our Distributed Systems course at Universidad Autónoma de Querétaro. This project is an iOS app which main goal is to scan a given range of ports from a given host and retrieve those who are available. Then, the user can open a terminal for 3 ports: 22, 80 and 3306.

## Getting Started

### Built With
* Swift 4
* Xcode 9
* CocoaPods

### Libraries (Pods)
* **[SwiftSocket](https://github.com/swiftsocket/SwiftSocket)** – Socket management and HTTP connection (port 80)
* **[SwiftSH](https://github.com/Frugghi/SwiftSH)** – SSH connection (Port 22)
* **[OHMyUSQL](https://github.com/oleghnidets/OHMySQL)** – Database connection (Port 3306)

## User Manual

### Scanning ports
1. Enter a host and a range of ports to scan.
2. Tap blue button.
3. All available ports will be displayed in the TableView.
4. Only 3 ports are available to interact with (22, 80 and 3306). When tapped over them, a new View will show.

### SSH (Port 22)
1. To create a connection, the user and password are needed.
2. We tested this port with macOS, using the command 'say' before a statement (e.g. say Hello there)
3. To close the connection just swipe back to the TableView.

Note: there's no feedback from the host yet, so one-way commands are the only accepted commands.


### HTTP (80)
1. Once the view is displayed, you can type 'GET / HTTP/1.0' + two line breaks and press 'Enviar' to retrieve the html file.
2. The connection is closed once you swipe right to go back to the TableView.


### Database (3306)
1. A user, password and database is needed to start a connection.
2. Queries can be ran by typing the sentence and pressing 'Enviar'.
3. Results are displayed as a JSON.
4. Session is closed once the user goes back the the TableView.

Note: Setting up access permission from the database is needed to use this service.

## Authors
* Fernando Ortiz Rico Celio
* [Marco Antonio Galicia Toriz](https://github.com/galtordev)

## Acknowledgements
* [swiftsocket](https://github.com/swiftsocket) (SwiftSockets author)
* [Tommaso Madonia](https://github.com/Frugghi) (SwiftSH author)
* [Oleg](https://github.com/oleghnidets) (OHMySQL author)
