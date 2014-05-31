/*
zanekrat delam na dveh statičnih slikah, ne najdem primerne baze
*/
PFont font = createFont("Arial", 16,true);
PFont font24 = createFont("Arial", 24,true); 
int Fwidth = Globals.FRAME_WIDTH;
int Fheight = Globals.FRAME_HEIGHT;
PImage img1;
PImage img2;

import controlP5.*;
ControlP5 cp5;
DropdownList d1, d2, d3, d4;
int cnt = 0;

Group compareViewElements;

void setup() {
  size(Fwidth, Fheight);
  img1 = loadImage("tm.jpg");
  img2 = loadImage("house.jpg");
  cp5 = new ControlP5(this);

  compareViewElements = cp5.addGroup("g1")
    .setPosition(0,0)
//    .setBackgroundHeight(100)
//    .setBackgroundColor(color(255,50))
    ;
  
  //dropdowns
  d1 = cp5.addDropdownList("list1_0")
    .setSize(Globals.boderLeftDD, Globals.boderLeftDD)
    .setPosition(Fwidth/4 - Globals.boderLeftDD, Globals.bodertopDD)
    .setGroup(compareViewElements)
    ;

  d2 = cp5.addDropdownList("list1_1")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(Fwidth/4 + 3, Globals.bodertopDD)
    .setGroup(compareViewElements)
    ;
  d3 = cp5.addDropdownList("list2_0")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition( 3*(Fwidth/4) - Globals.boderLeftDD, Globals.bodertopDD)
    .setGroup(compareViewElements)    
    ;
  d4 = cp5.addDropdownList("list2_1")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition( 3*(Fwidth/4) + 3 , Globals.bodertopDD)
    .setGroup(compareViewElements)
    ;
  
  d1.captionLabel().set("Pick a painter");
  d2.captionLabel().set("Pick a painting");
  d3.captionLabel().set("Pick another painter");
  d4.captionLabel().set("Pick another painting");
  customize(d1); 
  customize(d2);
  customize(d3);
  customize(d4); 
  //buttons
  cp5.addButton("RGB1")
    .setValue(0)
    .setPosition(Fwidth/Globals.buttonHeight,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
  
  cp5.addButton("HSB1")
    .setValue(0)
    .setPosition(Fwidth/Globals.buttonHeight + Globals.buttonWidth + Globals.spaceBetweenButtons,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
     
  cp5.addButton("...")
    .setValue(0)
    .setPosition(Fwidth/Globals.buttonHeight + Globals.buttonWidth*2 + Globals.spaceBetweenButtons*2,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
  cp5.addButton("RGB2")
    .setValue(0)
    .setPosition((Fwidth/2) + Fwidth/Globals.buttonHeight,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;

  cp5.addButton("HSB2")
    .setValue(0)
    .setPosition((Fwidth/2) + Fwidth/Globals.buttonHeight  + Globals.buttonWidth + Globals.spaceBetweenButtons,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;
     
  cp5.addButton("....")
    .setValue(0)
    .setPosition((Fwidth/2) + Fwidth/Globals.buttonHeight + Globals.buttonWidth*2 + Globals.spaceBetweenButtons*2,Fheight/2 - Globals.buttonWidth)
    .setSize(Globals.buttonWidth,Globals.buttonHeight)
    .setGroup(compareViewElements)
    ;

  prepareData("brugel");
}

void customize(DropdownList ddl) {
  // a convenience function to customize a DropdownList
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);
  ddl.captionLabel().style().marginTop = 10;
  ddl.captionLabel().style().marginLeft = 5;
  ddl.valueLabel().style().marginTop = 5;
  for (int i=0;i<40;i++) {
    ddl.addItem("item "+i, i);
  }
  ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void keyPressed() {
  // some key events to change the properties of DropdownList d1
  if (key=='1') {
    // set the height of a pulldown menu, should always be a multiple of itemHeight
    d1.setHeight(210);
  } 
  else if (key=='2') {
    // set the height of a pulldown menu, should always be a multiple of itemHeight
    d1.setHeight(120);
  }
  else if (key=='3') {
    // set the height of a pulldown menu item, should always be a fraction of the pulldown menu
    d1.setItemHeight(30);
  } 
  else if (key=='4') {
    // set the height of a pulldown menu item, should always be a fraction of the pulldown menu
    d1.setItemHeight(12);
    d1.setBackgroundColor(color(255));
  } 
  else if (key=='5') {
    // add new items to the pulldown menu
    int n = (int)(random(100000));
    d1.addItem("item "+n, n);
  } 
  else if (key=='6') {
    // remove items from the pulldown menu  by name
    d1.removeItem("item "+cnt);
    cnt++;
  }
  else if (key=='7') {
    d1.clear();
  }
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
  }
}

void prepareData(String author) {
  Globals.authorId = author;
  Globals.author = loadJSONObject(Globals.DATA_DIR + author + ".json");


  Globals.works = new JSONArray();
  JSONArray worksMeta = Globals.author.getJSONArray("works");
  for (int i = 0; i < worksMeta.size(); i++) {
    String id = worksMeta.getJSONObject(i).getString("id");
    String path = Globals.DATA_DIR + author + "/" + id + ".json";
    Globals.works.setJSONObject(i, loadJSONObject(path));
  }
}


void draw() {
  background(255);  
  fill(0,150,253);
  textFont(font);
  textAlign(CENTER);
  text("Analizing and comparing works of art",(Fwidth/2), 20);
  textFont(font24);
  text(Globals.author.getString("name"),(Fwidth/2), 50);

  textFont(font);

  

  if (Globals.viewMode == Globals.VIEW_MODE_WORKS) {
    drawWorks();
  } else {
    drawCompare();
  }
}

void drawCompare() {
  //draw line
  stroke(212,212,210);
  line(Fwidth/2,Globals.buttonWidth + Globals.buttonHeight,Fwidth/2,Fheight/2);
  compareViewElements.show();
  img1.resize(0,200);
  img2.resize(0,200);
  imageMode(CENTER);
  image(img1,Fwidth/4,Fheight/4 + Globals.imageMargin);
  image(img2,(Fwidth/4)*3,Fheight/4 + Globals.imageMargin);
}

float dragIndex = 0.0, maxDrag = 0.0;
float prevX = 0.0, zoom = 1.0;

void drawWorks() {
  compareViewElements.hide();
  pushMatrix();
  int fromY = Globals.FRAME_HEIGHT / 2,
    toY = Globals.FRAME_HEIGHT - 10;
  int fromX = 10,
    toX = Globals.FRAME_WIDTH - 10;

  if (mouseY >= Globals.FRAME_HEIGHT - 110) {
    cursor(HAND);
  }
  else {
    cursor(ARROW);
  }
  
  // translate(fromX, toY);
  //scale(zoom);

  
  // TODO: draw only the ones that are visible

  int numInViewPort = (int)(Globals.FRAME_WIDTH / (256*zoom));
  maxDrag = (Globals.works.size() - numInViewPort) * (256*zoom);
  for (int i = 0; i < Globals.works.size(); i++) {
    boolean left = fromX + dragIndex + (i+1)*(256*zoom) > 0;
    boolean right = fromX + dragIndex + (i+1)*(256*zoom) < Globals.FRAME_WIDTH;

    // optimization
    if (!left && !right) { continue; }
    
    pushMatrix();
    translate(fromX + dragIndex + i*(256*zoom), toY -100);
    plotWork(0, 0, 256*zoom, i); 
    popMatrix();
    
    //plotWork(dragIndex + i*256, -100, i); // TODO: relative size (use zoom)
  }
  
  popMatrix();
  prevX = mouseX;
}

void mouseClicked() {
  if (mouseY >= Globals.FRAME_HEIGHT - 110) {
    int fromX = 10;
    for (int i = 0; i < Globals.works.size(); i++) {
      float bottom = fromX + dragIndex + i*(256*zoom),
        top = fromX + dragIndex + (i + 1)*(256*zoom);
      if (mouseX >= bottom  && mouseY < top) {
        println(i);
        println(Globals.author.getJSONArray("works").getJSONObject(i));
      }
    }
  }
}

void mouseDragged() { // TODO: more smooth
  dragIndex += (mouseX - prevX);
  if (dragIndex > 0) {
    dragIndex = 0;
  }
  if (dragIndex < -maxDrag) {
    dragIndex = -maxDrag;
  }
}

void mouseWheel(MouseEvent event) {
  zoom -= (0.1 * event.getCount());
  if (zoom < 0.3) { zoom = 0.3; }
  else if (zoom > 1.5) { zoom = 1.5; }
}


void plotWork(float xStart, float yStart, float graphWidth, int workId) {
  JSONObject work = Globals.works.getJSONObject(workId);
  JSONObject meta = Globals.author.getJSONArray("works").getJSONObject(workId);
  
  colorMode(RGB);
  String[] chans = {"r", "g", "b"};
  int[][] colors = {
    new int[] {255, 0, 0}, new int[] {0, 255, 0}, new int[] {0, 0, 255}
  };
  pushMatrix();
  translate(xStart, yStart);
  scale(zoom);

  float maxRGB = work.getFloat("maxRGB");
  for (int ch=0; ch < 3; ch++) {
    float prevX = 0, prevY = 0;
    JSONArray data = work.getJSONArray(chans[ch]);

    strokeWeight(1/zoom);
    stroke(colors[ch][0], colors[ch][1], colors[ch][2]);
    noFill();
    //
    beginShape();
    //
      
    for (int col=0; col < 256; col++) {
      float size = data.getInt(col) / maxRGB * 100*zoom;
      float newX = col, newY = - size;
      //point(xStart + col, yStart + (size/10));
      //line(prevX, prevY, newX, newY);

			//
      curveVertex(newX, newY);
      //
      
      prevX = newX;
      prevY = newY;
    }
    //
    endShape();
    //

  }
  popMatrix();

  float textX = xStart + graphWidth/2, textY1 = yStart + 30, textY2 = yStart + 60;
  if (zoom >= 0.7) {
    textAlign(CENTER);
    textFont(font);

    String top = Globals.makeShorter(meta.getString("title"), (int)(35*zoom));
    String bottom = Globals.makeShorter(meta.getString("year") + 
                                        " - " + meta.getString("teh"),
                                        (int)(35*zoom));
    
    text(top, textX, textY1);
    text(bottom, textX, textY2);
  }
  else if (zoom >= 0.4 || zoom >= 0.2 && meta.getString("year").length() <= 6) {
    text(meta.getString("year"), textX, textY2);
  }
  else {
    text("…", textX, textY2);
  }
}

