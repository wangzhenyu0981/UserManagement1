<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户详情</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h2 { color: #333; }
        .user-card { width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; background-color: #f9f9f9; }
        .user-info { margin-bottom: 10px; }
        label { font-weight: bold; }
        a { color: #2196F3; text-decoration: none; }
    </style>
</head>
<body>
    <div style="text-align: center;">
        <h2>用户详情</h2>
        <%
            User user = (User) request.getAttribute("user");
            if (user != null) {
        %>
            <div class="user-card">
                <div class="user-info"><label>ID:</label> <%= user.getId() %></div>
                <div class="user-info"><label>姓名:</label> <%= user.getName() %></div>
                <div class="user-info"><label>密码:</label> <%= user.getPassword() %></div>
                <div class="user-info"><label>邮箱:</label> <%= user.getEmail() %></div>
                <div class="user-info"><label>电话:</label> <%= user.getPhone() %></div>
            </div>
        <%
            } else {
        %>
            <p>未找到用户！</p>
        <%
            }
        %>
        <br>
        <a href="search.jsp">继续查询</a> | 
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
