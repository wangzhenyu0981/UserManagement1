package control;

import model.StudentModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 删除后：根据 id 执行删除操作，返回学生列表页面。
 * URL 映射：/DeleteStudentServlet.do（由 web.xml 配置，避免与注解重复映射）
 */
public class DeleteStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        int id = 0;
        try {
            id = Integer.parseInt(req.getParameter("id"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/ListStudentServlet.do");
            return;
        }

        StudentModel model = new StudentModel();
        boolean ok = model.deleteStudent(id);
        resp.sendRedirect(req.getContextPath() + "/ListStudentServlet.do?msg="
                + (ok ? java.net.URLEncoder.encode("删除学生信息成功！", "UTF-8")
                      : java.net.URLEncoder.encode("删除学生信息失败！", "UTF-8")));
    }
}
