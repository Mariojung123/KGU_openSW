<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="css/login.css"/>
</head>
<body>
    <jsp:include page="/component/navbar.jsp" />
    <div class="login-container">
        <div class="login-form">
            <h3 class="form-heading">Login</h3>
            <%
                String error = request.getParameter("error");
                if (error != null) {
                    out.print("<div class='alert alert-danger'>");
                    out.print("Invalid username or password.");
                    out.print("</div>");
                }
            %>
            <form action="processLoginMember.jsp" method="post">
                <div class="form-group">
                    <label for="loginId">Id</label>
                    <input type="text" name="loginId" id="loginId" class="form-control" placeholder="Username" required autofocus>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" name="password" id="password" class="form-control" placeholder="Password" required>
                </div>
                <button class="btn btn-primary" type="submit">Login</button>
                <button class="btn btn-secondary" type="button" onclick="location.href='addMember.jsp'">Sign Up</button>
            </form>
        </div>
    </div>
</body>
</html>

