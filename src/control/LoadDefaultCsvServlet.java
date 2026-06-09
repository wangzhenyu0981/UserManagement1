package control;

import entity.Student;
import model.StudentModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.util.List;

/**
 * 直接导入服务器上预置的 CSV 文件（实验任务 2 的一种入口）。
 *
 * <p>读取路径：<code>/data/学生导入.csv</code>（即项目 <code>web/data/学生导入.csv</code>）。
 * 该路径下的文件会在 Tomcat 部署时随 web 应用一同发布。
 *
 * <p>复用 ImportStudentServlet 中的编码探测、CSV 解析、批量入库逻辑。
 */
public class LoadDefaultCsvServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /** 可通过 ?file=data/xxx.csv 切换读取的文件；默认值。 */
    private static final String DEFAULT_PATH = "/data/学生导入.csv";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        try {
            // 1. 决定要读取的资源路径
            String fileParam = req.getParameter("file");
            String resourcePath = DEFAULT_PATH;
            if (fileParam != null && !fileParam.trim().isEmpty()) {
                // 做一点安全加固：必须以 /data/ 开头或只给文件名
                String name = fileParam.trim();
                if (!name.startsWith("/")) name = "/" + name;
                if (!name.startsWith("/data/")) name = "/data/" + (name.startsWith("/") ? name.substring(1) : name);
                resourcePath = name;
            }

            // 2. 读取文件内容（ServletContext 的资源读取，jar/war 部署也能工作）
            try (InputStream is = getServletContext().getResourceAsStream(resourcePath)) {
                if (is == null) {
                    ImportStudentServlet.redirectWithMessage(req, resp,
                            "找不到服务器端 CSV 文件：" + resourcePath + "。请确认 web/data/ 目录下存在该文件。");
                    return;
                }
                byte[] bytes = ImportStudentServlet.readAllBytes(is);

                // 3. 探测编码 + 解析
                Charset detected = ImportStudentServlet.detectCharset(bytes);
                System.out.println("[LoadDefaultCsvServlet] 读取 " + resourcePath + ", "
                        + bytes.length + "B, 探测编码: " + detected.name());
                List<Student> students = ImportStudentServlet.parseStudentsFromStream(
                        new ByteArrayInputStream(bytes), detected);

                if (students.isEmpty()) {
                    ImportStudentServlet.redirectWithMessage(req, resp,
                            "文件 " + resourcePath + " 中没有识别到任何有效学生数据（编码: " + detected.name() + "）。");
                    return;
                }

                // 4. 写入数据库
                StudentModel model = new StudentModel();
                int inserted = model.batchInsert(students);
                String errors = model.getLastBatchErrors();

                String msg;
                if (inserted == students.size()) {
                    msg = "【批量导入成功】来源：服务器文件 " + resourcePath + "（编码 " + detected.name()
                            + "）；共解析 " + students.size() + " 条，已全部入库 " + inserted + " 条。";
                } else {
                    msg = "【批量导入完成，部分失败】来源：服务器文件 " + resourcePath + "（编码 " + detected.name()
                            + "）；共解析 " + students.size() + " 条，成功入库 " + inserted + " 条，失败 "
                            + (students.size() - inserted) + " 条。" + (errors != null ? " 原因：" + errors : "");
                }
                System.out.println("[LoadDefaultCsvServlet] " + msg);
                ImportStudentServlet.redirectWithMessage(req, resp, msg);
            }
        } catch (Exception e) {
            e.printStackTrace();
            ImportStudentServlet.redirectWithMessage(req, resp,
                    "批量导入异常：" + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }
}
