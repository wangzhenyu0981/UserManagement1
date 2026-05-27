<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.User" %>
<%@ page import="model.Model" %>
<!DOCTYPE html>
<html>
<head>
    <title>删除用户</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h2 { color: #333; }
        form { width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 8px; box-sizing: border-box; }
        button { padding: 10px 20px; background-color: #f44336; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #da190b; }
        .user-info { margin-top: 20px; padding: 10px; background-color: #f9f9f9; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <div style="text-align: center;">
        <h2>删除用户</h2>
        <%
            String idStr = request.getParameter("id");
            User user = null;
            if (idStr != null && !idStr.isEmpty()) {
                Model model = new Model();
                user = model.getUserById(Integer.parseInt(idStr));
            }
        %>
        <form action="dele.jsp" method="get">
            <div class="form-group">
                <label>请输入要删除的用户ID：</label>
                <input type="text" name="id" required>
            </div>
            <button type="submit">查询用户</button>
        </form>
        
        <%
            if (user != null) {
        %>
            <div class="user-info">
                <h3>确认删除以下用户？</h3>
                <p>ID: <%= user.getId() %></p>
                <p>姓名: <%= user.getName() %></p>
                <p>邮箱: <%= user.getEmail() %></p>
                <p>电话: <%= user.getPhone() %></p>
                <form action="deleShow.jsp" method="post" style="margin-top: 20px;">
                    <input type="hidden" name="id" value="<%= user.getId() %>">
                    <button type="submit">确认删除</button>
                </form>
            </div>
        <%
            } else if (idStr != null && !idStr.isEmpty()) {
        %>
            <p style="color: red; margin-top: 20px;">未找到该用户！</p>
        <%
            }
        %>
        <br>
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
