# AM2R - Safoos
Active and smart components oriented to the 2 wheel sector.

## Project Description

This project aims to conceive a versatil product that may be applied to already existing public luminary infrastructure and give users visual feedback regarding road safety and current maintenance.


[Link to idinet](https://idinet.centi.pt/Idinet/PR921/)


## Repository Contents

This repository contains the following main files and directories:

- `Documentation/`: This directory holds all project documentation, including user manuals, technical specifications, and any other relevant documents.
- `Firmware/`: The firmware directory contains code and related resources for the electronic system's firmware.
- `Hardware/`: In the hardware directory, you'll find design files, schematics, and any hardware-related documentation.
- `Software/`: The software directory contains code and resources for the electronic system's software components, like application, frontend and back end server.
- `.github/CODEOWNERS`: This file specifies code owners and reviewers for the project.
- `.github/pull_request_template.md`:  file in a software development repository that serves as a standardized format for creating pull requests (PRs).
- `.gitignore`: The `.gitignore` file defines which files and directories should be ignored by Git.
- `README.md`: This file, which provides basic information about the project.

## Electronic System Solution

The final product will be divided into 4 modules:
- Sensors - constains sensors for air quality monitoring and moving objects detection for usage statistics and safety. This module has its own microcontroller to process all sensor data.
- Communication - contains module to construct a mesh topology network, that can quickly react and warn a user of any danger that may happen.
- Light - LEDs that give information about the current state of a certain section of the road. Its a mix of projected light (high brightness LEDs) and diret light.
- Power - a system that takes de mains power and is able to power all the other modules, as well as charge a battery pack that keeps the system working during the day.
- Web Server - a processing and storing unit, that keeps track of data received from the poles and sends them information if needed. It's also the source of the information used in the mobile app.
- Mobile App - it's where all information will be shared with the user, regarding for example air quality and road usage. It may also be used to warn about a potential danger ahead.


Detailed info can be found in the [OneNote](https://centi.sharepoint.com/sites/readeElectrnica/_layouts/15/SkySyncRedir.aspx?Type=2&ResourceId=c1ed132bda314131810b4c22c18d7e0a&CallerScenarioId=OneNote-Prod&CallerId=Sync-Windows)


### Software Details

Provide detailed information about the software components of your project, including the application, frontend, and backend server. Explain the technologies used, the architecture, and any significant modules or functionalities.

[Software README](Software/README.md)

### Firmware Details

Provide detailed information about the firmware component of your project. Explain the purpose of the firmware project, the technologies used, and any specific features or functionalities.

[Firmware README](Firmware/README.md)

### Hardware Details

Provide detailed information about the hardware component of your project. Include details about the design, schematics, and any important specifications.

[Hardware README](Hardware/README.md)
