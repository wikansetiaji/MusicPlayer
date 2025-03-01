# MusicPlayer App

MusicPlayer is an iOS application that allows users to stream music from the [Jamendo API](https://www.jamendo.com). The project follows the MVVM (Model-View-ViewModel) architecture and is built using the latest iOS technologies, including SwiftUI and Reactive Combine.

## Features

- Stream music from Jamendo API
- Modern MVVM architecture
- Built with SwiftUI and Combine for a reactive user experience

## Technologies Used

- **SwiftUI**: Declarative UI framework for iOS development
- **Combine**: Reactive programming framework by Apple
- **MVVM**: Architectural pattern for separation of concerns
- **GitHub Actions**: Continuous Integration and Continuous Deployment (CI/CD)

## CI/CD Workflow

This project uses GitHub Actions for CI/CD automation with two workflows:

1. **Unit Test Workflow**: Runs on every commit pushed to the `main` branch. Ensures code integrity by executing unit tests automatically.
2. **Build Workflow**: Triggered by a build tag. Responsible for generating a new build of the app. This workflow will create a `.app` artifact, which can be downloaded from GitHub Actions.

## Build Automation

A `build.sh` script is included in the repository to automate the build versioning process. The script:

- Asks for the new build number and version
- Updates the project's build number and version automatically
- Commits the changes
- Pushes a new build tag to the repository, triggering the Build workflow

### Running the Build Script

For the first time, you need to make the script executable:

```sh
chmod +x build.sh
```

Then, run the script to trigger the `.app` build:

```sh
./build.sh
```

## License

This project is open-source and available under the MIT license.

