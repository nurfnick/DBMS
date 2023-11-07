<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Get Customers</title>
    </head>
    <body>
        <h2>Get Customers</h2>
        <!--
            Form for collecting user input for the retreiving customers by category.
            Upon form submission, get_all_customers.jsp file will be invoked.
        -->
        <form action="get_all_customers.jsp">
            <!-- The form organized in an HTML table for better clarity. -->
            <table border=1>
                <tr>
                    <th colspan="2">Category for Customers:</th>
                </tr>
                <tr>
                    <td>Customer Category:</td>
                    <td><div style="text-align: center;">
                    <input type=text name=category>
                    </div></td>
                </tr>

                <tr>
                    <td><div style="text-align: center;">
                    <input type=reset value=Clear>
                    </div></td>
                    <td><div style="text-align: center;">
                    <input type=submit value=Insert>
                    </div></td>
                </tr>
            </table>
        </form>
    </body>
</html>