package control;

import entity.Student;
import model.StudentModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 删除前：根据 id 查询学生信息，展示在 studentshow.jsp 确认页面。
 * URL 映射：/ShowStudentServlet.do（由 web.xml 配置，避免与注解重复映射）
 */
public class ShowStudentServlet extends HttpServlet {
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
        Student stu = model.selectStudentById(id);
        if (stu == null) {
            resp.sendRedirect(req.getContextPath() + "/ListStudentServlet.do");
            return;
        }

        req.setAttribute("student", stu);
        req.getRequestDispatcher("/jsp/studentshow.jsp").forward(req, resp);
    }
}
