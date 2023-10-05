import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class sample {

    // Database credentials
    final static String HOSTNAME = "jaco0121-sql-server.database.windows.net";
    final static String DBNAME = "cs-dsa-4513-sql-db";
    final static String USERNAME = "njacob";
    final static String PASSWORD = "Not Today Satan";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);

    // Query templates
    final static String QUERY_TEMPLATE_1 = "EXEC experienceWithAge @pid = ?, @pname = ?, @age = ?;";//call the transact in SQL server

    final static String QUERY_TEMPLATE_2 = "EXEC experienceFromDirector @pid = ?, @pname = ?, @age = ?, @did = ?;";//call the transact in SQL server

    // User input prompt//
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            "1) Insert new performer with estimated years of experience based on age; \n" + 
            "2) Insert new performer with estimated years of experience based on director; \n" +
            "3) Display all performers; \n" + 
            "4) Exit!";

    public static void main(String[] args) throws SQLException {

        System.out.println("Welcome to my application!");

        final Scanner sc = new Scanner(System.in); // Scanner is used to collect the user input
        String option = ""; // Initialize user option selection as nothing
        while (!option.equals("4")) { // As user for options until option 4 is selected
            System.out.println(PROMPT); // Print the available options
            option = sc.next(); // Read in the user option selection

            switch (option) { // Switch between different options
                case "1": // Insert a new performer option
                    // Collect the new performer data from the user
                    System.out.println("Please enter integer performer ID:");
                    final int pid = sc.nextInt(); // Read in the user input of performer ID

                    System.out.println("Please enter performer name:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String pname = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).

                    System.out.println("Please enter integer age of performer:");
                    final int age = sc.nextInt(); // Read in the user input of age

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, pid);
                            statement.setString(2, pname);
                            statement.setInt(3, age);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }

                    break;
                case "2": // Insert a new performer option with director
                    // Collect the new performer data from the user
                    System.out.println("Please enter integer performer ID:");
                    final int pid2 = sc.nextInt(); // Read in the user input of performer ID

                    System.out.println("Please enter performer name:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String pname2 = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).

                    System.out.println("Please enter integer age of performer:");
                    final int age2 = sc.nextInt(); // Read in the user input of age

                    System.out.println("Please enter integer director ID:");
                    final int did = sc.nextInt(); // Read in the user input of director ID                    
                    
                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_2)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, pid2);
                            statement.setString(2, pname2);
                            statement.setInt(3, age2);
                            statement.setInt(4, did);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                    }

                    break;                    
                case "3":
                    System.out.println("Connecting to the database...");
                    // Get the database connection, create statement and execute it right away, as no user input need be collected
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");
                        try (
                            final Statement statement = connection.createStatement();
                            final ResultSet resultSet = statement.executeQuery("SELECT * FROM Performer")) {//I did not template this call as it was simple enough to include here

                                System.out.println("Contents of the Performer table:");
                                System.out.println("ID | name | years of experience | age ");

                                // Unpack the tuples returned by the database and print them out to the user
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s | %s | %s | %s |",
                                        resultSet.getString(1),
                                        resultSet.getString(2),
                                        resultSet.getString(3),
                                        resultSet.getString(4)));
                                }
                        }
                    }

                    break;
                case "4": // Do nothing, the while loop will terminate upon the next iteration
                    System.out.println("Exiting! Good-bye!");
                    break;
                default: // Unrecognized option, re-prompt the user for the correct one
                    System.out.println(String.format(
                        "Unrecognized option: %s\n" + 
                        "Please try again!", 
                        option));
                    break;
            }
        }

        sc.close(); // Close the scanner before exiting the application
    }
}