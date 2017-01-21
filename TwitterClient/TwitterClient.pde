/**
 *  Twitter Application
 *  Thomas Jordan - tmajordan@gmail.com
 *********************************************************
 *  Icons by Freepik, SimpleIcon, Catalin Fertu and Vectorgraphit from www.flaticon.com are licensed by CC BY 3.0
 *  Background image from Fickr CC Non Commercial by Pam Broviak Pam_Broviak
 *
 *  The app consists of 2 high level tabs which contain search and tweet functions
 *  The search tab can disolay tweets in 3 modes. The tweet tab shows the timeline as well as allows the user to send tweets.
 *********************************************************
 *  Ideas for future development (Not implemented): Favourite and Retweet of tweets, geo view of tweets, pull down to refresh feed.
 */
import java.util.*;
import java.text.*;

import processing.video.*;

//Tabs and high level controls
Tab[] tabs;
String[] tabModes = {
  "SEARCH", "TWEET"
};
String mode = "";
Tab selectedTab;
int scrollPos;
PImage bg;
SimpleDateFormat df = new SimpleDateFormat("MMM dd, yyyy");

//Search Controls
TextField searchTf;
Button searchBt;
Button[] displayModeButtons;
String[] displayModes = {
  "LIST", "FLASH", "IMAGE"
};
String displayMode = "";
Button selectedButton;

int searchbarHeight = 60;
int sidebarWidth = 60;
int buttonSize = 40;
color buttonColor = color(255, 150);
color bHoverColor = color(163, 217, 255, 180);

PTwitter tw;
ArrayList tweets = new ArrayList();
String tweetString = "Twitter";
int index = 0;

Capture cam;
float fontSizeMax = 11;
float fontSizeMin = 3;
float spacing = 10; // line height
float kerning = 0.2; // between letters

//Tweeting controls
TextArea tweetTa;
Button tweetBt;
int tweetbarHeight = 100;
int tweetLength = 140;
ArrayList timeline = new ArrayList();

void setup() {
  size(700, 500);
  background(255);
  tw = new PTwitter();

  bg = loadImage("Clouds.jpg");
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
  } else {
    // Pick the first available camera:
    cam = new Capture(this, cameras[0]);
    cam.start();
  }    

  //Create the search field and button
  searchTf = new TextField(sidebarWidth+10, 10, 210, 40, "");
  searchBt = new Button(sidebarWidth+245, searchbarHeight/2, buttonSize, buttonColor, bHoverColor, "SEARCH");

  //Create the buttons for the different search modes
  displayModeButtons = new Button[displayModes.length];
  for (int i = 0; i < displayModes.length; i++) {
    //Calculate x positions based on index and number of buttons
    int x = int((width/3) / (displayModes.length + 1) * (i+1)) + (width - 200);
    displayModeButtons[i] = new Button(x, searchbarHeight/2, buttonSize, buttonColor, bHoverColor, displayModes[i]); 

    if (i == 0) {
      //Default to selecting first button
      displayModeButtons[i].setSelected(true);
      selectedButton = displayModeButtons[i];
      displayMode = displayModeButtons[i].getMode();
    }
  }

  //Create the button and area for tweeting to the user profile
  tweetBt = new Button(width - 40, tweetbarHeight - buttonSize/2 - 10, buttonSize, buttonColor, bHoverColor, "TWEET");
  tweetTa = new TextArea(sidebarWidth+10, 10, width - sidebarWidth - 80, 80, "", tweetLength);

  //Create the 2 main tabs along the left of the screen
  tabs = new Tab[tabModes.length];
  for (int i = 0; i < tabModes.length; i++) {
    //Calculate positions based on index and number of buttons
    int y = i * height/tabModes.length;
    tabs[i] = new Tab(0, y, sidebarWidth, height/2, buttonColor, bHoverColor, tabModes[i]); 

    if (i == 0) {
      //Default to selecting first button
      tabs[i].setSelected(true);
      selectedTab = tabs[i];
      mode = tabs[i].getMode();
    }
  }
}

