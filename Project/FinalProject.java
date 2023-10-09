import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

public class project {

    // Database credentials
    final static String HOSTNAME = "jaco0121-sql-server.database.windows.net";
    final static String DBNAME = "cs-dsa-4513-sql-db";
    final static String USERNAME = "njacob";
    final static String PASSWORD = "Not Today Satan";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);

    // Query templates
    final static String QUERY_TEMPLATE_1 = "EXEC query1 @name = ?, @address = ?, @category = ?;";//call the transact in SQL server

    final static String QUERY_TEMPLATE_2 = "EXEC query2 @dept_num=?, @dept_data = ?;";//call the transact in SQL server
    
    final static String QUERY_TEMPLATE_3 = "EXEC query3 @process_id=?, @process_data = ?, @type = ?, @type_type = ?, @type_method = ?;";//call the transact in SQL server    

    final static String QUERY_TEMPLATE_4 = "EXEC query4 @assembly_id=?, @date_ordered = ?, @assembly_details = ?, @name = ?, @process_ids = ?;";//call the transact in SQL server    

    final static String QUERY_TEMPLATE_5 = "EXEC query5 @acct_id = ?, @type = ?, @date_established = ?, @num = ?;";//call the transact in SQL server    
    // User input prompt//
    final static String PROMPT = 
            "\nPlease select one of the options below: \n" +
            "1) Enter a new customer; \n" + 
            "2) Enter a new department; \n" +
            "3) Enter a new process; \n" + 
            "4) Enter a new assembly; \n" +
            "5) Create a new account; \n" + 
            "6) Enter a new job; \n" +
            "7) Complete a job; \n" +
            "8) Update costs; \n" +
            "9) Print cost by assembly id; \n" +
            "10) Print labor time by department; \n" +
            "11) Print assembly details; \n" +
            "12) Print customers by category; \n" +
            "13) Delete cut jobs; \n" +
            "14) Change color; \n" +  
            "15) Import new customers; \n" +  
            "16) Export customers by category; \n" +  
            "17) Exit!";

    public static void main(String[] args) throws SQLException {

        System.out.println("Welcome to my application!");

        final Scanner sc = new Scanner(System.in); // Scanner is used to collect the user input
        String option = ""; // Initialize user option selection as nothing
        while (!option.equals("17")) { // As user for options until option 17 is selected
            System.out.println(PROMPT); // Print the available options
            option = sc.next(); // Read in the user option selection

            switch (option) { // Switch between different options
                case "1": // Insert a new customer
                    // Collect the new customer data from the user
                    System.out.println("Please enter name for new customer:");
                    sc.nextLine();
                    final String name = sc.nextLine(); // Read in the user input of performer ID

                    System.out.println("Please enter customer address:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    //sc.nextLine();
                    final String address = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).

                    System.out.println("Please enter integer category for customer:");
                    final int category = sc.nextInt(); // Read in the user input of age

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
                            // Populate the query template with the data collected from the user
                            statement.setString(1, name);
                            statement.setString(2, address);
                            statement.setInt(3, category);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert customer. " + sqle);                        }
                    }

                    break;
                case "2": // Insert a new department
                    // Collect the new department data from the user
                    System.out.println("Please enter the department number:");
                    sc.nextLine();
                    final int dept_num = sc.nextInt(); // Read in the user input of performer ID

                    System.out.println("Please enter any department data:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String dept_data = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_2)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, dept_num);
                            statement.setString(2, dept_data);
          


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert department. " + sqle);                        }
                    }

                    break;
                case "3": // Insert a new process
                    // Collect the new process data from the user
                    System.out.println("Please enter new process id:");
                    sc.nextLine();
                    final int process_id = sc.nextInt(); // Read in the user input of performer ID

                    System.out.println("Please enter process data:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String process_data = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).

                    System.out.println("Please enter the type for the process (Fit, Paint, or Cut):");
                    final String type = sc.nextLine(); // Read in the type
                    String type_type = null;
                    String type_method = null;
                    
                    if (type.equalsIgnoreCase("Fit")) {
                    	System.out.println("Please enter the fit type:");
                    	type_type = sc.nextLine();
                    	type_method = null;
                    }
                    else if (type.equalsIgnoreCase("Paint")) {
                    	System.out.println("Please enter the paint type:");
                    	type_type = sc.nextLine();
                    	System.out.println("Please enter the paint method:");
                    	type_method = sc.nextLine();

                    }
                    else if (type.equalsIgnoreCase("Cut")) {
                    	System.out.println("Please enter the cut type:");
                    	type_type = sc.nextLine();
                    	System.out.println("Please enter the cut method:");
                    	type_method = sc.nextLine();
                    }
                    else {
                    	System.out.println("Why did you not input the type correctly...");
                    }
                   
                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_3)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, process_id);
                            statement.setString(2, process_data);
                            statement.setString(3, type);
                            statement.setString(4, type_type);
                            statement.setString(5, type_method);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert process. " + sqle);                        }
                    }

                    break;
                case "4": // Insert a new assembly
                    // Collect the new assembly data from the user
                    System.out.println("Please enter an assembly id:");
                    sc.nextLine();
                    final int assembly_id = sc.nextInt(); // Read in the user input of performer ID

                    System.out.println("Please enter assembly date ordered in mm/dd/yy format:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String date_ordered = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).
                    
                    System.out.println("Please enter assembly details:");
                    final String assembly_details = sc.nextLine(); // Read in the user input of age
                    
                    System.out.println("Please enter customer name:");
                    final String name1 = sc.nextLine(); // Read in the user input of age
                    
                    System.out.println("Please enter the process ids in a comma seperated list:");
                    final String process_ids = sc.nextLine(); // Read in the user input of age

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_4)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, assembly_id);
                            statement.setString(2, date_ordered);
                            statement.setString(3, assembly_details);
                            statement.setString(4, name1);
                            statement.setString(5, process_ids);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert assembly. " + sqle);                        }
                    }

                    break;
                case "5": // Insert a new account
                    // Collect the new customer data from the user
                    System.out.println("Please enter id for new account:");
                    sc.nextLine();
                    final int acct_id = sc.nextInt(); // Read in the user input of performer ID

                    System.out.println("Please enter account type (Department, Process, or Assembly:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    //sc.nextLine();
                    final String type1 = sc.nextLine(); // Read in user input of performer name (white-spaces allowed).
                    
                    System.out.println("Please enter the id this account references:");
                    final int num = sc.nextInt(); // Read in the user input of age
                    
                    System.out.println("Please enter date established for this account:");
                    final String date_established = sc.nextLine(); // Read in the user input of age

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_5)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, acct_id);
                            statement.setString(2, type1);
                            statement.setString(3, date_established);
                            statement.setInt(4, num);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert account. " + sqle);                        }
                    }

                    break;                  
                case "13": // Insert a new performer option with director
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
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert tuple. " + sqle);                        }
                    }

                    break;                    
                case "33":
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
                case "17": // Do nothing, the while loop will terminate upon the next iteration
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