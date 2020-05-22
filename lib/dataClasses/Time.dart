class Time{
  int hours = 0;
  int mins = 0;
  int sex = 0;

  Time(int hours, int mins,int sex){
    this.hours = hours;
    this.mins = mins;
    this.sex = sex;
  }

  bool equals(int hour, int min, int sec){
    if(hour == this.hours && min == this.mins && sec == this.sex){
      return true;
    }
    return false;
  }
}