<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
        <title>Customers</title>
    </head>
    <body>
        <%@page import="jsp_azure_test.DataHandler"%>
        <%@page import="java.sql.ResultSet"%>
        <%
            // We instantiate the data handler here, and get all the movies from the database
            final DataHandler handler = new DataHandler();
        	String categoryString = request.getParameter("category");
        	int category = Integer.parseInt(categoryString);
            final ResultSet movies = handler.getAllCustomers(category);
        %>
        <!-- The table for displaying all the movie records -->
        <table cellspacing="2" cellpadding="2" border="1">
            <tr> <!-- The table headers row -->
              <td align="center">
                <h4>Customer Name</h4>
              </td>
              <td align="center">
                <h4>Address</h4>
              </td>
              <td align="center">
                <h4>Category</h4>
              </td>
            </tr>
            <%
               while(movies.next()) { // For each movie_night record returned...
                   // Extract the attribute values for every row returned
                   final String time = movies.getString("name");
                   final String name = movies.getString("address");
                   final String duration = movies.getString("category");

                   
                   out.println("<tr>"); // Start printing out the new table row
                   out.println( // Print each attribute value
                        "<td align=\"center\">" + time +
                        "</td><td align=\"center\"> " + name +
                        "</td><td align=\"center\"> " + duration + "</td>");
                   out.println("</tr>");
               }
               %>
          </table>
                     <a href="add_customer_form.jsp">Add another customers.</a>
    </body>
</html>