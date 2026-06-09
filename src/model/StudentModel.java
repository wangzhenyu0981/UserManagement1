package model;

import dbutil.Dbconn;
import entity.Student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class StudentModel {

    // -------------------- 查询学生列表 --------------------
    public List<Student> listAll() {
        List<Student> list = new ArrayList<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = Dbconn.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT id, sno, sname, gender, age, major, grade FROM student ORDER BY id ASC");
            while (rs.next()) {
                Student s = new Student();
                s.setId(rs.getInt("id"));
                s.setSno(rs.getString("sno"));
                s.setSname(rs.getString("sname"));
                s.setGender(rs.getString("gender"));
                s.setAge(rs.getInt("age"));
                s.setMajor(rs.getString("major"));
                s.setGrade(rs.getDouble("grade"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            Dbconn.close(conn, stmt, rs);
        }
        return list;
    }

    // -------------------- 新增学生 --------------------
    public boolean insertStudent(Student stu) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "INSERT INTO student (sno, sname, gender, age, major, grade) VALUES (?,?,?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stu.getSno());
            pstmt.setString(2, stu.getSname());
            pstmt.setString(3, stu.getGender());
            pstmt.setInt(4, stu.getAge());
            pstmt.setString(5, stu.getMajor());
            pstmt.setDouble(6, stu.getGrade());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Dbconn.close(conn, pstmt, null);
        }
    }

    // -------------------- 根据 id 查询单个学生 --------------------
    public Student selectStudentById(int id) {
        Student stu = null;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "SELECT id, sno, sname, gender, age, major, grade FROM student WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                stu = new Student();
                stu.setId(rs.getInt("id"));
                stu.setSno(rs.getString("sno"));
                stu.setSname(rs.getString("sname"));
                stu.setGender(rs.getString("gender"));
                stu.setAge(rs.getInt("age"));
                stu.setMajor(rs.getString("major"));
                stu.setGrade(rs.getDouble("grade"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            Dbconn.close(conn, pstmt, rs);
        }
        return stu;
    }

    // -------------------- 更新学生信息 --------------------
    public boolean updateStudent(Student stu) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "UPDATE student SET sno=?, sname=?, gender=?, age=?, major=?, grade=? WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, stu.getSno());
            pstmt.setString(2, stu.getSname());
            pstmt.setString(3, stu.getGender());
            pstmt.setInt(4, stu.getAge());
            pstmt.setString(5, stu.getMajor());
            pstmt.setDouble(6, stu.getGrade());
            pstmt.setInt(7, stu.getId());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Dbconn.close(conn, pstmt, null);
        }
    }

    // -------------------- 删除学生 --------------------
    public boolean deleteStudent(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = Dbconn.getConnection();
            String sql = "DELETE FROM student WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            Dbconn.close(conn, pstmt, null);
        }
    }

    // -------------------- 批量插入（用于 CSV / Excel 导入） --------------------
    // 方案 A：逐条插入（推荐，失败不会连累其他行，也无需处理事务回滚）
    public int batchInsert(List<Student> list) {
        if (list == null || list.isEmpty()) return 0;
        int count = 0;
        StringBuilder errors = new StringBuilder();
        int lineNo = 0;
        for (Student stu : list) {
            lineNo++;
            try {
                if (insertStudent(stu)) {
                    count++;
                } else {
                    if (errors.length() > 0) errors.append("；");
                    errors.append("第").append(lineNo).append("行[")
                          .append(stu.getSno()).append(",").append(stu.getSname())
                          .append("]未入库(返回false)");
                }
            } catch (Exception e) {
                if (errors.length() > 0) errors.append("；");
                errors.append("第").append(lineNo).append("行[")
                      .append(stu.getSno()).append(",").append(stu.getSname())
                      .append("]异常:").append(e.getMessage());
            }
        }
        lastBatchErrors = errors.length() == 0 ? null : errors.toString();
        return count;
    }

    /** 批量插入过程中收集到的失败原因，供页面回显给用户。 */
    private String lastBatchErrors;
    public String getLastBatchErrors() { return lastBatchErrors; }
    public void clearLastBatchErrors() { lastBatchErrors = null; }

    // 方案 B：真正的 JDBC batch 版本（高效但一条失败就可能全回滚；保留用于后续优化）
    public int batchInsertJdbcBatch(List<Student> list) {
        int count = 0;
        if (list == null || list.isEmpty()) return 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = Dbconn.getConnection();
            conn.setAutoCommit(false);
            String sql = "INSERT INTO student (sno, sname, gender, age, major, grade) VALUES (?,?,?,?,?,?)";
            pstmt = conn.prepareStatement(sql);
            for (Student stu : list) {
                pstmt.setString(1, stu.getSno());
                pstmt.setString(2, stu.getSname());
                pstmt.setString(3, stu.getGender());
                pstmt.setInt(4, stu.getAge());
                pstmt.setString(5, stu.getMajor());
                pstmt.setDouble(6, stu.getGrade());
                pstmt.addBatch();
            }
            int[] result = pstmt.executeBatch();
            conn.commit();
            for (int i : result) {
                if (i > 0 || i == Statement.SUCCESS_NO_INFO) count++;
            }
        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ignored) {}
            e.printStackTrace();
            throw new RuntimeException("JDBC 批量插入失败: " + e.getMessage(), e);
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException ignored) {}
            Dbconn.close(conn, pstmt, null);
        }
        return count;
    }
}
