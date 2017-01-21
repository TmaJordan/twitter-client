/**  Author - Thomas Jordan
*    Describes a basic tab with icon
*/

class Tab {
  int x;
  int y;
  int w;
  int h;
  color c;
  color hoverColor;
  boolean selected = false;
  String mode = "";
  PShape icon;
  
  //Thought of subclassing the button object but decided against it.
  Tab(int _x, int _y, int _w, int _h, color _c, color _hoverColor, String _mode) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
    c = _c;
    hoverColor = _hoverColor;
    mode = _mode;
    icon = loadShape(mode + ".svg");
  }
  
  void display() {
    stroke(0);
    strokeWeight(1);
    //Same fill color for both hover and selected states
    if (inTab() || selected) {
      fill(hoverColor);
    } else {
      fill(c);
    }
    rect(x, y, w, h);
    
    if (icon != null) {
      shapeMode(CENTER);
      shape(icon, x + w/2, y + h/2, w-20, w-20);
    }
  }
  
  boolean inTab() {
    if((mouseX > x) && (mouseX < x+w) && (mouseY > y) && (mouseY < y+h)){
      return true;
    } else {
      return false;
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
