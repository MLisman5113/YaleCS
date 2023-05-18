#!/bin/bash

if [[ $1 =~ ^--?[hH](elp)? ]]; then
	less README.md
	exit 0
elif [[ $# -eq 1 ]]; then
	export SRCDIR=$1
elif [[ $# -gt 1 ]]; then
	echo "usage: $(basename $0) [source_directory]"
	exit 1
fi

mkdir -p output
rm -rf output/*

echo "~~compiling train-conductor~~"
make -e train-conductor &> output/student.compile

## check compilation
if [ -f ./train-conductor ]; then
	warnings=`grep -i "\(warning\|warnings\) generated" output/student.compile`
	if [ -z "$warnings" ]; then
		echo "No errors or warnings!"
	else
		echo "Warnings! Check output/student.compile!"
	fi
else
	echo "Errors! Check output/student.compile!"
	echo "Stopping tests."
	exit 1
fi

echo ""
./train-conductor > ./output/student.out

echo "~~running difftest~~"
diff ./ref/all_stations.txt ./output/all_stations.txt > ./output/all_stations.diff
if [ -s ./diff/all_stations.diff ]; then
	echo "all_stations failed!"
	echo "all_stations (first 50 chars):"
	head -c 50 ./output/all_stations.txt
	echo ""
	echo "Expected output  (first 50 chars):"
	head -c 50 ./ref/all_stations.txt
	echo ""
	echo "diff (first 50 chars)"
	head -c 50 ./output/all_stations.diff
	echo ""
else
	echo "all_stations passed!"
fi

echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

diff ./ref/remove_some.txt ./output/remove_some.txt > ./output/remove_some.diff
if [ -s ./diff/remove_some.diff ]; then
	echo "remove_some failed!"
	echo "remove_some (first 50 chars):"
	head -c 50 ./output/remove_some.txt
	echo ""
	echo "Expected output  (first 50 chars):"
	head -c 50 ./ref/remove_some.txt
	echo ""
	echo "diff (first 50 chars)"
	head -c 50 ./output/remove_some.diff
	echo ""
else
	echo "remove_some passed!"
fi

echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'

diff ./ref/output.out ./output/student.out > ./output/output.diff
if [ -s ./diff/output.diff ]; then
	echo "output failed!"
	echo "output (first 50 chars):"
	head -c 50 ./output/student.out
	echo ""
	echo "Expected output  (first 50 chars):"
	head -c 50 ./ref/output.out
	echo ""
	echo "diff (first 50 chars)"
	head -c 50 ./output/output.diff
	echo ""
else
	echo "output passed!"
fi
echo '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
echo ""

if ! command -v valgrind &> /dev/null; then
	echo "~~valgrind not found on this system...skipping valgrind~~"
else
	echo "~~running valgrind~~"
	timeout 600s valgrind ./train-conductor &> output/student.valgrind
	tail -n 14 output/student.valgrind
fi
echo ""

echo "~~running unittest~~"
make -e unittest &> output/unittest.compile
# checking compilation
if [ -f ./train-conductor ]; then
	warnings=`grep -i "\(warning\|warnings\) generated" output/unittest.compile`
	if [ ! -z "$warnings" ]; then
		echo "Warnings! Check output/unittest.compile!"
	fi
else
	echo "Errors! Check output/unittest.compile!"
	echo "Stopping tests."
	exit 1
fi

./unittest

echo ""
echo "~~cleaning up~~"
make clean
