/**
 * Processing_fadecandy_text.pde
 */

OPC opc;
PFont f;
PShader blur;

final int boxesAcross = 2;
final int boxesDown = 2;
final int ledsAcross = 8;
final int ledsDown = 8;
// initialized in setup()
float spacing;
int x0;
int y0;

void setup()
{
  size(480, 360, P2D);
  colorMode(HSB, 360, 100, 100);

  // Horizontal blur, from the SepBlur Processing example
  blur = loadShader("blur.glsl");
  blur.set("blurSize", 50);
  blur.set("sigma", 8.0f);
  blur.set("horizontalPass", 1);

  // Connect to the local instance of fcserver. You can change this line to connect to another computer's fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map 8x8 grids of LEDs to the center of the window, scaled to take up most of the space
  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;

  final int boxCentre = (int)((ledsAcross - 1) / 2.0 * spacing); // probably using the centre in the ledGrid8x8 method
  int ledCount = 0;
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross + boxCentre, y0 + spacing * y * ledsDown + boxCentre, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }

  // for (String fName : PFont.list()) { println(fName); };
  // Create the font
  f = createFont("MS Reference Sans Serif", spacing * (ledsDown + 0.50)); // Futura
  textFont(f);
}


void scrollMessageTop(String s, float speed)
{
  int x = int( width + (millis() * -speed) % (textWidth(s) + width) );
  int y = (int)(y0 + spacing * (ledsDown - 0.8));
  text(s, x, y);
}

void scrollMessageBot(String line2, float speed)
{
  int x = int( width + (millis() * -speed) % (textWidth(line2) + width) );
  int y = (int)(y0 + spacing * (boxesDown * ledsDown - 0.8));
  text(line2, x, y);
}

void draw()
{
  background(0);

  int hueExtent = 8 * 360 / 7;
  int rotateSecs = 30;
  int hue = (int) (((float)hueExtent / (rotateSecs * 1000) * millis()) % hueExtent);
  fill(hue, 80, 100);

  scrollMessageTop("abcde fghij klmno pqrst uvwxyz", 0.18);
  scrollMessageBot("ABCDE FGHIJ KLMNO PQRST UVWXYZ 0123456789 £$%^&*#@?<>", 0.06);

// On Ras Pi comment out, as for Processing 3.5.3 gives:
// RuntimeException: Cannot link shader program:
// ERROR:OPTIMIZER-3 (fragment shader, line 52) Support for for loops is restricted : right side of condition expression must be constant
  filter(blur); 
}
