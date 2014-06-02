/*
zanekrat delam na dveh statičnih slikah, ne najdem primerne baze
*/
PFont font = createFont("Arial", 16,true);
PFont font24 = createFont("Arial", 24,true);
PFont fontSmall = createFont("Arial", 12,true);
PFont fontTiny = createFont("Arial", 5,true); 
int Fwidth = Globals.FRAME_WIDTH;
int Fheight = Globals.FRAME_HEIGHT;
PImage img1;
PImage img2;

import controlP5.*;
ControlP5 cp5;
DropdownList d1, d2, d3, d4;
DropdownList ddAuthors, ddAbsolute;
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
    .setPosition(Globals.FRAME_WIDTH - Globals.boderLeftDD - 10, 40)
    .setGroup(worksViewElements)
    ;
  ddAbsolute = cp5.addDropdownList("absolute")
    .setLabel("Data display (absolute)")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(10, 40)
    .setGroup(worksViewElements)
    ;
  for (int i=0; i<Globals.AUTHOR_NAMES.length; i++) {
    ddAuthors.addItem(Globals.AUTHOR_NAMES[i], i);
  }
  ddAbsolute.addItem("Absolute", 0);
  ddAbsolute.addItem("Relative", 1);
  
  customize(ddAuthors);
  customize(ddAbsolute);
  
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
    prepareData(Globals.AUTHORS[(int)value]);
  } else if (element.equals("absolute")) {
    Globals.histRelative = (int)value == 1;
  }
  drawChanges = true;
}

void prepareData(String author) {
  Globals.authorId = author;
  Globals.author = loadJSONObject(Globals.DATA_DIR + author + ".json");


  Globals.works = new JSONArray();
  JSONArray worksMeta = Globals.author.getJSONArray("works");

  Globals.maxHG = -1;
  for (int i = 0; i < worksMeta.size(); i++) {
    String id = worksMeta.getJSONObject(i).getString("id");
    String path = Globals.DATA_DIR + author + "/" + id + ".json";
    JSONObject data = loadJSONObject(path);
    Globals.works.setJSONObject(i, data);
   
    Globals.maxHG = (float)Math.max(Globals.maxHG, data.getInt("maxHG"));
  }
}


void draw() {
  if (!drawChanges) { return; }
  drawChanges = false;

  background(255);  

  textFont(font);

  if (Globals.viewMode == Globals.VIEW_MODE_WORKS) {
    drawWorks();
  } else {
    drawCompare();
  }
  
  colorMode(RGB);
  fill(255, 255, 255);
  noStroke();
  rect(0, 0, Globals.FRAME_WIDTH, Globals.TOP_HEIGHT);
  
  fill(0,150,253);
  textFont(font);
  textAlign(CENTER);
  text("Analizing and comparing works of art",(Fwidth/2), 20);
  textFont(font24);
  text(Globals.author.getString("name"),(Fwidth/2), 50);

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

float zoom = 1.0, dragIndex = 0.0,
  maxDrag = 0.0;

void drawWorks() {
  compareViewElements.hide();
  worksViewElements.show();
  
  int fromY = Globals.TOP_HEIGHT + 10,
    toY = Globals.FRAME_HEIGHT - 10;
  int fromX = 10,
    toX = Globals.FRAME_WIDTH - 10;

  int numDisplayed = (int)(Globals.FRAME_HEIGHT / Globals.WORK_HEIGHT * zoom);
  maxDrag = (Globals.works.size() - numDisplayed + 1) * Globals.WORK_HEIGHT * zoom;
  
  pushMatrix();
  translate(fromX, fromY - dragIndex);
  for (int i = 0; i < Globals.works.size(); i++) {
    pushMatrix();
    translate(0, i*Globals.WORK_HEIGHT*zoom);
    scale(zoom);
    
    plotWork(0, 0, toX - toY, i);
    popMatrix();
  }
  popMatrix();

  if (Globals.selectedWork1 >= 0 && Globals.selectedWork2 >= 0) {
    Globals.viewMode = Globals.VIEW_MODE_COMPARE;
    drawChanges = true;
  }
}


void mouseClicked() {
}
float prevY = 0;
void mouseDragged() { // TODO: more smooth
  dragIndex -= (mouseY - prevY);// > 0 ? 10 : -10;
  prevY = mouseY;
  if (dragIndex > maxDrag) { dragIndex = maxDrag; }
  if (dragIndex < 0) { dragIndex = 0; }
  drawChanges = true;
}

void mouseMoved() {
  prevY = mouseY;
}

void mouseWheel(MouseEvent event) {
  drawChanges = true;
  zoom -= (0.1 * event.getCount());
  if (zoom < Globals.MIN_ZOOM) { zoom = Globals.MIN_ZOOM; }
  else if (zoom > Globals.MAX_ZOOM) { zoom = Globals.MAX_ZOOM; }
}


void plotWork(float xStart, float yStart, float graphWidth, int workId) {
  JSONObject work = Globals.works.getJSONObject(workId);
  JSONObject meta = Globals.author.getJSONArray("works").getJSONObject(workId);
  
  plotHue(work, Globals.WORK_HEIGHT * 0.95, zoom);
}

void plotHue(JSONObject work, float pHeight) {
  plotHue(work, pHeight, 1.0);
}
void plotHue(JSONObject work, float pHeight, float intZoom) {
  JSONObject grayhist = work.getJSONObject("grayhist");
  JSONObject huehist = work.getJSONObject("huehist");

  strokeWeight(1/intZoom);
  stroke(0);
  textAlign(CENTER);
  textFont(fontTiny);
  colorMode(HSB);
  float xPos = 0, colWidth = 254.0/(Globals.NUM_OF_HUES+Globals.NUM_OF_GRAYS),
    colHeight = pHeight;// * intZoom;
  
  float maxHG = Globals.histRelative ? work.getInt("maxHG") : Globals.maxHG;
  
  for (float h = 0; h < Globals.NUM_OF_HUES; h++) {
    float num = h >= 0 ? (float)huehist.getInt(""+(int)h, 0) : 0;
    float cSize = num / maxHG * colHeight;
    fill(h/Globals.NUM_OF_HUES * 255, 255, 255);
    rect(xPos, pHeight - cSize, colWidth, cSize);
    if (intZoom >= 1.5) {
      fill(0, 0, 0);
      text(""+(int)num, xPos + colWidth / 2, pHeight - cSize - 5);
    }
    xPos += colWidth;
  }

  colorMode(RGB);
  for (int g = 0; g < Globals.NUM_OF_GRAYS; g += 1) {
    float gray = g * (255/Globals.NUM_OF_GRAYS);
    float num = gray >= 0 ? (float)grayhist.getInt(""+g, 0) : 0;
    float cSize = num / maxHG * colHeight;
    fill(gray, gray, gray);
    rect(xPos, pHeight - cSize, colWidth, cSize);
    if (intZoom > 1.4) {
      fill(0);
      text(""+(int)num, xPos + colWidth / 2, pHeight - cSize - 5);
    }
    xPos += colWidth;
  }
}
