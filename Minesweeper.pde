import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList < MSButton > bombs = new ArrayList < MSButton > (); //ArrayList of just the minesweeper buttons that are mined

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make(this);
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int j = 0; j < NUM_ROWS; j++) {
    for (int k = 0; k < NUM_COLS; k++) {
      buttons[j][k] = new MSButton(j, k);
    }
  }
  //declare and initialize buttons
  setBombs();
}
public void setBombs() {
  for (int i = 0; i < NUM_BOMBS; i++) {
    int aRow = (int)(Math.random() * NUM_ROWS);
    int aCol = (int)(Math.random() * NUM_COLS);
    if (!bombs.contains(buttons[aRow][aCol])) {
      bombs.add(buttons[aRow][aCol]);
    }
  }
}

public void draw() {
  background(0);
  if (isWon())
    displayWinningMessage();
}
public boolean isWon()
{
  int markBombs= 0;
  for (int i = 0; i < bombs.size(); i++)
  {
    if (bombs.get(i).isMarked() == true)
    {
      markBombs++;
    }
  }
  if (markBombs == bombs.size())
  {
    return true;
  }
  for (int i = 0; i < bombs.size(); i++)
  {
    if (bombs.get(i).isClicked() == true)
    {
      displayLosingMessage();
    }
  }
  return false;
}
public void displayLosingMessage() {
  //your code here
  for (int i=0; i<bombs.size(); i++)
  {
    bombs.get(i).setClicked(true);
  }
  buttons[10][8].setLabel("N");
  buttons[10][9].setLabel("I");
  buttons[10][10].setLabel("C");
  buttons[10][11].setLabel("E");
  buttons[11][8].setLabel("T");
  buttons[11][9].setLabel("R");
  buttons[11][10].setLabel("Y");
  buttons[11][11].setLabel("!");
}
public void displayWinningMessage() {
  //your code here
  buttons[10][8].setLabel("N");
  buttons[10][9].setLabel("I");
  buttons[10][10].setLabel("C");
  buttons[10][11].setLabel("E");
  buttons[11][8].setLabel("J");
  buttons[11][9].setLabel("O");
  buttons[11][10].setLabel("B");
  buttons[11][11].setLabel("!");
}

public class MSButton {
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton(int rr, int cc) {
    width = 400 / NUM_COLS;
    height = 400 / NUM_ROWS;
    r = rr;
    c = cc;
    x = c * width;
    y = r * height;
    label = "";
    marked = clicked = false;
    Interactive.add(this); // register it with the manager
  }
  public boolean isMarked() {
    return marked;
  }
  public boolean isClicked() {
    return clicked;
  }
  // called by manager
  public void setClicked(boolean cClicked)
  {
    clicked = cClicked;
  }

  public void mousePressed () 
  {
    if (mouseButton == LEFT)
    {
      if (clicked == false)
      {
        clicked = true;
        if (keyPressed == true)
        {
          marked = !marked;
        } else if (bombs.contains(this))
        {
          displayLosingMessage();
        } else if (countBombs(r, c)>0)
        {
          label = label + countBombs(r, c);
          //                    println("label");
        } else
        {
          for (int i=-1; i<2; i++)
          {
            for (int j=-1; j<2; j++)
            {
              if (isValid(r+i, c+j)==true)
              {
                if (buttons[r+i][c+j].isClicked()==false)
                {
                  buttons[r+i][c+j].mousePressed();
                }
              }
            }
          }
        }
      }
    }
    if (mouseButton==RIGHT)
    {
      if (clicked == false)
      {
        marked=!marked;
      }
    }
  }


  public void draw() {
    if (marked)
      fill(0, 255, 0);
    else if (clicked && bombs.contains(this))
      fill(255, 0, 0);
    else if (clicked)
      fill(200);
    else
      fill(100);

    rect(x, y, width, height);
    fill(0);
    text(label, x + width / 2, y + height / 2);
  }
  public void setLabel(String newLabel) {
    label = newLabel;
  }
  public boolean isValid(int r, int c) {
    if ((r > -1 && r < NUM_ROWS) && (c > -1 && c < NUM_COLS)) {
      return true;
    }
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for (int i=-1; i<2; i++)
    {
      for (int j=-1; j<2; j++)
      {
        if (isValid(row+i, col+j)==true)
        {
          if (bombs.contains(buttons[row+i][col+j]))
          {
            numBombs++;
          }
        }
      }
    }
    return numBombs;
  }
}