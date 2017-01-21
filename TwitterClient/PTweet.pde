/**  Author - Thomas Jordan
*    Utility Class to hold tweet and user info
*/
class PTweet {
  long id;
  String text;
  String handle;
  String userName;
  String location;
  int followers;
  PImage profileImage;
  java.util.Date date;
  
  PTweet(long _id, String _text, String _handle, String _userName, String _location, int _followers, PImage _profileImage, java.util.Date _date) {
    id = _id;
    text = _text;
    handle = _handle;
    userName = _userName;
    location = _location;
    followers = _followers;
    profileImage = _profileImage;
    date = _date;
  }
  
  long getId() {
    return id;
  }
  
  String getText() {
    return text;
  }
  
  String getHandle() {
    return handle;
  }
  
  String getUserName() {
    return userName;
  }
  
  String getLocation() {
    return location;
  }
  
  int getFollowers() {
    return followers;
  }
  
  PImage getProfileImage() {
    return profileImage;
  }
  
  java.util.Date getDate() {
    return date;  
  }
}
