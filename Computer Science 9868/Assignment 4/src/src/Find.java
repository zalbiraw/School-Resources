import java.util.Vector;   

public class Find extends Algorithm {
	String result = "";

    public Object run() {
        return find(getID());
    }

	// Each message sent by this algorithm has the form: flag, value, ID, where:
	// - if flag = "GET" then the message is a request to get the document with the given key
	// - if flag = "LOOKUP" then the message is request to forward the message to the successor of
	//   this processor 
	// - if flag = "FOUND" then the message contains the key and processor that stores it
	// - if flag = "NOT_FOUND" then the requested data is not in the system
	// - if flag = "END" the algorithm terminates
	   
    public Object find(String id) {
       try {
    	   
			Vector<Integer> searchKeys 	= keysToFind(),
							localKeys 	= new Vector<Integer>(),
							fingers 	= new Vector<Integer>();
			
			int[] fingerTable;
			String[] data;

			Message msg = null, message;
			
			int m, key;
			String succ = successor();
			
			boolean keyProcessed = false;
			
			if (searchKeys.size() > 0) {
				for (int i = 0; i < searchKeys.size();) {
					if (searchKeys.elementAt(i) < 0) {
						localKeys.add(-searchKeys.elementAt(i));
						searchKeys.remove(i);
					}
					else if (searchKeys.elementAt(i) > 1000) {
						fingers.add(searchKeys.elementAt(i) - 1000);
						searchKeys.remove(i);
					}
					else ++i;
				}
			}
			
			m = fingers.size();

			fingerTable = new int[m + 1];
			for (int i = 0; i < m; ++i) fingerTable[i] = fingers.elementAt(i);
			fingerTable[m] = stringToInteger(id);
			
			String s = "Processor " + id + ": keys stored locally: ";
			for (int i = 0; i < localKeys.size(); ++i) s = s + localKeys.elementAt(i) + " ";
			printMessage (s);
			
			s = "Processor " + id + ": keys to search for: ";
			for (int i = 0; i < searchKeys.size(); ++i) s = s + searchKeys.elementAt(i) + " ";
			printMessage (s);
			
			s = "Processor " + id + ": finger table: ";
			for (int i = 0; i <= m; ++i) s = s + "finger[" + i + "]=" + fingerTable[i] + " ";
			printMessage(s);

			if (searchKeys.size() > 0) {
				key = searchKeys.elementAt(0);
				searchKeys.remove(0);

				if (localKeys.contains(key)) {
					result = result + key + ":" + id + " ";
					keyProcessed = true;
				}

				else msg = createLookupGetMessage(id, key, fingerTable, id, succ);
			}
			
			while (waitForNextRound()) {
				
				if (msg != null) {
					send(msg);
					
					data = unpack(msg.data());
					if (data[0].equals("END") && searchKeys.size() == 0) return result;
				}
				msg = null;
				
				message = receive();
				while (message != null) {
					
					data = unpack(message.data());
					
					if (data[0].equals("GET")) {
						if (data[2].equals(id)) {
							result = result + data[1] + ":not found ";
							keyProcessed = true;
						}

						else if (localKeys.contains(stringToInteger(data[1])))
							msg = makeMessage(data[2], pack("FOUND", data[1], id));
						
						else msg = makeMessage(data[2], pack("NOT_FOUND", data[1]));
					}
					
					if (data[0].equals("LOOKUP")) {
						msg = createLookupGetMessage(data[2], stringToInteger(data[1]), fingerTable, id, succ);
					}
					
					else if (data[0].equals("FOUND")) {
						result = result + data[1] + ":" + data[2] + " ";
						keyProcessed = true;
					}
					
					else if (data[0].equals("NOT_FOUND")) {
						result = result + data[1] + ":not found ";
						keyProcessed = true;
					}
					
					else if (data[0].equals("END")) 
							if (searchKeys.size() > 0) return result;
							else msg = makeMessage(succ,"END");
					
					message = receive();
				}
				
				if (keyProcessed) {
					if (searchKeys.size() == 0)
						msg = makeMessage(succ,"END");
					
					else {
						key = searchKeys.elementAt(0);
						searchKeys.remove(0);
						
						if (localKeys.contains(key)) {
							result = result + key + ":" + id + " ";
							keyProcessed = true;
						}
						
						else msg = createLookupGetMessage(id, key, fingerTable, id, succ);
							
					}
					if (msg != null) keyProcessed = false;
				}
			}
 
        } catch(SimulatorException e) {
            System.out.println("ERROR: " + e.toString());
        }
    
        return null;
    }
			
	private Message createLookupGetMessage(String lookup_id, int key, int[] fingers, String id, String succ) throws SimulatorException {
		int nearest = getNearest(key, fingers);
		
		if (nearest != stringToInteger(id)) return makeMessage(integerToString(nearest), pack("LOOKUP", key, lookup_id));
		return makeMessage(succ, pack("GET", key, lookup_id));
	}
	
    private int getNearest(int key, int[] fingers) {
    	int nearest = -1,
    		distance = 1000;
    	
    	for (int i = 0; i < fingers.length; ++i) {
    		if (fingers[i] < key && (key - fingers[i]) < distance) {
    			nearest = fingers[i];
    			distance = key - fingers[i];
    		}
    	}
    	
    	return nearest;
    }
}