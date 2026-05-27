<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户综合管理系统</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 0;
            padding: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .container {
            background-color: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            width: 500px;
        }
        h1 { 
            color: #333; 
            text-align: center;
            margin-bottom: 30px;
        }
        .nav-buttons {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        .nav-button {
            padding: 20px;
            text-align: center;
            text-decoration: none;
            color: white;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .nav-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .add { background-color: #4CAF50; }
        .update { background-color: #2196F3; }
        .delete { background-color: #f44336; }
        .search { background-color: #9C27B0; }
        .show-all { background-color: #FF9800; grid-column: span 2; }
    </style>
</head>
<body>
    <div class="container">
        <h1>用户综合管理系统</h1>
        <div class="nav-buttons">
            <a href="insert.jsp" class="nav-button add">添加用户</a>
            <a href="update.jsp" class="nav-button update">更新用户</a>
            <a href="dele.jsp" class="nav-button delete">删除用户</a>
            <a href="search.jsp" class="nav-button search">查询用户</a>
            <a href="allShow.jsp" class="nav-button show-all">显示所有用户</a>
        </div>
    </div>
</body>
</html>
