# twitter-client
A Twitter client built using Processing.All GUI elements are custom built using Processing native drawing capabilities. Connection with Twitter provided using Twiter4J. There are two tabs on the left: Search and Publish.
## Search Tab
You can search for tweets using the text field at the top of the page and view the results in 3 different ways.
### Normal List
This emulates the appearance of the standard Twitter interface and shows a list of tweets returned by Twitter. I implemented a scrolling solution from scratch and when the bottom of the list is reached, more tweets are fetched.
### Image View
This flashes the tweets returned by scaling the font size based on the number of followers the user has and placing the text over a heavily filtered version of their profile image.
### Camera View
This uses the image from the computer's camera and displays the image using the text from all the tweets appended together. It does this in real time and displays it to the user.
## Publish Tab
This tab shows the user's twitter feed and allows them to publish a new tweet using the controls at the top of the page.
## Running Instructions
You will need to install Processing and add Twitter4J as a library. You will then need to get aPi keys for your twitter account and replace the following keys in PTwitter.pde with the appropriate values:
* CONSUMER_KEY
* CONSUMER_SECRET
* AUTH_ACCESS_TOKEN
* ACCESS_TOKEN_SECRET