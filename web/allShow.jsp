<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>所有用户</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h2 { color: #333; text-align: center; }
        table { width: 80%; margin: 0 auto; border-collapse: collapse; }
        th, td { padding: 12px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        a { color: #2196F3; text-decoration: none; }
        .nav { text-align: center; margin-top: 20px; }
    </style>
</head>
<body>
    <h2>所有用户列表</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>姓名</th>
            <th>密码</th>
            <th>邮箱</th>
            <th>电话</th>
        </tr>
        <%
            Model model = new Model();
            List<User> userList = model.getAllUsers();
            for (User user : userList) {
        %>
            <tr>
                <td><%= user.getId() %></td>
                <td><%= user.getName() %></td>
                <td><%= user.getPassword() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getPhone() %></td>
            </tr>
        <%
            }
        %>
    </table>
    <div class="nav">
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
