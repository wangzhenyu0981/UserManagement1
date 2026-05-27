<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Model" %>
<!DOCTYPE html>
<html>
<head>
    <title>删除结果</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; text-align: center; }
        h2 { color: #333; }
        .success { color: green; }
        .error { color: red; }
        a { color: #2196F3; text-decoration: none; }
    </style>
</head>
<body>
    <h2>删除结果</h2>
    <%
        String idStr = request.getParameter("id");
        Model model = new Model();
        boolean result = model.deleteUser(Integer.parseInt(idStr));
        
        if (result) {
    %>
            <p class="success">用户删除成功！</p>
    <%
        } else {
    %>
            <p class="error">用户删除失败！</p>
    <%
        }
    %>
    <br>
    <a href="dele.jsp">继续删除</a> | 
    <a href="index.jsp">返回首页</a>
</body>
</html>
