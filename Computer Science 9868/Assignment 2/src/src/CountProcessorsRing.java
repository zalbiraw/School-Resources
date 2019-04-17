public class CountProcessorsRing extends Algorithm {

	@Override
	public Object run() {
        return count(getID());
	}
	
	public Object count(String id) {

        String right = (String) neighbours().elementAt(1);
        Message msg = makeMessage(right, id), rec;
        int count = 1;
        
        try {
            while (waitForNextRound()) {
            	
                // ===Send Phase===
                send(msg);

                // ===Receive Phase===
                rec = receive();
                if (equal(rec.data(), id)) return count;
                else {
                	count++;
                	msg = makeMessage(right, rec.data());
                }
            }
        } catch(SimulatorException e) {
            System.out.println("ERROR: " + e.toString());
        }
		return null;
	}

}
