<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<!DOCTYPE html>
<html>
<head>
    <title>查询用户</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h2 { color: #333; }
        form { width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 8px; box-sizing: border-box; }
        button { padding: 10px 20px; background-color: #2196F3; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #0b7dda; }
        .user-info { margin-top: 20px; padding: 15px; background-color: #f9f9f9; border: 1px solid #ddd; width: 400px; margin-left: auto; margin-right: auto; }
        a { color: #2196F3; text-decoration: none; }
    </style>
</head>
<body>
    <div style="text-align: center;">
        <h2>查询用户</h2>
        <form action="search.jsp" method="post">
            <div class="form-group">
                <label>请输入用户ID：</label>
                <input type="text" name="id" required>
            </div>
            <button type="submit">查询</button>
        </form>
        
        <%
            if (request.getMethod().equals("POST")) {
                String idStr = request.getParameter("id");
                Model model = new Model();
                User user = model.getUserById(Integer.parseInt(idStr));
                
                if (user != null) {
        %>
                    <div class="user-info">
                        <h3>查询结果</h3>
                        <p><strong>ID:</strong> <%= user.getId() %></p>
                        <p><strong>姓名:</strong> <%= user.getName() %></p>
                        <p><strong>密码:</strong> <%= user.getPassword() %></p>
                        <p><strong>邮箱:</strong> <%= user.getEmail() %></p>
                        <p><strong>电话:</strong> <%= user.getPhone() %></p>
                        <br>
                        <a href="update.jsp?id=<%= user.getId() %>">更新此用户</a> | 
                        <a href="dele.jsp?id=<%= user.getId() %>">删除此用户</a>
                    </div>
        <%
                } else {
        %>
                    <p style="color: red; margin-top: 20px;">未找到该用户！</p>
        <%
                }
            }
        %>
        <br>
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
