import java.util.Vector;

public class LeaderElectionLine extends Algorithm {

	@Override
	public Object run() {
        return election(getID());
	}
	
	public Object election(String id) {
		
        Vector<String> v = neighbours();
        String status = "not leader",
        		left = (String) v.elementAt(0),
        		right = (String) v.elementAt(1),
        		neighbour = right,
        		direction = "right",
        		leader;
        String[] vals;
        Message msg = null, rec = null;
        
        // Check if this node is the leftmost node
        if (equal(left, "0")) msg = makeMessage(neighbour, direction + "," + id);
        
        try {
            while (waitForNextRound()) {
            	
                // ===Send Phase===
            	if (msg != null) {
            		send(msg);
                	msg = null;
                	
            		// terminate if you are going in the left direction
                	if (equal(direction, "left")) return status; 
            	}

                // ===Receive Phase===
                rec = receive();
                if (rec != null) {
                	vals = rec.data().split(",");
                	direction = vals[0];
                	leader = vals[1];
                	
                	// compare current leader and id value if going in the right direction
                	if (equal(direction, "right") && larger(id, leader)) leader = id;
                	
                	// switch directions if the current node is the right most node
                    if (equal(right, "0")) direction = "left";
                    
                    if (equal(direction, "left")) {
                    	
                    	// set status as a leader if the leader id matches node id
	                	if (equal(leader, id)) status = "leader";

	                	// return if current node is the left most node
	                	if (equal(left, "0")) return status;
	                	
                    	neighbour = left;
                    }
                	
                    msg = makeMessage(neighbour, direction + "," + leader);
                }
            }
        } catch(SimulatorException e) {
            System.out.println("ERROR: " + e.toString());
        }
		return null;
	}

}
