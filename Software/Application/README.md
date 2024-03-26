# AM2R-Safe2Wheels

This application serves the purpose of supporting cyclists by providing them useful information such as the best routes, air quality and warnings about any obstructions or danger in the bycicle path.

## Repository Contents

This repository contains the following main files and directories:

- `lib/`: This directory holds all the application files.
- `assets/`: This directory holds application assets, such as fonts, images, etc.
- `core/`: This directory holds application's core files such as navigation, data models and repositories, etc.
- `core/components`: This directory holds application's generic components/widgets.
- `core/data`: This directory holds data models and repositories.
- `core/navigator`: This directory holds navigation routes and routing management.
- `core/services`: This directory holds the services used by the application, such as database, storage, bluetooth, location, etc.
- `core/utils`: This directory holds application's utility files.(Ex. String decoders, Date decoders, etc.)
- `core/cubits`: This directory holds the integration and management of Cubit.
- `features/`: This directory holds all the application features.
- `features/NAME_OF_FEATURE/domain`: This directory holds the use cases that comunicate with data repositories.
- `features/NAME_OF_FEATURE/presentation`: This directory holds UI related files.
- `features/NAME_OF_FEATURE/presentation/business_components`: This directory hold the state management and business logic of the feature. In this case Cubit for state management.
- `features/NAME_OF_FEATURE/presentation/components`: This directory may or may not exist. It holds components/widgets specific for this feature.
- `features/NAME_OF_FEATURE/presentation/user_interfaces`: This directory holds the interface files.

- `pubspec.yaml`: This file contains all of the application's dependencies.
- `.github/CODEOWNERS`: This file specifies code owners and reviewers for the project.
- `.github/pull_request_template.md`: file in a software development repository that serves as a standardized format for creating pull requests (PRs).
- `.gitignore`: The `.gitignore` file defines which files and directories should be ignored by Git.
- `README.md`: This file, which provides basic information about the project.
