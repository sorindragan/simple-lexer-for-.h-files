class Date{
// today
public:
	int day, month, year;
	Date();
	float getDate (int x, int y, int z);
	~Date();
	
};

class Time{
// current time
private:
	int x;

protected:
	Time( double time);
	int setTime(int x);
	int setTime(int *x, int *y);
	int getTime();
	Time spaceTime( Time stamp);
};
