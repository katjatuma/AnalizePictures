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
    .setPosition(Globals.FRAME_WIDTH - 210, 40)
    .setGroup(worksViewElements)
    ;
  ddAbsolute = cp5.addDropdownList("absolute")
    .setLabel("Data display (absolute)")
    .setSize(Globals.boderLeftDD,Globals.boderLeftDD)
    .setPosition(Globals.FRAME_WIDTH - 210, 80)
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
    dragIndex = 0.0;
    prepareData(Globals.AUTHORS[(int)value]);
  } else if (element.equals("absolute")) {
    Globals.rgbRelative = (int)value == 1;
    Globals.histRelative = (int)value == 1;
  }
  drawChanges = true;
}

void prepareData(String author) {
  Globals.authorId = author;
  Globals.author = loadJSONObject(Globals.DATA_DIR + author + ".json");


  Globals.works = new JSONArray();
  JSONArray worksMeta = Globals.author.getJSONArray("works");
  Globals.maxRGB = -1;
  Globals.maxHG = -1;
  for (int i = 0; i < worksMeta.size(); i++) {
    String id = worksMeta.getJSONObject(i).getString("id");
    String path = Globals.DATA_DIR + author + "/" + id + ".json";
    JSONObject data = loadJSONObject(path);
    Globals.works.setJSONObject(i, data);
    Globals.maxRGB = (float)Math.max(Globals.maxRGB, data.getInt("maxRGB"));
    Globals.maxHG = (float)Math.max(Globals.maxHG, data.getInt("maxHG"));
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
  else if (zoom > 2.0) { zoom = 2.0; }
}


void plotWork(float xStart, float yStart, float graphWidth, int workId) {
  JSONObject work = Globals.works.getJSONObject(workId);
  JSONObject meta = Globals.author.getJSONArray("works").getJSONObject(workId);
  
  pushMatrix();
  translate(xStart, yStart);
  scale(zoom);
  
  plotRGB(work, Globals.plotHeight, zoom);
  translate(0, -(yStart + 2*Globals.plotHeight));
  plotHue(work, Globals.plotHeight, zoom);
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
    int num = (int)(35*zoom);
    String top = Globals.makeShorter(meta.getString("title"), num);
    String main = meta.getString("year") + " - " + meta.getString("teh");
    String bottom = Globals.makeShorter(main, num);
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

void plotRGB(JSONObject work, float pHeight) {
  plotRGB(work, pHeight, 1.0);
}

void plotRGB(JSONObject work, float pHeight, float intZoom) {
  colorMode(RGB);
  
  String[] chans = {"r", "g", "b"};
  int[][] colors = {
    new int[] {255, 0, 0}, new int[] {0, 255, 0}, new int[] {0, 0, 255}
  };
  float maxRGB = Globals.rgbRelative ? work.getFloat("maxRGB") : Globals.maxRGB;
  for (int ch=0; ch < 3; ch++) {
    JSONArray data = work.getJSONArray(chans[ch]);

    strokeWeight(1/intZoom);
    stroke(colors[ch][0], colors[ch][1], colors[ch][2]);
    noFill();

    beginShape();
    for (int col=0; col < 256; col++) {
      float size = data.getInt(col) / Globals.maxRGB * pHeight;
      float newX = col, newY = - size;
      curveVertex(newX, newY);
    }
    endShape();
  }
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
