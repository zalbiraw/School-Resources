if [ "$1" = "1" ]; then
	#test1 15 marks tests fork spawning
	./myOS shell ./tests/test1.txt &
	sleep 5
	ps > ./tests/processes.txt
	sleep 5
	if grep -q "myOS" "./tests/processes.txt" && grep -q "sleep" "./tests/processes.txt" ; then echo "Test 1 Succeeded" >> report.txt; else echo "Test 1 Failed" >> report.txt; fi
	rm ./tests/processes.txt

elif [ "$1" = "2" ]; then
	#test2 15 marks tests fork termination
	./myOS shell ./tests/test2.txt
	ps > ./tests/processes.txt
	if grep -q "ls" "./tests/processes.txt" ; then echo "Test 2 Failed" >> report.txt; else echo "Test 2 Succeeded" >> report.txt; fi
	rm ./tests/processes.txt

elif [ "$1" = "3" ]; then
	#test3 10 marks tests piping - 0 pipes
	./myOS shell ./tests/test3.txt
	ls > ./tests/answer.txt
	if diff ./tests/result.txt ./tests/answer.txt -q ; then echo "Test 3 Succeeded" >> report.txt; else echo "Test 3 Failed" >> report.txt; fi
	rm ./tests/result.txt ./tests/answer.txt

elif [ "$1" = "4" ]; then
	#test4 10 marks tests piping - 1 pipe
	./myOS shell ./tests/test4.txt
	cat ./tests/Tyrion/1.txt | sort > ./tests/answer.txt 
	if diff ./tests/result.txt ./tests/answer.txt -q ; then echo "Test 4 Succeeded" >> report.txt; else echo "Test 4 Failed" >> report.txt; fi
	rm ./tests/result.txt ./tests/answer.txt

elif [ "$1" = "5" ]; then
	#test5 10 marks tests piping - >1 pipe
	./myOS shell ./tests/test5.txt
	cat ./tests/Tyrion/2.txt | sort > ./tests/answer.txt 
	if diff ./tests/result.txt ./tests/answer.txt -q ; then echo "Test 5 Succeeded" >> report.txt; else echo "Test 5 Failed" >> report.txt; fi
	rm ./tests/result.txt ./tests/answer.txt

elif [ "$1" = "6" ]; then
	#test6 30 marks tests io - 10 for input, 10 for output and 10 for both together.
	./myOS shell ./tests/test6.txt
	sort < ./tests/Tyrion/1.txt > ./tests/answer.txt
	if diff ./tests/result.txt ./tests/answer.txt -q ; then echo "Test 6 Succeeded" >> report.txt; else echo "Test 6 Failed" >> report.txt; fi
	rm ./tests/result.txt ./tests/answer.txt

elif [ "$1" = "7" ]; then
	#test7 10 marks for graceful termination
	./myOS shell ./tests/test7.txt
	ps > ./tests/processes.txt
	cat ./tests/processes.txt
	if grep -q "myOS" "./tests/processes.txt" ; then echo "Test 7 Failed" >> report.txt; else echo "Test 7 Succeeded" >> report.txt; fi
	rm ./tests/processes.txt
fi

cat report.txt