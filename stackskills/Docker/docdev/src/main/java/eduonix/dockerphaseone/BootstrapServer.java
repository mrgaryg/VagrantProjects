package eduonix.dockerphaseone;


import org.slf4j.bridge.SLF4JBridgeHandler;
import static spark.Spark.*;

public class BootstrapServer {

    private static final String IP_ADDRESS = "localhost";
    private static final int PORT =  8080;
    
    
    public static void main(String[] args) {

        SLF4JBridgeHandler.removeHandlersForRootLogger();
        SLF4JBridgeHandler.install();
        
        setIpAddress(IP_ADDRESS);
        setPort(PORT);
        get("/dockerapp", (req, res) -> "Docker Application calls back");

        
    }
    
    
    
}
