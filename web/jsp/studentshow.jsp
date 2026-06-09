<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Student" %>
<%
    Student s = (Student) request.getAttribute("student");
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/ListStudentServlet.do");
        return;
    }
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>确认删除学生信息 - 学生信息管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: "PingFang SC", "Microsoft YaHei", "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            min-height: 100vh;
            margin: 0;
            padding: 30px 20px;
            color: #333;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }
        .container {
            background: #fff;
            padding: 30px 36px;
            border-radius: 14px;
            box-shadow: 0 20px 60px rgba(0,0,0,.20);
            width: 560px;
            max-width: 100%;
            animation: fadeIn .4s ease-out;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

        .hero {
            display: flex;
            align-items: center;
            gap: 14px;
            padding-bottom: 16px;
            border-bottom: 1px solid #eee;
            margin-bottom: 18px;
        }
        .hero .logo {
            width: 44px; height: 44px; border-radius: 12px;
            background: linear-gradient(135deg, #eb3349, #f45c43);
            color: #fff; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 6px 16px rgba(235,51,73,.35);
            font-size: 22px;
        }
        .hero h1 { margin: 0; font-size: 20px; color: #2b2b3c; }
        .hero .sub { font-size: 12px; color: #8a8fa3; margin-top: 4px; }

        .warn {
            padding: 14px 16px;
            background: #fff5f5;
            color: #c62828;
            border: 1px solid #ffcdd2;
            border-left: 4px solid #f45c43;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 18px;
            line-height: 1.6;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 18px rgba(0,0,0,.06);
            border: 1px solid #eef0f7;
            margin-bottom: 18px;
        }
        th, td {
            padding: 12px 14px;
            text-align: left;
            font-size: 14px;
            border-bottom: 1px solid #f0f2f7;
        }
        th {
            background: linear-gradient(135deg, #fff5f5, #ffebee);
            color: #c62828;
            width: 110px;
            font-weight: 600;
        }
        td { color: #3b3b50; }
        tr:last-child th, tr:last-child td { border-bottom: none; }

        .btn-row { display: flex; gap: 12px; margin-top: 6px; }
        .btn {
            padding: 12px 20px;
            text-decoration: none;
            color: #fff;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            flex: 1;
            text-align: center;
            transition: transform .15s ease, filter .15s, box-shadow .15s;
            box-shadow: 0 4px 12px rgba(0,0,0,.10);
        }
        .btn:hover { transform: translateY(-1px); filter: brightness(1.05); }
        .btn-delete { background: linear-gradient(135deg, #eb3349, #f45c43); }
        .btn-cancel {
            background: #fff;
            color: #555;
            border: 1.5px solid #dbe1ec;
            box-shadow: none;
            font-weight: 500;
        }
        .btn-cancel:hover { border-color: #b9c1d6; }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero">
            <div class="logo">!</div>
            <div>
                <h1>确认删除学生信息</h1>
                <div class="sub">以下学生将被永久删除，操作不可撤销</div>
            </div>
        </div>

        <div class="warn">⚠ 请仔细核对以下学生信息，确认无误后再点击「确认删除」。</div>

        <table>
            <tr><th>ID</th><td><%= s.getId() %></td></tr>
            <tr><th>学号</th><td><%= s.getSno() %></td></tr>
            <tr><th>姓名</th><td><%= s.getSname() %></td></tr>
            <tr><th>性别</th><td><%= s.getGender() == null ? "" : s.getGender() %></td></tr>
            <tr><th>年龄</th><td><%= s.getAge() %></td></tr>
            <tr><th>专业</th><td><%= s.getMajor() == null ? "" : s.getMajor() %></td></tr>
            <tr><th>成绩</th><td><%= String.format("%.2f", s.getGrade()) %></td></tr>
        </table>

        <div class="btn-row">
            <form action="<%= ctx %>/DeleteStudentServlet.do" method="post" style="flex:1;">
                <input type="hidden" name="id" value="<%= s.getId() %>">
                <button type="submit" class="btn btn-delete">确认删除</button>
            </form>
            <a href="<%= ctx %>/ListStudentServlet.do" class="btn btn-cancel" style="flex:1; display:flex; align-items:center; justify-content:center;">返回列表</a>
        </div>
    </div>
</body>
</html>
