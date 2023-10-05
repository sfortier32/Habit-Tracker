# Habit-Tracker
Contributors: Sophia Fortier
Project Type: Personal

### Premise
While browsing the app store for habit tracking apps, I was unable to find anything that was straight to the point without requiring subscriptions for the most basic activities. I decided to create my own iOS app using Swift that would fill this gap. The app is not available for download on the app store since I'm am using the Founder sGrotesk font for free under a non-commerical license. Furthermore, the home page design and rest of the app was inspired by the artwork of Purrweb UI/UX Agency on [Dribble](https://dribbble.com/shots/21367995-Habit-Tracker-Mobile-IOS-App).

### Features
##### Home Page
The app displays the user's name and a date carousel on the home page, providing an interface to interact with habits. New ones can be created while existing ones can be deleted, marked done, skipped, or missed. Timers are also accessible by clicking on the clock icon next to applicable tasks to provide activity reinforcement. 

##### Statistics Page
Users can view their "streaks" for each habit i.e. how long they have continuously completed their tasks. They can also see a weekly habit report where progress (done, missed, skipped, not done) is marked for each day of the week with associated colors visible on the home page.

##### Achievements
Custom "badges" have been designed using Figma for milestones related to streak duration and tasks completed. There are confetti effects and badge spotlights once new badges are completed and the achievements page is entered. Code for this effect was solely developed by @shaundon on [GitHub](https://github.com/shaundon/ConfettiDemo) and placed in the Confetti.swift file.

##### Settings
The settings page currently allows users to delete batches of data i.e. the app's models.


### Tasks
##### To-Do
- If timer never started remove on disappear
- Reward system inside achievements view
    - Get currency for every completion and use them to skip days
    - Get currency for unlocking badges
    - Minutes achievements
    - Redo design
- Allow reminders
    - Make a ‘life or death’ mode that forces permanent miss if not done in specific time period after reminder
- Add attributions to settings page

##### Done
- Add New Habits View
    - Redesigned
    - Custom units
    - Use model for habit editor
        - Fix variables not being passed into add habit view on first try by putting everything into a class (and subsequent environment objects)
    - Habit categories
        - Make person able to put them in whatever order they want
        - In no category by default
- Home View
    - Fix streaks not updating correctly when folder is updated
    - Fix missed not updating correctly (for forward and back in time)
    - Bubbles to date carousel
    - Fixed lists updating too slowly
    - Added in no task view
    - Categories appear in correct order
    - Add timer pop up
        - Dictionary in each habit with the day being the key and time being the value
        - Confetti when complete
        - Disable stopwatch once activity is complete and add edited date to done from current pile
- Stats View
    - Design badges for streaks and tasks
    - Make badges unlockable
        - Create achievement class
    - Add pop up for new achievements with confetti on entering view
- Fix terms view always popping up (subsequently an issue with UserDefaults)
- Design
    - Adjust fonts and sizing throughout app
    - Standardize text
    - Add blur on scroll views
    - Add text on days where no habits occur
- Settings View
    - Change to list view with matching app aesthetic
    - About page
    - Reset data buttons
    - Split achievements into new tab
