/**  Author - Thomas Jordan
*    Represents a basic circular button with optional icon
*    Has getters and setters as well as methods to determine if mouse is over button.
*/

class Button {
  int posX;
  int posY;
  int w;
  color c;
  color hoverColor;
  boolean selected = false;
  String mode = "";
  PShape icon;
 
  Button(int _posX, int _posY, int _w, color _c, color _hoverColor, String _mode) {
    posX = _posX;
    posY = _posY;
    w = _w;
    c = _c;
    hoverColor = _hoverColor;
    mode = _mode;
    icon = loadShape(mode + ".svg");
  }

  void display() {
    stroke(0);
    strokeWeight(1);
    //Can set up different states for hover and selected but this is good for now.
    if (inButton() || selected) {
      fill(hoverColor);
    } else {
      fill(c);
    }
    ellipse(posX, posY, w, w);
    
    //draw icon over/in ellipse
    if (icon != null) {
      shapeMode(CENTER);
      shape(icon, posX, posY, w-20, w-20);
    }
  }

  //If extending the class for a different shape button, this should be overrode to use a different method.
  boolean inButton() {
    if (dist(mouseX, mouseY, posX, posY) > w/2) {
      return false;
    } else {
      return true;
    }
  }
  
  void setSelected(boolean _selected) {
      selected = _selected;
  }
  
  boolean isSelected() {
    return selected;  
  }
  
  String getMode() {
    return mode;  
  }
  
  void setMode(String _mode) {
    mode = _mode;  
  }
}
