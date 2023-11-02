import java.sql.Connection;
import java.sql.Statement;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class project {

    // Database credentials
    final static String HOSTNAME = "jaco0121-sql-server.database.windows.net";
    final static String DBNAME = "cs-dsa-4513-sql-db";
    final static String USERNAME = "njacob";
    final static String PASSWORD = "";

    // Database connection string
    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
            HOSTNAME, DBNAME, USERNAME, PASSWORD);

    // Query templates these are relatively mundane.  Each is simply a string for the call on sql server.
    final static String QUERY_TEMPLATE_1 = "EXEC query1 @name1 = ?, @address = ?, @category = ?;";//call the transact in SQL server

    final static String QUERY_TEMPLATE_2 = "EXEC query2 @dept_num=?, @dept_data = ?;";//call the transact in SQL server
    
    final static String QUERY_TEMPLATE_3 = "EXEC query3 @process_id=?, @process_data = ?, @type = ?, @type_type = ?, @type_method = ?;";//call the transact in SQL server    

    final static String QUERY_TEMPLATE_4 = "EXEC query4 @assembly_id=?, @date_ordered = ?, @assembly_details = ?, @name1 = ?, @process_ids = ?;";//call the transact in SQL server    

    final static String QUERY_TEMPLATE_5 = "EXEC query5 @acct_id = ?, @type = ?, @date_established = ?, @num = ?;";//call the transact in SQL server    

    final static String QUERY_TEMPLATE_6 = "EXEC query6 @job_num = ?, @job_date_commenced = ?, @assembly_id = ?, @process_id = ?;";//call the transact in SQL server  

    final static String QUERY_TEMPLATE_7 = "EXEC query7 @job_num = ?, @job_date_completed = ?, @job_type = ?, @labor = ?, @machine_type =?, @time = ?, @material = ?, @color =?, @volume =?;";//call the transact in SQL server   

    final static String QUERY_TEMPLATE_8 = "EXEC query8 @tran_num =?, @sup_cost = ?, @job_num = ?, @process_id = ?;";//call the transact in SQL server
    
    final static String QUERY_TEMPLATE_9 = "EXEC query9 @assembly_id =?;";//call the transact in SQL server    
    
    final static String QUERY_TEMPLATE_10 = "EXEC query10 @date =?, @department = ?;";   

    final static String QUERY_TEMPLATE_11 = "EXEC query11 @assembly_id = ?;";
    
    final static String QUERY_TEMPLATE_12 = "EXEC query12 @category =?;";//call the transact in SQL server   
 
    final static String QUERY_TEMPLATE_13 = "EXEC query13 @job_num_start =?, @job_num_end =?;";//call the transact in SQL server  

    final static String QUERY_TEMPLATE_14 = "EXEC query14 @job_num =?, @color =?;";//call the transact in SQL server  
    
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
            "9) Print cost on assembly id; \n" +
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
                    final int category = sc.nextInt(); // Read in the user input of category

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
                        	System.out.println("Could not insert customer. " + sqle);                        }//here we throw a warning if somethign goes wron on the insert
                    }

                    break;
                case "2": // Insert a new department
                    // Collect the new department data from the user
                    System.out.println("Please enter the department number:");
                    sc.nextLine();
                    final int dept_num = sc.nextInt(); // Read in the user input of department ID

                    System.out.println("Please enter any department data:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String dept_data = sc.nextLine(); // Read in user input of department (white-spaces allowed).

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
                        	System.out.println("Could not insert department. " + sqle);                        }//throw an exception if you made an error on the input
                    }

                    break;
                case "3": // Insert a new process
                    // Collect the new process data from the user
                    System.out.println("Please enter new process id:");
                    sc.nextLine();
                    final int process_id = sc.nextInt(); // Read in the user input of process ID

                    System.out.println("Please enter process data:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String process_data = sc.nextLine(); // Read in user input of process data (white-spaces allowed).

                    System.out.println("Please enter the type for the process (Fit, Paint, or Cut):");
                    final String type = sc.nextLine(); // Read in the type
                    String type_type = null;//reserve these for assignment in a moment
                    String type_method = null;
                    
                    if (type.equalsIgnoreCase("Fit")) { //if fit get the info
                    	System.out.println("Please enter the fit type:");
                    	type_type = sc.nextLine();
                    	type_method = null;
                    }
                    else if (type.equalsIgnoreCase("Paint")) {//paint
                    	System.out.println("Please enter the paint type:");
                    	type_type = sc.nextLine();
                    	System.out.println("Please enter the paint method:");
                    	type_method = sc.nextLine();

                    }
                    else if (type.equalsIgnoreCase("Cut")) {//cut
                    	System.out.println("Please enter the cut type:");
                    	type_type = sc.nextLine();
                    	System.out.println("Please enter the cut method:");
                    	type_method = sc.nextLine();
                    }
                    else {
                    	System.out.println("Why did you not input the type correctly...");//if you dont input fit cut or paint it insults you...
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
                        	System.out.println("Could not insert process. " + sqle);                        }//error message
                    }

                    break;
                case "4": // Insert a new assembly
                    // Collect the new assembly data from the user
                    System.out.println("Please enter an assembly id:");
                    sc.nextLine();
                    final int assembly_id = sc.nextInt(); // Read in the user input of assembly ID

                    System.out.println("Please enter assembly date ordered in mm/dd/yy format:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String date_ordered = sc.nextLine(); // Read in user input of date.  I take as a string rather than worry about swapping date types between this and sql
                    
                    System.out.println("Please enter assembly details:");
                    final String assembly_details = sc.nextLine(); // Read in the details
                    
                    System.out.println("Please enter customer name:");
                    final String name1 = sc.nextLine(); // Read in the user input of name
                    
                    System.out.println("Please enter the process ids in a comma seperated list:");
                    final String process_ids = sc.nextLine(); // this was the hardest part!  I have the user give a list of the process ids for creating the assembly.  I parse this list inside sql.

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
                    // Collect the new account data from the user
                    System.out.println("Please enter id for new account:");
                    sc.nextLine();
                    final int acct_id = sc.nextInt(); // Read in the user input of account ID

                    System.out.println("Please enter account type (Department, Process, or Assembly:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String type1 = sc.nextLine(); // Read in user input of type of account
                    
                    System.out.println("Please enter the id this account references:");
                    final int num = sc.nextInt(); // this is the id for the department, process or assembly
                    sc.nextLine();
                    
                    System.out.println("Please enter date established for this account:");
                    final String date_established = sc.nextLine(); // Read in the user input of date

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
                case "6": // Insert a new job
                    // Collect the new job data from the user
                    System.out.println("Please enter job number:");
                    sc.nextLine();
                    final int job_num = sc.nextInt(); // Read in the user input of job ID

                    System.out.println("Please enter date the job commenced:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String date_job_commenced = sc.nextLine(); // Read in date.
                    
                    System.out.println("Please enter the assembly id:");
                    final int assembly_id2 = sc.nextInt(); // Read in the user input assembly id
                    
                    System.out.println("Please enter process id that starts this assembly:");
                    final int process_id2 = sc.nextInt(); // Read in the user input of first process id

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_6)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, job_num);
                            statement.setString(2, date_job_commenced);
                            statement.setInt(3, assembly_id2);
                            statement.setInt(4, process_id2);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            boolean rows_inserted = statement.execute();
                            while(rows_inserted||statement.getUpdateCount()!=-1) {rows_inserted = statement.getMoreResults();}
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert job. " + sqle);                        }
                    }

                    break;
                case "7": // End a job
                    // Collect the new data from the user
                    System.out.println("Please enter job to end:");
                    sc.nextLine();
                    final int job_num1 = sc.nextInt(); // Read in the user input of job ID

                    System.out.println("Please enter completion date of job:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final String job_date_completed = sc.nextLine(); // Read in user input of completion date as string

                    System.out.println("Please enter the type for the process (Fit, Paint, or Cut):");
                    final String job_type = sc.nextLine(); // Read in the type
                    double labor = 0.0;//get the variables ready for assignment
                    String machine_type = null;
                    double time = 0.0;
                    double material = 0.0;
                    String color = null;
                    double volume = 0.0;
                    
                    if (job_type.equalsIgnoreCase("Fit")) {//we need to grab the relevant data
                    	System.out.println("Please enter the labor hours:");//only assign the variables you need.
                    	labor = sc.nextDouble();
                    }
                    else if (job_type.equalsIgnoreCase("Paint")) {
                    	System.out.println("Please enter the labor hours:");
                    	labor = sc.nextDouble();                    	
                    	System.out.println("Please enter the paint color:");
                    	color = sc.nextLine();
                    	System.out.println("Please enter the paint volume:");
                    	volume = sc.nextDouble();

                    }
                    else if (job_type.equalsIgnoreCase("Cut")) {
                    	System.out.println("Please enter the labor hours:");
                    	labor = sc.nextDouble();                    	
                    	System.out.println("Please enter the machine type:");
                    	machine_type = sc.nextLine();
                    	System.out.println("Please enter the time:");
                    	time = sc.nextDouble();
                    	System.out.println("Please enter the material:");
                    	material = sc.nextDouble();
                    }
                    else {
                    	System.out.println("Why did you not input the type correctly...");//insult user if they don't spell fit, cut or paint correctly
                    }
                   
                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_7)) {//many of these get sent over as null or 0
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, job_num1);
                            statement.setString(2, job_date_completed);
                            statement.setString(3, job_type);
                            statement.setDouble(4, labor);
                            statement.setString(5, machine_type);
                            statement.setDouble(6, time);
                            statement.setDouble(7, material);
                            statement.setString(8, color);
                            statement.setDouble(9, volume);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows inserted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not insert process. " + sqle);                        }
                    }

                    break;    
 
                case "8": // Insert a new cost
                    // Collect the cost data from the user
                    System.out.println("Please enter transaction number:");
                    sc.nextLine();
                    final int tran_num = sc.nextInt(); // Read in the user input of transact ID

                    System.out.println("Please enter the cost for this transaction:");
                    // Preceding nextInt, nextFloar, etc. do not consume new line characters from the user input.
                    // We call nextLine to consume that newline character, so that subsequent nextLine doesn't return nothing.
                    sc.nextLine();
                    final double sup_cost = sc.nextDouble(); // Read in cost.
                    
                    System.out.println("Please enter the job number:");
                    final int job_num3 = sc.nextInt(); // Read in the user input job id
                    
                    System.out.println("Please enter process for this transaction:");
                    final int process_id3 = sc.nextInt(); // Read in the user input of process.  Since job is tied to assembly, this info must be gathered to increment the costs.

                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_8)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, tran_num);
                            statement.setDouble(2, sup_cost);
                            statement.setInt(3, job_num3);
                            statement.setInt(4, process_id3);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d transaction completed.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not complete transaction. " + sqle);                        }
                    }

                    break;                   
                    
                case "9":
                	System.out.println("Please enter an assembly id:");
                    sc.nextLine();
                    final int assembly_id3 = sc.nextInt(); // Read in the user input of assembly ID
                    // Get the database connection, create statement and execute it 
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");
                        try (
                                final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_9)) {
                                // Populate the query template with the data collected from the user
                                statement.setInt(1, assembly_id3);
                                final ResultSet resultSet = statement.executeQuery();
                                System.out.println(String.format("Costs of Assembly %s:",assembly_id3));
                                

                                // Unpack the single return
                                
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s",
                                        resultSet.getDouble(1)));
                                }
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not complete transaction. " + sqle);                        }
                    }

                    break;     
                case "10":
                	System.out.println("Please enter date in MM/DD/YYYY format:");
                    sc.nextLine();
                    final String date1 = sc.nextLine(); // Read in the date as a string
                    System.out.println("Please enter department of interest (Fit, Cut, or Paint):");
                   // sc.nextLine();
                    final String dept = sc.nextLine(); // Read in the department as a string
                    // Get the database connection, create statement and execute it 
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");
                        try (
                                final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_10)) {
                                // Populate the query template with the data collected from the user
                                statement.setString(1, date1);
                                statement.setString(2, dept);
                                final ResultSet resultSet = statement.executeQuery();
                                System.out.println(String.format("Total Hours of %s on %s:",dept,date1));//print both the user inputs
                                

                                // Unpack the tuples returned by the database and print them out to the user
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s",
                                        resultSet.getDouble(1)));
                                }
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not complete labor ask. " + sqle);                        }
                    }

                    break;                     
                case "11":
                	System.out.println("Please enter an assembly id:");
                    sc.nextLine();
                    final int assembly_id4 = sc.nextInt(); // Read in the user input of performer ID
                    // Get the database connection, create statement and execute it right away, as no user input need be collected
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");
                        try (
                                final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_11)){
                                // Populate the query template with the data collected from the user
                                statement.setInt(1, assembly_id4);
                                final ResultSet resultSet = statement.executeQuery();
                                System.out.println(String.format("Assembly %s:",assembly_id4));
                                System.out.println("Process ID | Supervising Department");
                                

                                // Unpack the tuples returned by the database and print them out to the user
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s          | %s",
                                        resultSet.getInt(1),
                                        resultSet.getInt(2)));
                                }
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not complete assembly call. " + sqle);                        }
                    }

                    break;                        
                case "12":
                	System.out.println("Please enter category number:");
                    sc.nextLine();
                    final int catnum = sc.nextInt(); // Read in the user input of category number
                    System.out.println("Connecting to the database...");
                    // Get the database connection, create statement and execute it right away, as no user input need be collected
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        System.out.println("Dispatching the query...");
                        final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_12); {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, catnum);


                            //System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final ResultSet resultSet = statement.executeQuery();
                            


                                System.out.println("Contents of the Customer table:");
                                System.out.println("name");

                                // Unpack the tuples returned by the database and print them out to the user
                                while (resultSet.next()) {
                                    System.out.println(String.format("%s",
                                        resultSet.getString(1)));
                                }
                        }
                        }
                    catch (SQLException sqle) {
                    	System.out.println("Could not complete transaction. " + sqle);                        }
                   

                    break;                    

                    
                case "13": // delete cut jobs
                    // Collect the range data from the user
                    System.out.println("Please enter start number for range of cut jobs:");
                    sc.nextLine();
                    final int job_num_start = sc.nextInt(); // Read in the start
           
                    System.out.println("Please enter end number for range of cut jobs:");
                    final int job_num_end = sc.nextInt(); // Read in the end
                    
                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_13)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, job_num_start);
                            statement.setInt(2, job_num_end);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows deleted.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not delete rows. " + sqle);                        }
                    }  
                    break;
                case "14": // update paint job
                    // Collect the new customer data from the user
                    System.out.println("Please enter job number for paint job:");
                    sc.nextLine();
                    final int job_num2 = sc.nextInt(); // Read in the user input of job ID
           
                    System.out.println("Please enter the new color:");
                    sc.nextLine();
                    final String color1 = sc.nextLine(); // Read in the color
                    
                    System.out.println("Connecting to the database...");
                    // Get a database connection and prepare a query statement
                    try (final Connection connection = DriverManager.getConnection(URL)) {
                        try (
                            final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_14)) {
                            // Populate the query template with the data collected from the user
                            statement.setInt(1, job_num2);
                            statement.setString(2, color1);


                            System.out.println("Dispatching the query...");
                            // Actually execute the populated query
                            final int rows_inserted = statement.executeUpdate();
                            System.out.println(String.format("Done. %d rows modified.", rows_inserted));
                        }
                        catch (SQLException sqle) {
                        	System.out.println("Could not modify rows. " + sqle);                        }
                    }  
                    break;  
                 
                    
                case "15":
                	System.out.println("Enter path for file to input:");
                	sc.nextLine();
                	final String pathtofile = sc.nextLine();//path to find file inputted by user
                	File file = new File(pathtofile);
                	try (Scanner scanfile = new Scanner(file)){ //get the file
                	while (scanfile.hasNextLine())
                        try (final Connection connection = DriverManager.getConnection(URL)) {
                            try (
                                final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
                                // Populate the query template with the data collected from the user
                                statement.setString(1, scanfile.next());//grab name
                                statement.setString(2, scanfile.next());//grab address
                                statement.setString(3, scanfile.next());//grab category


                                System.out.println("Dispatching the query...");
                                // Actually execute the populated query
                                final int rows_inserted = statement.executeUpdate(); 
                                System.out.println(String.format("Done. %d row inserted.", rows_inserted));//this is going to print each time we add a row.
                		//System.out.println(scanfile.nextLine());
                	}
                            catch (SQLException sqle) {
                            	System.out.println("Could not add customer. " + sqle);                        }    
                        }} catch (FileNotFoundException e) {
                		System.out.println("File not found");//had to have this exception for scanfile to work
                	}
                	break;
                
                case "16":
                	System.out.println("Enter path for export file:");
                	sc.nextLine();
                	final String pathtofile2 = sc.nextLine();
                    try {
                        FileWriter myWriter = new FileWriter(pathtofile2);
                        try (final Connection connection = DriverManager.getConnection(URL)){
                        try (
                                final Statement statement = connection.createStatement();
                                final ResultSet resultSet = statement.executeQuery("SELECT * FROM Customer")){//I didn't bother to template or transact this call.
                        		
                        	while (resultSet.next()) {
                                myWriter.write(String.format("%s  %s  %s %n",
                                    resultSet.getString(1),
                                    resultSet.getString(2),
                                    resultSet.getString(3)));
                            }
                        	
                        }
                        myWriter.close();
                        System.out.println("Successfully wrote to the file.");}
                      } catch (IOException e) {
                        System.out.println("An error occurred.");
                        e.printStackTrace();
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