void draw() {
  //Draw the clouds in the background
  image(bg, 0, 0, width, height);  

  if (mode == "SEARCH") {
    
    if (displayMode == "LIST") {
      //List tweets in the traditional way
      listTweets();
    } else if (displayMode == "FLASH") {
      //Flash tweets, once per second over the profile image
      flashTweets();
    } else if (displayMode == "IMAGE" && cam != null) {
      //Do image from webcam with text from twitter search results
      imageTweets();
    }
    
    //Display search controls
    fill(255, 100);
    rect(sidebarWidth, 0, width, searchbarHeight);
    searchTf.display();
    searchBt.display();

    for (Button button : displayModeButtons) {
      button.display();
    }
  } else if (mode == "TWEET") {
    //Display user's timeline
    showTimeline();
    
    //Display Tweeting controls
    fill(255, 100);
    rect(sidebarWidth, 0, width, tweetbarHeight);
    tweetTa.display();
    tweetBt.display();

    //Show remaining characters available
    fill(0);
    textSize(18);
    text(String.valueOf(tweetLength-tweetTa.getText().length()), width - 60, 10, 60, 30);
  }

  //Display sidebar tabs
  fill(255, 100);
  rect(0, 0, sidebarWidth, height);

  for (Tab tab : tabs) {
    tab.display();
  }
}

