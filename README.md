# FetchApp

## Overview
FetchApp is a SwiftUI application that displays a categorized list of items fetched from a remote API. The items are grouped by `listId` and can be explored in detail by navigating through intuitive UI elements.

## Features
- **Data Fetching**: Utilizes URLSession to retrieve data asynchronously from a remote JSON endpoint.
- **Data Processing**: Implements custom logic to parse, filter, and sort the JSON data based on `listId` and `name`.
- **UI Representation**: Uses SwiftUI to present a grouped list view with navigation capabilities to detailed views.

## Installation
To run FetchApp, clone the repository and open the project in Xcode. Ensure you are using the latest non-beta version of Xcode and have a compatible version of iOS set in the deployment target.

```bash
git clone https://yourrepositorylink.com/FetchApp.git
cd FetchApp
open FetchApp.xcodeproj
