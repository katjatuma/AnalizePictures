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
DropdownList ddAuthors;
int cnt = 0;

Group compareViewElements;
Group worksViewElements;

boolean drawChanges = true;

void setup() {
  size(Fwidth, Fheight);

  cp5 = new ControlP5(this);

  compareViewElements = cp5.addGroup("g1").setPosition(0,0);
  worksViewElements = cp5.addGroup("g2").setPosition(0,0);
  
  //dropdowns
  ddAuthors = cp5.addDropdownList("authors")
    .setLabel("Select an author to analyze")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(Globals.FRAME_WIDTH - 210, 40)
    .setGroup(worksViewElements)
    ;
  for (int i=0; i<Globals.AUTHOR_NAMES.length; i++) {
    ddAuthors.addItem(Globals.AUTHOR_NAMES[i], i);
  }
  customize(ddAuthors);
  
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
  cp5.addButton("back")
    .setValue(0)
    .setLabel("Return")
    .setPosition(Globals.FRAME_WIDTH - Globals.buttonWidth - 10, 15)
    .setSize(Globals.buttonWidth, Globals.buttonHeight)
    .setGroup(compareViewElements)
    .addCallback(new CallbackListener() {
        public void controlEvent(CallbackEvent event) {
          if (event.getAction() == ControlP5.ACTION_RELEASED) {
            Globals.selectedWork1 = -1;
            Globals.selectedWork2 = -1;
            img1 = null;
            img2 = null;
            Globals.viewMode = Globals.VIEW_MODE_WORKS;
            drawChanges = true;
          }
        }
      })
    ;
  
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
//  for (int i=0;i<40;i++) {
//    ddl.addItem("item "+i, i);
//  }
  ddl.scroll(0);
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void controlEvent(ControlEvent theEvent) {
  String element = null;
  float value = 0.0;
  if (theEvent.isGroup()) {
    // check if the Event was triggered from a ControlGroup
    println("event from group : "+theEvent.getGroup().getValue()+" from "+theEvent.getGroup());
    element = theEvent.getGroup().getName();
    value = theEvent.getGroup().getValue();
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getController());
    value = theEvent.getController().getValue();
    element = theEvent.getController().getName();
  }
  if (element == null) { return; }

  if (element.equals("authors")) {
    println("reinit");
    zoom = 1.0;
    drawChanges = true;
    dragIndex = 0.0;
    prepareData(Globals.AUTHORS[(int)value]);
  }
  drawChanges = true;
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
  if (!drawChanges) { return; }
  drawChanges = false;
  
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
  String imgDir = Globals.DATA_DIR + Globals.authorId + "/";
  
  JSONObject work1 = Globals.works.getJSONObject(Globals.selectedWork1);
  JSONObject workMeta1 = Globals.author.getJSONArray("works").getJSONObject(Globals.selectedWork1);
  JSONObject work2 = Globals.works.getJSONObject(Globals.selectedWork2);
  JSONObject workMeta2 = Globals.author.getJSONArray("works").getJSONObject(Globals.selectedWork2);

  if (img1 == null) {
    img1 = loadImage(imgDir + workMeta1.getString("large"));
    img1.resize(0,200);
  }
  if (img2 == null) {
    img2 = loadImage(imgDir + workMeta2.getString("large"));
    img2.resize(0,200);
  }

  compareViewElements.show();
  worksViewElements.hide();
  
  //draw line
  stroke(212,212,210);
  line(Fwidth/2,Globals.buttonWidth + Globals.buttonHeight,Fwidth/2,Fheight/2);
  
  imageMode(CENTER);
  image(img1,Fwidth/4,Fheight/4 + Globals.imageMargin);
  image(img2,(Fwidth/4)*3,Fheight/4 + Globals.imageMargin);
}

float dragIndex = 0.0, maxDrag = 0.0;
float prevX = 0.0, zoom = 1.0;

void drawWorks() {
  compareViewElements.hide();
  worksViewElements.show();
  
  pushMatrix();
  int fromY = Globals.FRAME_HEIGHT / 2,
    toY = Globals.FRAME_HEIGHT - 10;
  int fromX = 10,
    toX = Globals.FRAME_WIDTH - 10;

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
  if (Globals.selectedWork1 >= 0 && Globals.selectedWork2 >= 0) {
    Globals.viewMode = Globals.VIEW_MODE_COMPARE;
    drawChanges = true;
  }
}

void mouseClicked() {
  if (mouseY >= Globals.FRAME_HEIGHT - 110) {
    drawChanges = true;
    int fromX = 10;
    for (int i = 0; i < Globals.works.size(); i++) {
      float left = fromX + dragIndex + i*(256*zoom),
        right = fromX + dragIndex + (i + 1)*(256*zoom);
      if (mouseX >= left && mouseX < right) {
        if (Globals.selectedWork1 < 0 || i == Globals.selectedWork1) {
          Globals.selectedWork1 = i;
        } else if (Globals.selectedWork2 < 0) {
          Globals.selectedWork2 = i;
          
        }
        break;
      }
    }
  }
}

void mouseDragged() { // TODO: more smooth
  drawChanges = true;
  dragIndex += (mouseX - prevX);
  if (dragIndex > 0) {
    dragIndex = 0;
  }
  if (dragIndex < -maxDrag) {
    dragIndex = -maxDrag;
  }
}

void mouseWheel(MouseEvent event) {
  drawChanges = true;
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

  textAlign(CENTER);
  if (Globals.selectedWork1 == workId || Globals.selectedWork2 == workId) {
    fill(110,20,30);
  } else {
    fill(0,150,253);
  }
  textFont(font);
  
  if (zoom >= 0.7) {
    
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

