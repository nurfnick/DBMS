<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query Result</title>
</head>
    <body>
    <%@page import="jsp_azure_test.DataHandler"%>
    <%@page import="java.sql.ResultSet"%>
    <%@page import="java.sql.Array"%>
    <%
    // The handler is the one in charge of establishing the connection.
    DataHandler handler = new DataHandler();

    // Get the attribute values passed from the input form.
    String startTime = request.getParameter("cname");
    String movieName = request.getParameter("address");
    String durationString = request.getParameter("category");


    /*
     * If the user hasn't filled out all the time, movie name and duration. This is very simple checking.
     */
    if (startTime.equals("") || movieName.equals("") || durationString.equals("")) {
        response.sendRedirect("add_customer_form.jsp");
    } else {
        int duration = Integer.parseInt(durationString);
        
        // Now perform the query with the data from the form.
        boolean success = handler.addCustomer(startTime, movieName, duration);
        if (!success) { // Something went wrong
            %>
                <h2>There was a problem inserting the customer</h2>
            <%
        } else { // Confirm success to the user
            %>
            <h2>The Customer:</h2>

            <ul>
                <li>Customer Name: <%=startTime%></li>
                <li>Address: <%=movieName%></li>
                <li>Category: <%=durationString%></li>

            </ul>

            <h2>Was successfully inserted.</h2>
            
            <a href="get_all_customers_form.jsp">See all customers.</a>
            <%
        }
    }
    %>
    </body>
</html>