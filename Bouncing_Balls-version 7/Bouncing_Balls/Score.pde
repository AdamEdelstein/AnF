class Score
{
  int a;

  Score(int a_)
  {
    a = a_;
  }

  void display()
  {
    textFont(font3);
    textSize(45);
    fill(6,198,197);

    text(a, 900, 90);  }
  void addScore(int m)
  {
    a+=m;
  }
}

