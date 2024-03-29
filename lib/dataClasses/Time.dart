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

  int inSex(){
    return this.hours*3600 + this.mins * 60 + this.sex;
  }

  void set(Time newTime){
      this.hours = newTime.hours;
      this.mins = newTime.mins;
      this.sex = newTime.sex;
  }

  Time sex2Time(double sex){
    return Time(sex~/3600,(sex%3600)~/60,(sex.toInt()%3600)%60);
  }

  void decrease(Time subTime){  //TODO: fix, quick and dirty, can underflow
    if(subTime.inSex() > this.hours*3600 + this.mins*60 + this.sex){
      this.sex = 0;
      this.mins = 0;
      this.hours = 0;
      return;
    }

    this.sex -= subTime.sex;
    if(this.sex < 0){
      this.mins-= 1;
      this.sex +=60;
    }
    this.mins -= subTime.mins;
    if(this.mins < 0){
      this.hours-=1;
      this.mins+=60;
    }
    this.hours-= subTime.hours;
    /*if(this.hours < 0){
      this.hours+=24;
    }*/
  }

  Time operator +(Time other) {  // TODO: this is temp fix, add custom operators to time class for add, sub
    this.sex += other.sex;
    this.mins += other.mins;
    this.hours+= other.hours;

    this.mins += this.sex~/60;
    this.sex %= 60;
    this.hours += this.mins~/60;
    this.mins %= 60;
    this.hours %= 24;

    return this;
  }

  Time addSex(int sex){
    this.sex += sex;

    this.mins += this.sex~/60;
    this.sex %= 60;
    this.hours += this.mins~/60;
    this.mins %= 60;
    this.hours %= 24;
  }

  @override
  String toString() {
    return this.hours.toString()+':'+this.mins.toString()+':'+this.sex.toString();
  }
}