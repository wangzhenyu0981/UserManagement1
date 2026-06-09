<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="entity.Student" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLDecoder" %>
<%
    Object obj = request.getAttribute("studentList");
    @SuppressWarnings("unchecked")
    List<Student> list = (List<Student>) obj;

    String msg = null;
    Object attr = request.getAttribute("msg");
    if (attr != null) msg = attr.toString();
    if (msg == null || msg.isEmpty()) {
        String q = request.getParameter("msg");
        if (q != null && !q.isEmpty()) {
            try { msg = URLDecoder.decode(q, "UTF-8"); } catch (Exception e) { msg = q; }
        }
    }
    if (msg == null) msg = "";

    String ctx = request.getContextPath();

    // 根据 msg 内容决定是 success / info / error
    String msgCls = "msg msg-info";
    if (msg.contains("成功")) msgCls = "msg msg-success";
    else if (msg.contains("失败") || msg.contains("异常") || msg.contains("Error") || msg.toLowerCase().contains("fail")) msgCls = "msg msg-error";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>学生信息列表 - 学生信息管理系统</title>
    <style>
        * { box-sizing: border-box; }
        body {
            font-family: "PingFang SC", "Microsoft YaHei", "Segoe UI", Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            margin: 0;
            padding: 30px 20px;
            color: #333;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: #fff;
            padding: 30px 34px;
            border-radius: 14px;
            box-shadow: 0 20px 60px rgba(0,0,0,.18);
            animation: fadeIn .4s ease-out;
        }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

        /* 顶部标题区 */
        .hero {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
            margin-bottom: 22px;
        }
        .hero .title {
            display: flex;
            align-items: center;
            gap: 14px;
        }
        .hero .logo {
            width: 48px; height: 48px; border-radius: 12px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            display: flex; align-items: center; justify-content: center;
            color: #fff; font-size: 24px; font-weight: 700;
            box-shadow: 0 6px 16px rgba(102, 126, 234, .35);
        }
        .hero h1 { font-size: 22px; margin: 0; color: #2b2b3c; letter-spacing: 1px; }
        .hero .sub { font-size: 13px; color: #888; margin-top: 4px; }

        /* 消息条 */
        .msg {
            padding: 12px 16px;
            border-radius: 10px;
            margin-bottom: 18px;
            font-size: 14px;
            line-height: 1.6;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .msg::before { content: "ℹ"; color: inherit; font-weight: bold; }
        .msg-success { background: #e8f5e9; color: #2e7d32; border: 1px solid #c8e6c9; }
        .msg-success::before { content: "✓"; }
        .msg-error   { background: #ffebee; color: #c62828; border: 1px solid #ffcdd2; }
        .msg-error::before   { content: "✕"; }
        .msg-info    { background: #e3f2fd; color: #1565c0; border: 1px solid #bbdefb; }

        /* 按钮 */
        .toolbar {
            display: flex; flex-wrap: wrap; gap: 10px;
            margin-bottom: 18px; align-items: center;
        }
        .btn {
            padding: 10px 18px;
            text-decoration: none;
            color: #fff;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            font-size: 13px;
            font-weight: 600;
            transition: transform .15s ease, box-shadow .15s ease, filter .15s;
            box-shadow: 0 4px 12px rgba(0,0,0,.08);
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        .btn:hover { transform: translateY(-1px); filter: brightness(1.05); box-shadow: 0 6px 16px rgba(0,0,0,.12); }
        .btn:active { transform: translateY(0); }
        .btn-add    { background: linear-gradient(135deg, #43cea2, #185a9d); }
        .btn-import { background: linear-gradient(135deg, #36d1dc, #5b86e5); }
        .btn-update { background: linear-gradient(135deg, #2193b0, #6dd5ed); }
        .btn-show   { background: linear-gradient(135deg, #f7971e, #ffd200); color: #3b2b00; }
        .btn-delete { background: linear-gradient(135deg, #eb3349, #f45c43); }

        /* 导入区 */
        .form-block {
            background: linear-gradient(180deg, #f8faff 0%, #fff 100%);
            padding: 18px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            border: 1px solid #e6ecff;
            box-shadow: inset 0 0 0 1px #fff;
        }
        .form-block h3 {
            margin: 0 0 12px 0;
            font-size: 15px;
            color: #3f3f58;
            display: flex; align-items: center; gap: 8px;
        }
        .form-block h3::before {
            content: ""; display: inline-block; width: 4px; height: 16px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
        .form-block p { margin: 6px 0; color: #555; font-size: 13px; line-height: 1.7; }
        .form-block .row { display: flex; gap: 10px; align-items: center; flex-wrap: wrap; margin-top: 10px; }
        .form-block textarea {
            width: 100%;
            min-height: 110px;
            padding: 12px;
            border: 1px solid #dbe1ec;
            border-radius: 8px;
            font-family: Consolas, "Courier New", monospace;
            font-size: 13px;
            resize: vertical;
            transition: border-color .15s, box-shadow .15s;
        }
        .form-block textarea:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,.15); }
        .form-block .hint { font-size: 12px; color: #8a8fa3; margin-top: 6px; }
        .form-block input[type=file] {
            font-size: 13px;
            padding: 8px 10px;
            background: #fff;
            border: 1px dashed #c9d2e8;
            border-radius: 8px;
            cursor: pointer;
        }

        /* 表格 */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            margin-top: 6px;
            overflow: hidden;
            border-radius: 12px;
            box-shadow: 0 4px 18px rgba(0,0,0,.06);
            background: #fff;
        }
        thead th {
            background: linear-gradient(135deg, #f5f7ff, #ebf0ff);
            color: #3f3f58;
            font-weight: 600;
            font-size: 13px;
            padding: 14px 10px;
            text-align: center;
            letter-spacing: .5px;
            border-bottom: 2px solid #e6ecff;
        }
        tbody td {
            padding: 13px 10px;
            text-align: center;
            font-size: 14px;
            border-bottom: 1px solid #f0f2f7;
            color: #3b3b50;
        }
        tbody tr:hover { background: #f7f9ff; }
        tbody tr:last-child td { border-bottom: none; }

        .grade { font-weight: 700; color: #2b2b3c; }
        .grade.high { color: #2e7d32; }
        .grade.mid  { color: #ef6c00; }
        .grade.low  { color: #c62828; }

        .empty {
            padding: 50px 10px;
            text-align: center;
            color: #9aa0b4;
            font-size: 14px;
        }
        .empty .emoji { font-size: 40px; display: block; margin-bottom: 12px; }

        /* 表格里的按钮更小一些 */
        .cell-btn {
            padding: 6px 12px;
            font-size: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,.12);
        }

        .footer { margin-top: 24px; text-align: center; color: #aaa; font-size: 12px; }
    </style>
</head>
<body>
<div class="container">
    <div class="hero">
        <div class="title">
            <div class="logo">S</div>
            <div>
                <h1>学生信息管理系统</h1>
                <div class="sub">Student Management · 基于 JSP + Servlet + JavaBean</div>
            </div>
        </div>
        <div style="font-size:13px; color:#8a8fa3;">
            当前共 <%= list == null ? 0 : list.size() %> 条学生记录
        </div>
    </div>

    <% if (msg != null && !msg.isEmpty()) { %>
        <div class="<%= msgCls %>"><%= msg %></div>
    <% } %>

    <!-- ========= 工具条 ========= -->
    <div class="toolbar">
        <a href="<%= ctx %>/jsp/studentinsert.jsp" class="btn btn-add">＋ 新增学生</a>
    </div>

    <!-- ========== CSV 批量导入区 ========== -->
    <div class="form-block">
        <h3>任务 2 · 批量导入学生信息</h3>
        <p>支持 <b>上传 CSV / TXT 文件</b> 或 <b>粘贴文本</b>。Excel → 文件 → 另存为 → 选择 <b style="color:#1565c0;">「CSV UTF-8（逗号分隔）」</b> 或 「CSV（逗号分隔）」 即可；系统会自动检测 <b>GBK / UTF-8</b> 编码。</p>
        <p><b>每行格式：</b><code style="background:#fff; padding:2px 6px; border-radius:4px; border:1px solid #e6ecff;">学号,姓名,性别,年龄,专业,成绩</code>；首行若为中文表头会被自动跳过。</p>

        <div class="row">
            <form action="<%= ctx %>/ImportStudentServlet.do" method="post" enctype="multipart/form-data" style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                <input type="file" name="csvFile" id="csvFile" accept=".csv,.txt" />
                <button type="submit" class="btn btn-import">① 上传 CSV 文件并导入</button>
            </form>
        </div>

        <div class="row">
            <form action="<%= ctx %>/LoadDefaultCsvServlet.do" method="post" style="display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                <button type="submit" class="btn btn-import">③ 一键导入服务器默认 CSV（data/学生导入.csv）</button>
                <span class="hint">CSV 已放置在服务器，可直接导入体验批量功能。</span>
            </form>
        </div>

        <form action="<%= ctx %>/ImportStudentServlet.do" method="post">
            <textarea name="csvText" rows="6" placeholder="② 粘贴 CSV 文本到此处（或从 Excel 复制区域粘贴）。示例：
2131,王撒,男,20,软件工程,88.5
2132,李雅婷,女,19,计算机科学与技术,76.0
2133,陈建国,男,22,人工智能,91.5"></textarea>
            <div class="row">
                <button type="submit" class="btn btn-import">② 粘贴文本并导入</button>
                <span class="hint">导入完成后自动返回本页并显示结果。</span>
            </div>
        </form>
    </div>

    <!-- ========= 学生列表 ========= -->
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>学号</th>
                <th>姓名</th>
                <th>性别</th>
                <th>年龄</th>
                <th>专业</th>
                <th>成绩</th>
                <th style="min-width:160px;">操作</th>
            </tr>
        </thead>
        <tbody>
        <% if (list == null || list.isEmpty()) { %>
            <tr><td colspan="8" class="empty">
                <span class="emoji">📭</span>
                暂无学生数据 — 可从上方批量导入或点击「新增学生」添加。
            </td></tr>
        <% } else {
            for (Student s : list) {
                double g = s.getGrade();
                String gcls = "grade";
                if (g >= 85) gcls = "grade high";
                else if (g >= 60) gcls = "grade mid";
                else gcls = "grade low";
        %>
            <tr>
                <td><%= s.getId() %></td>
                <td><%= s.getSno() %></td>
                <td><%= s.getSname() %></td>
                <td><%= s.getGender() == null ? "" : s.getGender() %></td>
                <td><%= s.getAge() %></td>
                <td><%= s.getMajor() == null ? "" : s.getMajor() %></td>
                <td class="<%= gcls %>"><%= String.format("%.2f", g) %></td>
                <td>
                    <form action="<%= ctx %>/UpStudentServlet.do" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= s.getId() %>">
                        <button type="submit" class="btn btn-update cell-btn">✎ 修改</button>
                    </form>
                    <form action="<%= ctx %>/ShowStudentServlet.do" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= s.getId() %>">
                        <button type="submit" class="btn btn-delete cell-btn">🗑 删除</button>
                    </form>
                </td>
            </tr>
        <% } } %>
        </tbody>
    </table>

    <div class="footer">© 学生信息管理系统 · Java Web Demo</div>
</div>
</body>
</html>
