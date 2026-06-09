package control;

import entity.Student;
import model.StudentModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * 学生信息列表 Servlet
 * URL 映射：/ListStudentServlet.do（由 web.xml 配置，避免与注解重复映射）
 */
public class ListStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        StudentModel model = new StudentModel();
        List<Student> list = model.listAll();

        req.setAttribute("studentList", list);
        String msg = req.getParameter("msg");
        if (msg != null) {
            req.setAttribute("msg", msg);
        }
        req.getRequestDispatcher("/jsp/studentlist.jsp").forward(req, resp);
    }
}
