/**  Author - Thomas Jordan
*    A Processing wrapper for the twitter4J Java Library
*    Wraps up different objects into a simple PTweet object
*    Provides a simpler interface to twitter
*/
import twitter4j.util.*;
import twitter4j.*;
import twitter4j.management.*;
import twitter4j.api.*;
import twitter4j.conf.*;
import twitter4j.json.*;
import twitter4j.auth.*;

class PTwitter {
  Twitter tw;
  PImage failWhale;

  PTwitter() {
    init();
  }

  //Connects to the twitter account when the class is created
  void init() {
    ConfigurationBuilder cb = new ConfigurationBuilder();
    cb.setOAuthConsumerKey("CONSUMER_KEY");
    cb.setOAuthConsumerSecret("CONSUMER_SECRET");
    cb.setOAuthAccessToken("AUTH_ACCESS_TOKEN");
    cb.setOAuthAccessTokenSecret("ACCESS_TOKEN_SECRET");

    tw = new TwitterFactory(cb.build()).getInstance();
    
    failWhale = loadImage("FailWhale.jpg");
  }

  //Tweets the argument string
  void publish(String content) {
    if (content == null || content.equals("")) {
      //Connot tweet empty string so simply return
      return;  
    }
    try {
      tw.updateStatus(content);
    }
    catch (Exception ex) {
      println("Twitter Search Error: " + ex.getMessage());
      ex.printStackTrace();
    }
  }

  //Finds the first 100 tweets that match the search term
  ArrayList search(String term) {
    if (term == null || term.equals("")) {
      return new ArrayList();
    }

    try {
      Query query = new Query(term);
      query.setCount(100);
      QueryResult result = tw.search(query);

      ArrayList tweets = (ArrayList) result.getTweets();

      ArrayList results = new ArrayList();
      for (int i = 0; i < tweets.size (); i++) {
        Status status = (Status) tweets.get(i);
        PTweet tweet = convertTweet(status);

        results.add(tweet);
      }

      return results;
    }
    catch (Exception ex) {
      println("Twitter Search Error: " + ex.getMessage());
      ex.printStackTrace();
      ArrayList fail = new ArrayList();
      fail.add(getFailWhale());
      return fail;
    }
  }

  //Finds 100 tweets matching the search term which have an id lower than the lastId value
  ArrayList search(String term, long lastId) {
    if (term == null || term.equals("")) {
      return new ArrayList();
    }

    try {
      Query query = new Query(term);
      query.setMaxId(lastId);
      query.setCount(100);
      QueryResult result = tw.search(query);

      ArrayList tweets = (ArrayList) result.getTweets();

      ArrayList results = new ArrayList();
      for (int i = 0; i < tweets.size (); i++) {
        Status status = (Status) tweets.get(i);
        PTweet tweet = convertTweet(status);

        results.add(tweet);
      }

      return results;
    }
    catch (Exception ex) {
      println("Twitter Search Error: " + ex.getMessage());
      ex.printStackTrace();
      ArrayList fail = new ArrayList();
      fail.add(getFailWhale());
      return fail;
    }
  }

  //Returns the first 20 tweets from the authenticated users timeline
  ArrayList timeline() {
    try {
      ArrayList tweets = (ArrayList) tw.getHomeTimeline();

      ArrayList results = new ArrayList();
      for (int i = 0; i < tweets.size (); i++) {
        Status status = (Status) tweets.get(i);
        PTweet tweet = convertTweet(status);

        results.add(tweet);
      }

      return results;
    }
    catch (Exception ex) {
      println("Twitter Search Error: " + ex.getMessage());
      ex.printStackTrace();
      ArrayList fail = new ArrayList();
      fail.add(getFailWhale());
      return fail;
    }
  }

  //Returns the 20 tweets from the authenticated users timeline with an id lower than the last id
  ArrayList timeline(long lastId) {
    try {
      Paging p = new Paging();
      p.setMaxId(lastId);
      ArrayList tweets = (ArrayList) tw.getHomeTimeline(p);

      ArrayList results = new ArrayList();
      for (int i = 0; i < tweets.size (); i++) {
        Status status = (Status) tweets.get(i);
        PTweet tweet = convertTweet(status);

        results.add(tweet);
      }

      return results;
    }
    catch (Exception ex) {
      println("Twitter Search Error: " + ex.getMessage());
      ex.printStackTrace();
      ArrayList fail = new ArrayList();
      fail.add(getFailWhale());
      return fail;
    }
  }

  //Returns a string containing the text from the first 100 tweets returned by the query 
  String getTweetText(String term) {
    if (term == null || term.equals("")) {
      return "Twitter";
    }

    try {
      Query query = new Query(term);
      query.setCount(100);
      QueryResult result = tw.search(query);

      ArrayList tweets = (ArrayList) result.getTweets();

      String resultSt = "";
      for (int i = 0; i < tweets.size (); i++) {
        Status status = (Status) tweets.get(i);
        resultSt += status.getText();
      }

      return resultSt;
    }
    catch (Exception ex) {
      println("Twitter Search Error: " + ex.getMessage());
      ex.printStackTrace();
      return "Twitter Error";
    }
  }

  //Returns default error tweet if error occurs, usually because of request limit
  PTweet getFailWhale() {
    return new PTweet(
      Long.MAX_VALUE,
      "Twitter API Limit Exceeded", 
      "PTwitter Client", 
      "ptwit", 
      "Griffith", 
      1, 
      failWhale, 
      new java.util.Date()
    );
  }

  //Returns PTweet which contains combined info from the Status and User objects
  PTweet convertTweet(Status status) {
    long id = status.getId();
    String text = status.getText();
    java.util.Date date = status.getCreatedAt();
    User user = status.getUser();
    String profilePicURL = user.getProfileImageURL();
    String userName = user.getName();
    String name = user.getScreenName();
    String location = user.getLocation();
    int followers = user.getFollowersCount();
    PImage image = loadImage(profilePicURL);

    PTweet tweet = new PTweet(
    id, 
    text, 
    userName, 
    name, 
    location, 
    followers, 
    image, 
    date);

    return tweet;
  }
}