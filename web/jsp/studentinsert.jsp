<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String ctx = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新增学生信息 - 学生信息管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: "PingFang SC", "Microsoft YaHei", "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
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
            box-shadow: 0 20px 60px rgba(0,0,0,.18);
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
            margin-bottom: 22px;
        }
        .hero .logo {
            width: 44px; height: 44px; border-radius: 12px;
            background: linear-gradient(135deg, #43cea2, #185a9d);
            color: #fff; font-weight: 700;
            display: flex; align-items: center; justify-content: center;
            box-shadow: 0 6px 16px rgba(67,206,162,.35);
        }
        .hero h1 { margin: 0; font-size: 20px; color: #2b2b3c; }
        .hero .sub { font-size: 12px; color: #8a8fa3; margin-top: 4px; }

        .row { display: flex; gap: 12px; }
        .row > div { flex: 1; }

        form label {
            display: block;
            margin-bottom: 6px;
            color: #3f3f58;
            font-size: 13px;
            font-weight: 600;
        }
        form input[type=text], form input[type=number], form select {
            width: 100%;
            padding: 11px 14px;
            margin-bottom: 14px;
            border: 1.5px solid #dbe1ec;
            border-radius: 8px;
            font-size: 14px;
            background: #fafbff;
            transition: border-color .15s, box-shadow .15s, background .15s;
            color: #3b3b50;
        }
        form input:focus, form select:focus {
            outline: none;
            border-color: #43cea2;
            background: #fff;
            box-shadow: 0 0 0 3px rgba(67,206,162,.18);
        }

        .btn-row { display: flex; gap: 12px; margin-top: 10px; }
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
        .btn-submit { background: linear-gradient(135deg, #43cea2, #185a9d); }
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
            <div class="logo">＋</div>
            <div>
                <h1>新增学生信息</h1>
                <div class="sub">填写下方表单后点击「提交」即可入库</div>
            </div>
        </div>
        <form action="<%= ctx %>/InsertStudentServlet.do" method="post">
            <label>学号</label>
            <input type="text" name="sno" required placeholder="例如：2024001">

            <label>姓名</label>
            <input type="text" name="sname" required placeholder="请输入真实姓名">

            <div class="row">
                <div>
                    <label>性别</label>
                    <select name="gender">
                        <option value="男">男</option>
                        <option value="女">女</option>
                    </select>
                </div>
                <div>
                    <label>年龄</label>
                    <input type="number" name="age" min="1" max="150" value="20">
                </div>
            </div>

            <label>专业</label>
            <input type="text" name="major" placeholder="例如：软件工程">

            <label>成绩</label>
            <input type="number" name="grade" step="0.01" min="0" max="100" value="80.0">

            <div class="btn-row">
                <button type="submit" class="btn btn-submit">提交</button>
                <a href="<%= ctx %>/ListStudentServlet.do" class="btn btn-cancel">返回列表</a>
            </div>
        </form>
    </div>
</body>
</html>
