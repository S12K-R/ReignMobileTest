# ReignMobileTest
My submission of the Reign Mobile Developer test (for practice purposes)

The Reign Mobile Test consists of building a small mobile aplication with either Swift or Kotlin. It features a scrolling list view of recent posts sorted
by date, with cells that open a web view containg the new that the cell contains. Basically, it's a news aplication that uses an API which shows recently
posted articles about Android or iOS on HackerNews.

As mentioned, the main view of the app is a scrolling list of recent post in date order. Each cell contains a small description of the post and it's
publishing date, the post can be accessed by tapping the cell which opens a Safari window with the URL of the post. The cells can be deleted by swiping
to the left and pressing the delete button, this erases the cell and it stops it from appearing again when closing and re opening the app.

The app can also be used offline. The news data is requested using Alamofire services which handles the inicial requests and further requests
when reloading the table to update the news. This app can be used offline , since everytime the news get loaded (or re-loaded) they get saved
in storage using UserDefaults to use them when the network is not available (this also takes in count the news that had been deleted before, so they
don't appear as well).



<img width="298" alt="Screenshot 2023-04-28 at 14 26 17" src="https://user-images.githubusercontent.com/70918171/235213852-7449d28c-9d93-4fbc-b6e1-a89cd2fadcf8.png">

<img width="298" alt="Screenshot 2023-04-28 at 14 26 28" src="https://user-images.githubusercontent.com/70918171/235213888-51942011-0031-4891-b74f-35d35139efc5.png">
