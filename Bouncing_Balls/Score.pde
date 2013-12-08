class Score
{
  int a;
  color col = color(6, 198, 197);

  Score(int a_)
  {
    a = a_;
  }

  void display()
  {
    textFont(font3);
    textSize(45);
    fill(col);
    text(a, 920, 87);
  }

  void addScore(int m)
  {
    a+=m;
  }
}

