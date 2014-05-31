static class Globals {
  // Constants
  public static final int VIEW_MODE_WORKS = 1,
    VIEW_MODE_COMPARE=2;
  
  //dropdowns
  public static final int boderLeftDD = 200;
  public static final int bodertopDD = 100;
  //buttons
  public static final int buttonWidth = 50;
  public static final int buttonHeight = 20;
  public static final int spaceBetweenButtons = 3;
  //paintings
  public static final int imageMargin = 30;
  
  public static final int FRAME_WIDTH = 1400, FRAME_HEIGHT = 800;
  public static final String DATA_DIR = "../data/";
  public static final String[] AUTHORS = {
    "brugel"
  };
  public static final String[] AUTHOR_NAMES = {
    "Pieter Bruegel the Elder"
  };
  
  // Data
  public static int viewMode = VIEW_MODE_WORKS;
  public static String authorId = "";
  public static JSONObject author;
  public static JSONArray works;
  public static int selectedWork1 = -1;
  public static int selectedWork2 = -1;

  public static String makeShorter(String text, int maxLength) {
    int max = maxLength - 4;
    String[] words = text.split(" ");
    String newText = "";
    for (int i = 0; i < words.length; i++) {
      if (((newText + words[i]).length()+1) < max) {
        newText += " " + words[i];
      }
      else { break; }
    }
    if (newText.length() == 0) {
      newText = text.substring(0, max);
    }
    if (newText.length() < text.length()) {
      newText += "…";
    }
    return newText;
  }
}
