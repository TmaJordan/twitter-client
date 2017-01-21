/**  Author - Thomas Jordan
*    A larger version of the text field where the text wraps and there is no cursor.
*    I wanted a cursor but couldn't figure out how to place it on the second line so went for a thicker border when selected.
*    Unlike the text field, has an option for max char length.
*/

class TextArea extends TextField {
  int maxLength;
  
  TextArea(int _x, int _y, int _w, int _h, String _text, int _max) {
    super(_x, _y, _w, _h, _text);
    maxLength = _max;
  }
  
  void display() {
    fill(255);
    stroke(0);
     //Can't figure out how to check which line text is on so changing stroke width when selected
    if (hasFocus) {
      strokeWeight(3);
    }
    else {
      strokeWeight(1);
    }
    rect(x, y, w, h);
    strokeWeight(1);
    
    fill(60);
    textSize(14);
    text(text, x+5, y+5, w - 10, h - 10);
        
    if (inField()) {
      cursor(TEXT);  
    }
    else {
      cursor(ARROW);  
    }
  }
  
  void setText(String newText) {
    if (newText.length() <= maxLength) {
      text = newText;
    }
  }
}
