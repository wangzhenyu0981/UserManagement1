<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>添加用户</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        h2 { color: #333; }
        form { width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; }
        input { width: 100%; padding: 8px; box-sizing: border-box; }
        button { padding: 10px 20px; background-color: #4CAF50; color: white; border: none; cursor: pointer; }
        button:hover { background-color: #45a049; }
    </style>
</head>
<body>
    <div style="text-align: center;">
        <h2>添加新用户</h2>
        <form action="insertShow.jsp" method="post">
            <div class="form-group">
                <label>姓名：</label>
                <input type="text" name="name" required>
            </div>
            <div class="form-group">
                <label>密码：</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>邮箱：</label>
                <input type="email" name="email">
            </div>
            <div class="form-group">
                <label>电话：</label>
                <input type="text" name="phone">
            </div>
            <button type="submit">添加</button>
        </form>
        <br>
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
