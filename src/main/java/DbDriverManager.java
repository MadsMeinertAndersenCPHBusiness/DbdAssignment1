import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DbDriverManager {


    public static Connection getConnection(String username, String password) throws SQLException {
        String url = "jdbc:postgresql://localhost/soft2021";
        Properties props = new Properties();
        props.setProperty("user", username);
        props.setProperty("password", password);
        return DriverManager.getConnection(url, props);
    }
}
