<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加结果</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; text-align: center; }
        h2 { color: #333; }
        .success { color: green; }
        .error { color: red; }
        a { color: #2196F3; text-decoration: none; }
    </style>
</head>
<body>
    <h2>添加结果</h2>
    <%
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        User user = new User(name, password, email, phone);
        Model model = new Model();
        boolean result = model.addUser(user);
        
        if (result) {
    %>
            <p class="success">用户添加成功！</p>
    <%
        } else {
    %>
            <p class="error">用户添加失败！</p>
    <%
        }
    %>
    <br>
    <a href="insert.jsp">继续添加</a> | 
    <a href="index.jsp">返回首页</a>
</body>
</html>
