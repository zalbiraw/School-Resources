if [ ! -z "$1" ]; then
	mkdir -p output/compressed output/images output/stats
	# printf "encoding $1.$2"
	# time 
	./encode images/$1.pgm $2 output/compressed/$1.$2.lz77
	# printf "decoding $1.$2"
	# time
	./decode output/compressed/$1.$2.lz77 output/images/$1.$2.pgm
	# python histograms.py $1 $2
else
	sh report.sh boats 256
	sh report.sh boats 1024
	sh report.sh boats 5120

	sh report.sh camera 256
	sh report.sh camera 1024
	sh report.sh camera 5120
fi