package control;

import entity.Student;
import model.StudentModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * 新增学生信息 Servlet
 * URL 映射：/InsertStudentServlet.do（由 web.xml 配置，避免与注解重复映射）
 */
public class InsertStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        try {
            String sno = req.getParameter("sno");
            String sname = req.getParameter("sname");
            String gender = req.getParameter("gender");
            int age = 0;
            try {
                age = Integer.parseInt(req.getParameter("age"));
            } catch (NumberFormatException ignored) {}
            String major = req.getParameter("major");
            double grade = 0;
            try {
                String g = req.getParameter("grade");
                if (g != null && !g.trim().isEmpty()) grade = Double.parseDouble(g.trim());
            } catch (NumberFormatException ignored) {}

            Student stu = new Student(sno, sname, gender, age, major, grade);
            StudentModel model = new StudentModel();
            boolean ok = model.insertStudent(stu);
            resp.sendRedirect(req.getContextPath() + "/ListStudentServlet.do?msg="
                    + (ok ? java.net.URLEncoder.encode("新增学生信息成功！", "UTF-8")
                          : java.net.URLEncoder.encode("新增学生信息失败！", "UTF-8")));
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/jsp/studentinsert.jsp");
        }
    }
}
