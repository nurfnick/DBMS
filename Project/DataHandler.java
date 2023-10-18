package jsp_azure_test;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class DataHandler {

    private Connection conn;

    // Azure SQL connection credentials
    final static String server = "jaco0121-sql-server.database.windows.net";
    final static String database = "cs-dsa-4513-sql-db";
    final static String username = "njacob";
    final static String password = "";

    // Resulting connection string
    final private String url =
            String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
                    server, database, username, password);

    // Initialize and save the database connection
    
    private void getDBConnection() throws SQLException {
        if (conn != null) {
            return;
        }

        this.conn = DriverManager.getConnection(url);
    }


    // Add a customer to the table
    public boolean addCustomer(
            String cname, String address, int category) throws SQLException {

        getDBConnection(); // Prepare the database connection

        // Prepare the SQL statement
        final String sqlQuery =
                "INSERT INTO Customer " + 
                    "(name, address, category) " + 
                "VALUES " + 
                "(?, ?, ?)";
        final PreparedStatement stmt = conn.prepareStatement(sqlQuery);

        // Replace the '?' in the above statement with the given attribute values
        stmt.setString(1, cname);
        stmt.setString(2, address);
        stmt.setInt(3, category);


        // Execute the query, if only one record is updated, then we indicate success by returning true
        return stmt.executeUpdate() == 1;
    }    

// Return the result of selecting all customers based on category
public ResultSet getAllCustomers(int category) throws SQLException {
    getDBConnection();
    
    final String sqlQuery = "SELECT * FROM Customer WHERE category = ?;";
    final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
    stmt.setInt(1, category);    
    
    return stmt.executeQuery();
	}
}