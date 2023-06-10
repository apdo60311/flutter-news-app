# Daily News

### This is a flutter app that displays the latest news from various sources. The app uses the News API to fetch the news data, and displays the news in a list view with images.

<br>

## Features
1. Browse the latest news from various sources
2. View the news details including the full article
3. Search for news by keyword
4. Save articles to read later
5. Share articles with friends and family
6. Login & register **Not Working** 
## Installation and Usage

1. Clone this repository
2. Run flutter pub get to install the dependencies
3. Create an account on the [News API](https://newsapi.org/) website and obtain an API key
4. Put your api key in constants file 
5. Run the app using flutter run or your preferred IDE

## Screenshots
<p align="center">
  <img src="./Readme%20Images/Screenshot.png" alt="News App Screenshot 1" width="250" style="margin-right: 40px" />
  <img src="./Readme%20Images/Screenshot1.png" alt="News App Screenshot 1" width="250" />
  <img src="./Readme%20Images/Screenshot2.png" alt="News App Screenshot 1" width="250" style="margin-right: 40px;margin-top: 40px"/>
  <img src="./Readme%20Images/Screenshot3.png" alt="News App Screenshot 1" width="250" />
</p>

## Folder Structure

The workspace contains two folders by default, where:

- `lib`: the folder to maintain sources 
    - `Models`:  contains all models
    - `Modules`:  contains all screens
    - `Shared`:  contains all classes and which used globaly
        - `components`: contains constants and shared components like buttons
        - `cubit`: contains all cubit related files 
        - `local`: contains all shared functionality which used offline 
        - `network`: contains all functionality which<br>
        used online like appi calls
        - `colors`: contains colors an themes

## Contributing

#### Contributions are welcome! If you find any bugs or issues with the app, please open a new issue on the GitHub repository. If you would like to contribute code, please fork the repository and submit a pull request.