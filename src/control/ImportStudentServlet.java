package control;

import entity.Student;
import model.StudentModel;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

/**
 * 批量导入学生信息 Servlet。
 *
 * <p><b>关键设计：</b>
 * <ol>
 *   <li>Excel 在 Windows 中文版「另存为 CSV」默认是 <b>GBK 编码</b>；
 *       在 macOS / 新版 Excel「另存为 CSV UTF-8」才是 UTF-8（部分文件带 BOM）。
 *       因此本 Servlet 先读取前 4KB 做自动探测（BOM + 汉字字节统计），
 *       探测失败回落到 UTF-8。</li>
 *   <li>支持两种入口：① 上传 .csv / .txt 文件；② 在文本框中直接粘贴 CSV 文本。</li>
 *   <li>每行格式：<code>学号,姓名,性别,年龄,专业,联系电话</code>；第一行若是「学号,...」表头会被自动跳过。</li>
 *   <li>入库采用<b>逐条 INSERT</b>而非 addBatch，以保证某一行失败不会连累其他行。</li>
 * </ol>
 */
@MultipartConfig
public class ImportStudentServlet extends HttpServlet {

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
            // ---------- 1. 读入原始数据（文本框 or 文件） ----------
            String text = req.getParameter("csvText");
            List<Student> students;
            String sourceInfo;

            if (text != null && !text.trim().isEmpty()) {
                students = parseStudentsFromStream(new ByteArrayInputStream(text.getBytes(StandardCharsets.UTF_8)), StandardCharsets.UTF_8);
                sourceInfo = "粘贴文本（UTF-8）";
            } else {
                Part filePart = req.getPart("csvFile");
                if (filePart == null || filePart.getSize() == 0) {
                    redirectWithMessage(req, resp, "请先选择 CSV/TXT 文件，或在下方文本框中粘贴内容再导入！");
                    return;
                }
                String fileName = safeFileName(filePart.getSubmittedFileName());
                String lower = fileName == null ? "" : fileName.toLowerCase();
                if (!lower.endsWith(".csv") && !lower.endsWith(".txt")) {
                    redirectWithMessage(req, resp, "不支持的文件类型 [" + fileName + "]，请上传 .csv 或 .txt。");
                    return;
                }
                byte[] bytes = readAllBytes(filePart.getInputStream());
                Charset detected = detectCharset(bytes);
                System.out.println("[ImportStudentServlet] 上传文件 " + fileName + ", 大小 " + bytes.length + "B, 探测编码: " + detected.name());
                students = parseStudentsFromStream(new ByteArrayInputStream(bytes), detected);
                sourceInfo = "文件 " + fileName + "（编码 " + detected.name() + "）";
            }

            // ---------- 2. 解析检查 ----------
            if (students.isEmpty()) {
                redirectWithMessage(req, resp, "没有识别到任何有效学生行。请确认：每行至少有学号、姓名两列，且用英文逗号分隔。");
                return;
            }

            // ---------- 3. 写入数据库 ----------
            StudentModel model = new StudentModel();
            int inserted = model.batchInsert(students);
            String errors = model.getLastBatchErrors();

