import java.util.Vector;

public class LeaderElectionMesh extends Algorithm {

	@Override
	public Object run() {
        return election(getID());
	}
	
	public Object election(String id) {
		
        Vector<String> v = neighbours();
        String status = "not leader",
        		left = (String) v.elementAt(0),
                up = (String) v.elementAt(1),
                right = (String) v.elementAt(2),
                down = (String) v.elementAt(3),
        		neighbour = right,
        		direction = "right",
        		localLeader = id,
        		leader;
        String[] vals;
        Message[] msgs = new Message[3];
        
        if (equal(left, "0")) msgs[1] = makeMessage(neighbour, direction + "," + id);

        try {
            while (waitForNextRound()) {

                // ===Send Phase===
            	// check if msg is not null and send if it is not
            	if (msgs[2] != null) {
            		send(msgs[2]);
            		msgs[2] = null;
            	}
            	// check if msg is not null and send if it is not
            	if (msgs[1] != null) {
                	vals = msgs[1].data().split(",");
                	direction = vals[0];
                	
                	// return status if left most in a row
                	if (equal(direction, "left") && equal(left, "0")) return status;
                	
            		send(msgs[1]);
            		msgs[1] = null;
            		
            		if (equal(direction, "left")) return status;
            	}

                // ===Receive Phase===
                msgs[0] = receive();
                if (msgs[0] != null) {
                	vals = msgs[0].data().split(",");
                	direction = vals[0];
                	leader = vals[1];
                	
                	// find the leader
                	if (equal(direction, "right") || equal(direction, "down")) {
                		if (larger(leader, localLeader)) localLeader = leader;
                		else leader = localLeader;
                	}
                	
                	// handle top right corner on entry and suspend all processes expect the one on the first row
                    if (equal(right, "0") && equal(direction, "right")) {
                    	
                    	if (equal(up, "0")) direction = "down";
                    	else direction = "suspend";
                    	
                    }
                    
                    // handle bottom right corner on return
                    if (equal(direction, "down") && equal(down, "0")) direction = "up";

                    // handle top right corner on return
                    if ((equal(direction, "up") && equal(up, "0"))) direction = "left";
                    
                    // set status
                    if ((equal(direction, "left") || equal(direction, "up")) && equal(leader, id)) status = "leader";

                    // handle navigation in different directions
                    // left
                    if (equal(direction, "left")) neighbour = left;
                    
                    // up
                    else if (equal(direction, "up")) {
                    	direction = "left";
                    	neighbour = left;
                    	msgs[2] = makeMessage(up, "up," + leader);
                    }
                    
                    // right
                    else if (equal(direction, "right")) neighbour = right;
                    
                    // down
                    else if (equal(direction, "down")) neighbour = down;
                	
                    if (!equal(direction, "suspend")) {
                        msgs[1] = makeMessage(neighbour, direction + "," + leader);
                    }
                }
            }
        } catch(SimulatorException e) {
            System.out.println("ERROR: " + e.toString());
        }
		return null;
	}

}
