
if [ $1 = "obelix" ]; then

	ssh zalbiraw@obelix.gaul.csd.uwo.ca

elif [ $1 = "gaul" ]; then

	if [ $2 = "joust" ]; then

		ssh joust.gaul.csd.uwo.ca
	
	elif [ $2 = "hack" ]; then

		ssh hack.gaul.csd.uwo.ca
	
	elif [ $2 = "tron" ]; then

		ssh tron.gaul.csd.uwo.ca
	
	elif [ $2 = "rogue" ]; then

		ssh rogue.gaul.csd.uwo.ca
	
	elif [ $2 = "zork" ]; then

		ssh zork.gaul.csd.uwo.ca
	
	elif [ $2 = "pong" ]; then

		ssh pong.gaul.csd.uwo.ca

	else 

		echo "please provide a server name:\n - joust\n - hack\n - tron\n - rogue\n - zork\n - pong"	

	fi

elif [ $1 = "up" ]; then

	export CUDAROOT=/usr/local/cuda-8.0/
	export PATH=$CUDAROOT/bin/:$PATH
	export LD_LIBRARY_PATH=$CUDAROOT/lib:$LD_LIBRARY_PATH
	export LD_LIBRARY_PATH=$CUDAROOT/lib64:$LD_LIBRARY_PATH

else

	echo "please provide an argument:\n - obelix\n - gaul\n - upset"

fi