            String msg;
            if (inserted == students.size()) {
                msg = "【批量导入成功】来源：" + sourceInfo + "；共解析 " + students.size() + " 条，已全部入库 " + inserted + " 条。";
            } else {
                msg = "【批量导入完成，部分失败】来源：" + sourceInfo
                    + "；共解析 " + students.size() + " 条，成功入库 " + inserted + " 条，失败 " + (students.size() - inserted) + " 条。"
                    + (errors != null ? " 原因：" + errors : "");
            }
            System.out.println("[ImportStudentServlet] " + msg);
            redirectWithMessage(req, resp, msg);
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithMessage(req, resp, "批量导入异常：" + e.getClass().getSimpleName() + " - " + e.getMessage());
        }
    }

    // ============================================================
    // 工具方法（其他 Servlet 可复用）
    // ============================================================

    static void redirectWithMessage(HttpServletRequest req, HttpServletResponse resp, String msg) throws IOException {
        String encoded = URLEncoder.encode(msg, "UTF-8");
        resp.sendRedirect(req.getContextPath() + "/ListStudentServlet.do?msg=" + encoded);
    }

    static String safeFileName(String fn) {
        if (fn == null) return "";
        int idx = Math.max(fn.lastIndexOf('/'), fn.lastIndexOf('\\'));
        return idx >= 0 ? fn.substring(idx + 1) : fn;
    }

    static byte[] readAllBytes(InputStream in) throws IOException {
        java.io.ByteArrayOutputStream buf = new java.io.ByteArrayOutputStream();
        byte[] tmp = new byte[4096];
        int n;
        while ((n = in.read(tmp)) > 0) buf.write(tmp, 0, n);
        in.close();
        return buf.toByteArray();
    }

    /**
     * 自动探测编码：
     * 1) 若有 UTF-8 / UTF-16 BOM → 直接判定
     * 2) 用 UTF-8 解码前 4KB，统计替换字符 U+FFFD 比例
     * 3) 统计可能的 GBK 合法双字节数量
     * 4) 综合判断返回 GBK 或 UTF-8
     */
    static Charset detectCharset(byte[] bytes) {
        if (bytes == null || bytes.length == 0) return StandardCharsets.UTF_8;
        if (bytes.length >= 3 && (bytes[0] & 0xFF) == 0xEF && (bytes[1] & 0xFF) == 0xBB && (bytes[2] & 0xFF) == 0xBF) {
            return StandardCharsets.UTF_8;
        }
        if (bytes.length >= 2 && ((bytes[0] & 0xFF) == 0xFF && (bytes[1] & 0xFF) == 0xFE)) {
            return StandardCharsets.UTF_16LE;
        }
        if (bytes.length >= 2 && ((bytes[0] & 0xFF) == 0xFE && (bytes[1] & 0xFF) == 0xFF)) {
            return StandardCharsets.UTF_16BE;
        }

        int probeLen = Math.min(bytes.length, 4096);
        String utf8Str = new String(bytes, 0, probeLen, StandardCharsets.UTF_8);
        int replacement = 0;
        for (int i = 0; i < utf8Str.length(); i++) if (utf8Str.charAt(i) == '\uFFFD') replacement++;

        int gbkPairs = 0;
        for (int i = 0; i < probeLen - 1; i++) {
            int b1 = bytes[i] & 0xFF;
            int b2 = bytes[i + 1] & 0xFF;
            if (b1 >= 0x81 && b1 <= 0xFE && b2 >= 0x40 && b2 <= 0xFE && b2 != 0x7F) gbkPairs++;
        }

        double ratio = utf8Str.length() == 0 ? 0 : ((double) replacement / utf8Str.length());
        if (ratio > 0.05 || (gbkPairs > 5 && replacement > 0)) {
            try { return Charset.forName("GBK"); } catch (Exception ignored) {}
        }
        return StandardCharsets.UTF_8;
    }

    static List<Student> parseStudentsFromStream(InputStream is, Charset charset) throws IOException {
        List<Student> list = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, charset))) {
            String line;
            int lineNo = 0;
            while ((line = reader.readLine()) != null) {
                lineNo++;
                // 去除可能存在的 UTF-8 BOM 首字符
                if (lineNo == 1 && line.length() > 0 && line.charAt(0) == '\uFEFF') {
                    line = line.substring(1);
                }
                if (line.trim().isEmpty()) continue;

                String[] cols = splitCsvLine(line);
                if (cols.length < 2) continue;
                String first = cols[0].trim();
                // 如果第一行是表头（学号 / sno / id / 序号），跳过
                if (lineNo == 1 && (first.equalsIgnoreCase("学号")
                        || first.equalsIgnoreCase("sno")
                        || first.equalsIgnoreCase("id")
                        || first.equalsIgnoreCase("序号"))) {
                    continue;
                }

                String sno = cols.length > 0 ? cols[0].trim() : "";
                String sname = cols.length > 1 ? cols[1].trim() : "";
                if (sno.isEmpty() || sname.isEmpty()) {
                    System.out.println("[ImportStudentServlet] 第 " + lineNo + " 行缺少学号或姓名，跳过: " + line);
                    continue;
                }
                String gender = cols.length > 2 ? cols[2].trim() : "";
                int age = 0;
                if (cols.length > 3) {
                    try {
                        age = Integer.parseInt(cols[3].trim());
                    } catch (NumberFormatException ignored) {}
                }
                String major = cols.length > 4 ? cols[4].trim() : "";
                double grade = 0;
                if (cols.length > 5) {
                    try {
                        grade = Double.parseDouble(cols[5].trim());
                    } catch (NumberFormatException ignored) {}
                }

                list.add(new Student(sno, sname, gender, age, major, grade));
            }
        }
        return list;
    }

    /**
     * 简单 CSV 行解析：支持双引号包裹字段（字段内可出现逗号或转义双引号）
     */
    static String[] splitCsvLine(String line) {
        List<String> fields = new ArrayList<>();
        StringBuilder cur = new StringBuilder();
        boolean inQuote = false;
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (inQuote) {
                if (c == '"') {
                    if (i + 1 < line.length() && line.charAt(i + 1) == '"') {
                        cur.append('"'); i++;
                    } else {
                        inQuote = false;
                    }
                } else {
                    cur.append(c);
                }
            } else {
                if (c == '"') {
                    inQuote = true;
                } else if (c == ',' || c == '\t') {
                    fields.add(cur.toString());
                    cur.setLength(0);
                } else {
                    cur.append(c);
                }
            }
        }
        fields.add(cur.toString());
        return fields.toArray(new String[0]);
    }
}
