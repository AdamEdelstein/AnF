class Score
{
  int a;

  Score(int a_)
  {
    a = a_;
  }

  void display()
  {
    textFont(font);
    textSize(45);
    fill(0);
    text("Score:  "+a, 690, 38);
  }
  void addScore(int m)
  {
    a+=m;
  }
}

