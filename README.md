# Appgain Movies Task

A flutter movies application.

## Getting Started

### This project supports three features:
#### 1. Fetching movies from TMDB API.
#### 2. Featuring Deep Links.
#### 3. Featuring Push Notifications from Firebase.

### How it works:

#### 1. Deep Links:
- You can use deep links by opening android studio while connecting your phone or using emulator.
- Then use this command: 
adb shell am start movieapptask://open
- There are two deep links in this app:
  1. movieapptask://open
  2. movieapptask://details_screen/movie_id (ex: movie_id = 335787)

#### 2. Firebase Push Notifications:
- You can push notifications directly from Firebase Messaging tap.
- Use "Send Test Message" for high priority messages.
- Use the token given in the debug apk logs to send a test message.
