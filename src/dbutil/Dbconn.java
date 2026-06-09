package dbutil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * MySQL 数据库连接工具类。
 * 
 * <p>针对 MySQL 8.4.x + mysql-connector-j 8.4.0 的最新默认安全策略，
 * URL 参数已显式指定 TLS/SSL 行为、时区、字符编码和认证协议，
 * 避免在新环境上出现 "Public Key Retrieval is not allowed"、
 * "TLS 1.2 required"、"Unknown system variable 'transaction_isolation'" 等常见异常。
 * 
 * <p>部署时请务必根据自己的 MySQL 实例修改 URL、USERNAME、PASSWORD。
 */
public class Dbconn {

    /**
     * JDBC URL。
     * 说明：MySQL 8.4.x 客户端默认启用 TLS，
     * 本地开发时 useSSL=false 即可；如启用 SSL，
     * 请加上 useSSL=true&requireSSL=true&verifyServerCertificate=false。
     */
    private static final String URL =
            "jdbc:mysql://localhost:3306/students"
            + "?useUnicode=true"
            + "&characterEncoding=utf8"
            + "&serverTimezone=Asia/Shanghai"
            + "&useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&useInformationSchema=true"
            + "&nullCatalogMeansCurrent=true"
            + "&connectTimeout=5000"
            + "&socketTimeout=30000";

    private static final String USERNAME = "root";
    private static final String PASSWORD = "a123456";

    /**
     * mysql-connector-j 8.x 会通过 META-INF/services/java.sql.Driver
     * 自动注册驱动；此处仅保留一个兜底手动加载步骤，
     * 以兼容部分未扫描 SPI 的 ClassLoader 场景。
     */
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("[Dbconn] 找不到 MySQL 驱动 com.mysql.cj.jdbc.Driver，请确认 web/WEB-INF/lib 下有 mysql-connector-j-8.4.0.jar");
            e.printStackTrace();
        }
    }

    /** 获取一个新的 JDBC Connection（调用方需在 try-with-resources 中使用并关闭）。 */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    /** 统一的资源关闭工具：按 ResultSet → Statement → Connection 的顺序关闭。 */
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        close(conn, (Statement) pstmt, rs);
    }
}
