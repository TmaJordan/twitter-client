/**  Author - Thomas Jordan
*    Simple text field with basic methods
*    Limited to the width of the field
*/
class TextField {
  String text;
  int x;
  int y;
  int w;
  int h;
  boolean hasFocus;
  boolean blink;
  
  TextField(int _x, int _y, int _w, int _h, String _text) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    text = _text;
  }
  
  void display() {
    fill(255);
    stroke(0);
    rect(x, y, w, h);
    
    fill(60);
    textSize(20);
    text(text, x+10, y+30);
    
    if (frameCount % 20 == 0) {
      //flag for blinking the cursor every 20 frames
      blink = !blink;  
    }
    
    //Only show line when focused and blink is true
    if (hasFocus && blink) {
      float stringWidth = textWidth(text) + 10;
      line(x + stringWidth,y+10,x + stringWidth,y+30);
    }
    
    //Change the cursor when in the field to show the user that it is a text field
    if (inField()) {
      cursor(TEXT);  
    }
    else {
      cursor(ARROW);  
    }
  }
  
  void setText(String newText) {
    //MAke sure new string fits in available space
    if (textWidth(newText) < w - 10) {
      text = newText;
    }
  }
  
  String getText() {
    return text;  
  }
  
  boolean isFocused() {
    return hasFocus;  
  }
  
  void setFocused(boolean f) {
    hasFocus = f;  
  }
  
  boolean inField() {
    if((mouseX > x) && (mouseX < x+w) && (mouseY > y) && (mouseY < y+h)){
      return true;
    } else {
      return false;
    }
  }
}
