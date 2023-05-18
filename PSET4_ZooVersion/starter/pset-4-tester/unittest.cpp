

#include <iostream>
#include <vector>
#include <string>
#include "LinkedList.h"
using namespace std;

/* TESTS:

values = using LinkedList::getNextStation to check list
length = using LinkedList::getLength to check list
currpos = ensuring correct NULL behavior

test1 - parameterized constructor
test2 - Station::isEqual
test3 - LinkedList::insertStation ------------- values
test4 - LinkedList::insertStation ------------- length
test5 - LinkedList::removeStation ------------- length
test6 - LinkedList::removeStation from front -- values
test7 - LinkedList::removeStation from middle - values
test8 - LinkedList::removeStation from back --- values
test9 - LinkedList::removeStation curr -------- currpos
test10 - LinkedList::empty -------------------- currpos
*/

int test1_num_failed(bool print);
int test2_num_failed(bool print);
int test3_num_failed(bool print);
int test4_num_failed(bool print);
int test5_num_failed(bool print);
int test6_num_failed(bool print);
int test7_num_failed(bool print);
int test8_num_failed(bool print);
int test9_num_failed(bool print);
int test10_num_failed(bool print);
bool check_e(int test, char part, int input, int expected, bool print);
bool check_a(int test, char part, bool assertion, bool print);
void printPass(int test);
void printFail(int test, int failed, int expected);

int main()
{
	streambuf *orig_buf = cout.rdbuf();
	cout.rdbuf(NULL);

	// test1
	if (test1_num_failed(true) == 0)
		printPass(1);
	else
		printFail(1, test1_num_failed(false), 4);

	// test2
	if (test2_num_failed(true) == 0)
		printPass(2);
	else
		printFail(2, test2_num_failed(false), 5);

	// test3
	if (test3_num_failed(true) == 0)
		printPass(3);
	else
		printFail(3, test3_num_failed(false), 5);

	// test4
	if (test4_num_failed(true) == 0)
		printPass(4);
	else
		printFail(4, test4_num_failed(false), 5);

	// test5
	if (test5_num_failed(true) == 0)
		printPass(5);
	else
		printFail(5, test5_num_failed(false), 6);

	// test6
	if (test6_num_failed(true) == 0)
		printPass(6);
	else
		printFail(6, test6_num_failed(false), 4);

	// test7
	if (test7_num_failed(true) == 0)
		printPass(7);
	else
		printFail(7, test7_num_failed(false), 4);

	// test8
	if (test8_num_failed(true) == 0)
		printPass(8);
	else
		printFail(8, test8_num_failed(false), 4);

	// test9
	if (test9_num_failed(true) == 0)
		printPass(9);
	else
		printFail(9, test9_num_failed(false), 2);

	// test10
	if (test10_num_failed(true) == 0)
		printPass(10);
	else
		printFail(10, test10_num_failed(false), 2);

	cout.rdbuf(orig_buf);
}

int test1_num_failed(bool print)
{
	int failed = 0;
	int test = 1;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);

	if (check_a(test, part++, s1.getName() == "station1", print)) // check list
		failed++;

	if (check_a(test, part++, s2.getName() == "station2", print)) // check list
		failed++;

	if (check_a(test, part++, s1.getAccess() == true, print)) // check list
		failed++;

	if (check_a(test, part++, s2.getAccess() == false, print)) // check list
		failed++;

	return failed;
}

int test2_num_failed(bool print)
{
	int failed = 0;
	int test = 2;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station1", true);

	Station s3("station3", true);
	Station s4("station4", true);

	Station s5("station5", true);
	Station s6("station5", false);

	if (check_a(test, part++, s1.isEqual(s2), print)) // check list
		failed++;

	if (check_a(test, part++, s2.isEqual(s1), print)) // check list
		failed++;

	if (check_a(test, part++, !s3.isEqual(s4), print)) // check list
		failed++;

	if (check_a(test, part++, !s4.isEqual(s3), print)) // check list
		failed++;

	if (check_a(test, part++, !s5.isEqual(s6), print)) // check list
		failed++;

	return failed;
}

int test3_num_failed(bool print)
{
	int failed = 0;
	int test = 3;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	if (check_e(test, part++, list.getLength(), 1, print))
		failed++;

	list.insertStation(s2);
	if (check_e(test, part++, list.getLength(), 2, print))
		failed++;

	list.insertStation(s3);
	if (check_e(test, part++, list.getLength(), 3, print))
		failed++;

	list.insertStation(s4);
	if (check_e(test, part++, list.getLength(), 4, print))
		failed++;

	list.insertStation(s5);
	if (check_e(test, part++, list.getLength(), 5, print))
		failed++;

	return failed;
}

