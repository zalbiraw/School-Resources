import random
import os

network_id = '129.100'
network_size = 65536
X = 10

i = 0
j = 0
L = []
A = []

while i < X:
  host_id = ("%d.%d" % (random.randint(0,255), random.randint(0,255)))
  
  if (host_id not in L):
	L.append(host_id)

	res = os.system("ping -c 2 -W 2 -o " + "%s.%s" % (network_id, host_id))

	if res == 0:
		j += 1
		A.append(host_id)

	i += 1

print("Estimated network size: %f" % (j * network_size / X))
print("L = [129.100.%s]" % ', 129.100.'.join(L))
print("A = [129.100.%s]" % ', 129.100.'.join(V))