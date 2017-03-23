#Specify the version being used aswell as the language
cmake_minimum_required(VERSION 2.6)
#Name your project here
project(A2_Zaid_Albirawi)

#Sends the -std=c++11 flag to the g++ compiler
add_definitions(-std=c++11)
#Makes the executables
add_executable(P1 ../A2_Zaid_Albirawi/P1/P1.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)
add_executable(P2 ../A2_Zaid_Albirawi/P2/P2.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)
add_executable(P3 ../A2_Zaid_Albirawi/P3/P3.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)
add_executable(P4 ../A2_Zaid_Albirawi/P4/P4.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)
add_executable(P5 ../A2_Zaid_Albirawi/P5/P5.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)
add_executable(P6 ../A2_Zaid_Albirawi/P6/P6.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)
add_executable(P7 ../A2_Zaid_Albirawi/P7/P7.cpp ../A2_Zaid_Albirawi/Ngrams/fileRead.cpp)