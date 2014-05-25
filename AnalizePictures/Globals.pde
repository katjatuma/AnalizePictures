static class Globals {
  // Constants
  public static final long[] h1 = new long[361];
  public static final long[] s1 = new long[361];
  public static final long[] b1 = new long[361];

  public static final int FRAME_WIDTH = 1400, FRAME_HEIGHT = 800;
  public static final String DATA_DIR = "../data/";

  // Data
  public static String authorId = "";
  public static JSONObject author;
  public static JSONArray works;

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
      newText += "...";
    }
    return newText;
  }
}