//This method flashes individual tweets over the profile pic with a threshold filter applied.
//The font size is dependant on the number of followers that the user has.
void flashTweets() {
  if (tweets.size() > 0 && index < tweets.size() - 1) {
    //Red text for tweet text
    fill(#D60000);
    PTweet tweet = (PTweet) tweets.get(index);
    image(tweet.getProfileImage(), sidebarWidth, searchbarHeight, width - sidebarWidth, height - searchbarHeight);
    filter(THRESHOLD);
    textSize(constrain(tweet.getFollowers() / 30, 5, 30));
    text(tweet.getText(), sidebarWidth, height/4, width - sidebarWidth, height/2);

    //Change tweet to the next one every second
    if (frameCount % 60 == 0) {
      if (index < tweets.size() - 1) {
        index++;
      } else {
        index = 0;
      }
    }
  }
}

//Display tweets in the normal way in a sequesntial list
void listTweets() {
  for (int i = 0; i < tweets.size (); i++) {
    PTweet tweet = (PTweet) tweets.get(i);
    //Offset tweet list by the scroll position
    drawTweet((searchbarHeight + i * 100) - scrollPos, tweet);
  }
  
  //Display scroll indicator to show how far user has scrolled
  if (tweets.size() > 0) {
    strokeWeight(6);
    stroke(0);
    strokeCap(ROUND);
    float y = map(scrollPos, 0, (tweets.size() * 100) - height + searchbarHeight, searchbarHeight, height);
    line(width-5, y, width-5, y+15);
    strokeWeight(1);
  }
}

//Display user's timeline in the normal way, as a list
void showTimeline() {
  for (int i = 0; i < timeline.size (); i++) {
    PTweet tweet = (PTweet) timeline.get(i);
    drawTweet((tweetbarHeight + i * 100) - scrollPos, tweet);
  }
  //Display scroll indicator to show how far user has scrolled
  if (timeline.size() > 0) {
    strokeWeight(6);
    stroke(0);
    strokeCap(ROUND);
    float y = map(scrollPos, 0, (timeline.size() * 100) - height + tweetbarHeight, tweetbarHeight, height);
    line(width-5, y, width-5, y+15);
    strokeWeight(1);
  }
}

//Method to draw each tweet in the list
void drawTweet(int y, PTweet tweet) {
  fill(255, 210);
  rect(sidebarWidth+10, y+10, width-sidebarWidth-20, 90);
  fill(0);
  //Draw profile image
  if (tweet.getProfileImage() instanceof PImage) {
    image(tweet.getProfileImage(), sidebarWidth+15, y+15, 80, 80);
  }

  textSize(16);
  text(tweet.getHandle(), sidebarWidth+100, y+15, 150, 30);
  textSize(14);
  fill(155);
  text("@" + tweet.getUserName(), sidebarWidth+250, y+17, 100, 25);
  text(df.format(tweet.getDate()), width - 120, y+17, 100, 30);
  fill(0);
  text(tweet.getText(), sidebarWidth+100, y + 40, width-sidebarWidth-120, 60);
}

//This uses a variation of the process used in Generative Design to draw the image from the webcam using the text from the tweets.
void imageTweets() {
  if (cam.available() == true) {
    cam.read();
  }

  //Draw white background for text
  noStroke();
  fill(255);
  rect(sidebarWidth, searchbarHeight, width - sidebarWidth, height - searchbarHeight);

  float x = sidebarWidth;
  float y = searchbarHeight +10;
  int counter = 0;

  while (y < height) {
    // translate position (display) to position (image)
    int imgX = (int) map(x, sidebarWidth, width, 0, cam.width);
    int imgY = (int) map(y, searchbarHeight, height, 0, cam.height);
    // get current color and brightness of pixel from cam
    color c = cam.pixels[imgY*cam.width+imgX];
    float greyscale = brightness(c);

    //Use pushMatrix and translate for ease of drawing logic
    pushMatrix();
    translate(x, y);

    // greyscale to fontsize and use color of pixel for letter. USe max to stop fontsize from being 0 or less which will cause errors.
    float fontSize = map(greyscale, 0, 255, fontSizeMax, fontSizeMin);
    fontSize = max(fontSize, 1);
    textSize(fontSize);
    fill(c);
    
    //Get the next letter from the tweet string
    char letter = tweetString.charAt(counter);
    text(letter, 0, 0);
    float letterWidth = textWidth(letter) + kerning;
    // for the next letter ... x + letter width
    x = x + letterWidth; // update x-coordinate
    //Return to previous reference frame
    popMatrix();

    // linebreaks
    if (x+letterWidth >= width) {
      x = 0;
      y = y + spacing; // add line height
    }

    counter++;
    //Make sure that counter doesn't exceed length of twitter string
    if (counter > tweetString.length()-1) {
      counter = 0;
    }
  }

  /* Messing around with modifying image from web cam
   float xStep = cam.width / 100;
   float yStep = cam.height / 100;
   float xblockSize = (width - sidebarWidth) / 100;
   float yblockSize = (height - searchbarHeight) / 100;
   for (int x = 0; x<cam.width; x+=xStep) {
   for (int y = 0; y<cam.height; y+=yStep) {
   color c = cam.get(x, y);
   if (brightness(c) > 100) {
   fill(255);
   } else {
   fill(0);
   }
   float xPos = map(x, 0, cam.width, sidebarWidth, width);
   float yPos = map(y, 0, cam.height, searchbarHeight, height);
   rect(xPos, yPos, xblockSize, yblockSize);
   }
   }
   */
  //image(cam, sidebarWidth, searchbarHeight, width-sidebarWidth, height-searchbarHeight);
}

void keyPressed() {
  //Only respond if the text field has focus and is on correct tab
  if (searchTf.isFocused() && mode == "SEARCH") {
    if (keyCode == BACKSPACE) {
      // Handle backspace and reomve last char from focused text field
      if (searchTf.getText().length() > 0) {
        searchTf.setText(searchTf.getText().substring(0, searchTf.getText().length()-1));
      }
    } else if (keyCode == ENTER) {
      //Submit the search query on Enter and return scroll position to 0
      tweets = tw.search(searchTf.getText());
      tweetString = tw.getTweetText(searchTf.getText());
      scrollPos = 0;
    } else {
      if (keyCode != SHIFT && keyCode != LEFT && keyCode != RIGHT) { // mare sure the shift key or left/right arrows aren't entered to the string
        searchTf.setText(searchTf.getText() + key);
      }
    }
  } else if (tweetTa.isFocused() && mode == "TWEET") {
    if (keyCode == BACKSPACE) {
      // Handle backspace and reomve last char from focused text field
      if (tweetTa.getText().length() > 0) {
        tweetTa.setText(tweetTa.getText().substring(0, tweetTa.getText().length()-1));
      }
    } else if (keyCode == ENTER) {
      //Publish the tweet, fetch the new timeline containing the tweet and reset the scroll position to 0
      tw.publish(tweetTa.getText());
      timeline = tw.timeline();
      tweetTa.setText("");
      scrollPos = 0;
    } else {
      if (keyCode != SHIFT && keyCode != LEFT && keyCode != RIGHT) { // mark sure the shift key or left/right arrows aren't entered to the string
        tweetTa.setText(tweetTa.getText() + key);
      }
    }
  }

  //Scroll up and down and determine bottom based on mode
  if (mode == "SEARCH") {
    if (keyCode == DOWN) {
      scrollPos += 30;
      //If scrolling hits the bottom, stop and fetch more tweets
      if (scrollPos > (tweets.size() * 100) - height + searchbarHeight) {
        scrollPos = (tweets.size() * 100) - height + searchbarHeight;
        PTweet tweet = (PTweet) tweets.get(tweets.size() - 1);
        tweets.addAll(tw.search(searchTf.getText(), tweet.getId()));
      }
    } else if (keyCode == UP) {
      scrollPos -= 30;
      scrollPos = scrollPos < 0 ? 0 : scrollPos;
    }
  } else if (mode == "TWEET") {
    if (keyCode == DOWN) {
      scrollPos += 30;
      //If scrolling hits the bottom, stop and fetch more tweets
      if (scrollPos > (timeline.size() * 100) - height + tweetbarHeight) {
        scrollPos = (timeline.size() * 100) - height + tweetbarHeight;
        PTweet tweet = (PTweet) timeline.get(timeline.size() - 1);
        timeline.addAll(tw.timeline(tweet.getId()));
      }
    } else if (keyCode == UP) {
      scrollPos -= 30;
      scrollPos = scrollPos < 0 ? 0 : scrollPos;
    }
  }
}

void mousePressed() {
  if (searchTf.inField()) {
    // focus the text field on click
    searchTf.setFocused(true);
  } else if (searchBt.inButton()) {
    //Submit search query
    tweets = tw.search(searchTf.getText());
    tweetString = tw.getTweetText(searchTf.getText());
    scrollPos = 0;
  } else {
    searchTf.setFocused(false);
  }

  if (tweetTa.inField()) {
    tweetTa.setFocused(true);
  } else if (tweetBt.inButton()) {
    //Publish tweet and refresh timeline
    tw.publish(tweetTa.getText());
    timeline = tw.timeline();
    tweetTa.setText("");
    scrollPos = 0;
  } else {
    tweetTa.setFocused(false);
  }

  //Check mode buttons to see which were clicked
  boolean buttonClicked = false;
  for (Button button : displayModeButtons) {
    if (button.inButton()) {
      button.setSelected(true);
      selectedButton = button;
      displayMode = button.getMode();
    } else {
      button.setSelected(false);
    }
  }
  if (!buttonClicked) {
    //Make sure that button is only deselected if another mode is clicked
    selectedButton.setSelected(true);
  }

  //Check tabs to see which one if any have been selected
  boolean tabClicked = false;
  for (Tab tab : tabs) {
    if (tab.inTab()) {
      tab.setSelected(true);
      selectedTab = tab;
      scrollPos = 0;
      mode = tab.getMode();
      if (mode == "TWEET") {
        //If user opens tweets, get timeline
        timeline = tw.timeline();
      }
    } else {
      tab.setSelected(false);
    }
  }
  if (!tabClicked) {
    //Make sure that tab is only deselected if another tab is clicked
    selectedTab.setSelected(true);
  }
}

//Handle scroll functionality of tweet lists
void mouseWheel(MouseEvent event) {
  if (mode == "SEARCH") {
    scrollPos += event.getCount();
    scrollPos = scrollPos < 0 ? 0 : scrollPos;
    
    //If scrolling hits the bottom, stop and fetch more tweets
    if (tweets.size() > 0 && scrollPos > (tweets.size() * 100) - height + searchbarHeight) {
      scrollPos = (tweets.size() * 100) - height + searchbarHeight;
      PTweet tweet = (PTweet) tweets.get(tweets.size() - 1);
      tweets.addAll(tw.search(searchTf.getText(), tweet.getId()));
    }
    
    //Old way to stop scrolling without refreshing
    //scrollPos = scrollPos > (tweets.size() * 100) - height + searchbarHeight ? (tweets.size() * 100) - height + searchbarHeight : scrollPos;
  } else if (mode == "TWEET") {
    scrollPos += event.getCount();
    scrollPos = scrollPos < 0 ? 0 : scrollPos;

    //If scrolling hits the bottom, stop and fetch more tweets
    if (timeline.size() > 0 && scrollPos > (timeline.size() * 100) - height + tweetbarHeight) {
      scrollPos = (timeline.size() * 100) - height + tweetbarHeight;
      PTweet tweet = (PTweet) timeline.get(timeline.size() - 1);
      timeline.addAll(tw.timeline(tweet.getId()));
    }
    
    //Old way to stop scrolling without refreshing
    //scrollPos = scrollPos > (timeline.size() * 100) - height + tweetbarHeight ? (timeline.size() * 100) - height + tweetbarHeight : scrollPos;
  }
}