<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<!DOCTYPE html>
<html>
<head>
    <title>更新用户</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h2 { color: #333; }
        form { width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 8px; box-sizing: border-box; }
        button { padding: 10px 20px; background-color: #2196F3; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #0b7dda; }
    </style>
</head>
<body>
    <div style="text-align: center;">
        <h2>更新用户信息</h2>
        <%
            String idStr = request.getParameter("id");
            User user = null;
            if (idStr != null && !idStr.isEmpty()) {
                Model model = new Model();
                user = model.getUserById(Integer.parseInt(idStr));
            }
            
            if (user != null) {
        %>
            <form action="updateShow.jsp" method="post">
                <div class="form-group">
                    <label>用户ID：</label>
                    <input type="text" name="id" value="<%= user.getId() %>" readonly>
                </div>
                <div class="form-group">
                    <label>姓名：</label>
                    <input type="text" name="name" value="<%= user.getName() %>" required>
                </div>
                <div class="form-group">
                    <label>密码：</label>
                    <input type="password" name="password" value="<%= user.getPassword() %>" required>
                </div>
                <div class="form-group">
                    <label>邮箱：</label>
                    <input type="email" name="email" value="<%= user.getEmail() %>">
                </div>
                <div class="form-group">
                    <label>电话：</label>
                    <input type="text" name="phone" value="<%= user.getPhone() %>">
                </div>
                <button type="submit">更新</button>
            </form>
        <%
            } else {
        %>
            <form action="update.jsp" method="get">
                <div class="form-group">
                    <label>请输入要更新的用户ID：</label>
                    <input type="text" name="id" required>
                </div>
                <button type="submit">查询用户</button>
            </form>
        <%
            }
        %>
        <br><br>
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
