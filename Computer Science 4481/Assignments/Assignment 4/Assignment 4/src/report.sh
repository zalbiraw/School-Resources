if [ ! -z "$1" ]; then
	mkdir -p output/compressed output/images output/stats
	# printf "encoding $1.$2"
	# time
	./encode images/$1.pgm $2 output/compressed/$1.$2.dpcm
	# printf "encoding $1.$2"
	# time 
	./decode output/compressed/$1.$2.dpcm output/images/$1.$2.pgm
	# python histograms.py $1 $2
else
	sh report.sh boats 1
	sh report.sh boats 2
	sh report.sh boats 3
	sh report.sh boats 4

	sh report.sh camera 1
	sh report.sh camera 2
	sh report.sh camera 3
	sh report.sh camera 4
fi