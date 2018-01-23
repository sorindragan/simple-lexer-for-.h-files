class Rectangle2 {
private:
	int width, height, diag;

protected:
	unsigned float z ; /* comment */

public:
	Rectangle2();
	int area (void);
	void draw(int x, int y, int w, int h);
	/* this is an
	useless comment */
	double perimeter (float l, float ll);
	Rectangle2 (float w, float h);
	void draw(float x, float y, float w, float h);
	void draw (float x, float y, double c);
	~Rectangle2() ;
	
};