int test4_num_failed(bool print)
{
	int failed = 0;
	int test = 4;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	list.insertStation(s2);
	list.insertStation(s3);
	list.insertStation(s4);
	list.insertStation(s5);

	Station temp;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s5.getName() && temp.getAccess() == s5.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s4.getName() && temp.getAccess() == s4.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s3.getName() && temp.getAccess() == s3.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s2.getName() && temp.getAccess() == s2.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s1.getName() && temp.getAccess() == s1.getAccess(), print)) // check list
		failed++;

	return failed;
}

int test5_num_failed(bool print)
{
	int failed = 0;
	int test = 5;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	list.insertStation(s2);
	list.insertStation(s3);
	list.insertStation(s4);
	list.insertStation(s5);
	if (check_e(test, part++, list.getLength(), 5, print))
		failed++;

	list.removeStation(s1);
	if (check_e(test, part++, list.getLength(), 4, print))
		failed++;

	list.removeStation(s2);
	if (check_e(test, part++, list.getLength(), 3, print))
		failed++;

	list.removeStation(s3);
	if (check_e(test, part++, list.getLength(), 2, print))
		failed++;

	list.removeStation(s4);
	if (check_e(test, part++, list.getLength(), 1, print))
		failed++;

	list.removeStation(s5);
	if (check_e(test, part++, list.getLength(), 0, print))
		failed++;

	return failed;
}

// front remove + getNextStation
int test6_num_failed(bool print)
{
	int failed = 0;
	int test = 6;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	list.insertStation(s2);
	list.insertStation(s3);
	list.insertStation(s4);
	list.insertStation(s5);

	list.removeStation(s5);

	Station temp;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s4.getName() && temp.getAccess() == s4.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s3.getName() && temp.getAccess() == s3.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s2.getName() && temp.getAccess() == s2.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s1.getName() && temp.getAccess() == s1.getAccess(), print)) // check list
		failed++;

	return failed;
}

// middle remove + getNextStation
int test7_num_failed(bool print)
{
	int failed = 0;
	int test = 7;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	list.insertStation(s2);
	list.insertStation(s3);
	list.insertStation(s4);
	list.insertStation(s5);

	list.removeStation(s3);

	Station temp;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s5.getName() && temp.getAccess() == s5.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s4.getName() && temp.getAccess() == s4.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s2.getName() && temp.getAccess() == s2.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s1.getName() && temp.getAccess() == s1.getAccess(), print)) // check list
		failed++;

	return failed;
}

// last remove + getNextStation
int test8_num_failed(bool print)
{
	int failed = 0;
	int test = 8;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	list.insertStation(s2);
	list.insertStation(s3);
	list.insertStation(s4);
	list.insertStation(s5);

	list.removeStation(s1);

	Station temp;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s5.getName() && temp.getAccess() == s5.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s4.getName() && temp.getAccess() == s4.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s3.getName() && temp.getAccess() == s3.getAccess(), print)) // check list
		failed++;

	temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s2.getName() && temp.getAccess() == s2.getAccess(), print)) // check list
		failed++;

	return failed;
}

// removing + check currpos = NULL
int test9_num_failed(bool print)
{
	int failed = 0;
	int test = 9;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);

	list.insertStation(s1);
	list.insertStation(s2);

	Station temp = list.getNextStation();
	if (check_a(test, part++, temp.getName() == s2.getName() && temp.getAccess() == s2.getAccess(), print))
		failed++;

	list.removeStation(s1);

	if (check_a(test, part++, list.isCurrPosNull(), print)) // check list
		failed++;

	return failed;
}

// make empty + check currpos = NULL
int test10_num_failed(bool print)
{
	int failed = 0;
	int test = 10;
	char part = 'a';

	LinkedList list;
	Station s1("station1", true);
	Station s2("station2", false);
	Station s3("station3", true);
	Station s4("station4", false);
	Station s5("station5", true);

	list.insertStation(s1);
	list.insertStation(s2);
	list.insertStation(s3);
	list.insertStation(s4);
	list.insertStation(s5);

	list.makeEmpty();

	if (check_e(test, part++, list.getLength(), 0, print))
		failed++;

	if (check_a(test, part++, list.isCurrPosNull(), print)) // check list
		failed++;

	return failed;
}

// UTILITIES //

void printPass(int test)
{
	cerr << "test" << test << " passed!" << endl;
}

void printFail(int test, int failed, int expected)
{
	cerr << "test" << test << " failed " << failed << " / " << expected << " parts." << endl;
}

bool check_e(int test, char part, int input, int expected, bool print)
{
	if (input != expected)
	{
		if (print)
			cerr << "test" << test << " part " << part << " failed. Expected "
				 << expected << " but got " << input << "." << endl;
		return true;
	}
	return false;
}

bool check_a(int test, char part, bool assertion, bool print)
{
	if (!assertion)
	{
		if (print)
		{
			cerr << "test" << test << " part " << part << " failed. Expected "
				 << "true"
				 << " but got "
				 << "false"
				 << "." << endl;
		}
		return true;
	}
	return false;
}