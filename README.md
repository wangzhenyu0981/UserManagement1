# studentmanager - 学生信息管理系统

> 基于 MVC 架构（JSP + JavaBean + Servlet）实现的面向对象软件案例。
>
> 实验协作小组：**王振宇、侯文浩**

## 项目简介

本项目实现了学生信息的基本 CRUD 管理，并在此基础上扩展了 **Excel 批量导入**功能，用于软件工程课程"实验六：面向对象软件案例的 UML 建模"。

## 技术栈

- Java 17
- Jakarta Servlet 5.0 / JSP 2.3
- MySQL 8.0+ / JDBC (mysql-connector-j 8.4.0)
- Apache POI 5.2.5（Excel 读写）
- Tomcat 10.1+（Jakarta EE 兼容）

## 快速开始

### 1. 数据库

```bash
# 登录 MySQL
mysql -u root -p
# 执行脚本
source <项目目录>/student.sql
```

脚本将创建：

- 数据库：`students`
- 数据表：`student` (id, sno, sname, gender, age, major, grade)
- 预置 5 条学生数据

数据库连接配置位于 `src/dbutil/Dbconn.java`，默认：

- URL: `jdbc:mysql://localhost:3306/students?useSSL=false&serverTimezone=UTC&characterEncoding=utf8`
- 用户名：`root`
- 密码：`a123456`

> 根据本地 MySQL 配置自行修改。

### 2. 依赖 JAR

将以下 JAR 放入 `web/WEB-INF/lib/` 目录：

- MySQL 驱动：`mysql-connector-j-8.4.0.jar`
- Apache POI：`poi-5.2.5.jar`、`poi-ooxml-5.2.5.jar`、`poi-ooxml-lite-5.2.5.jar`、`xmlbeans-5.1.1.jar`、`commons-codec-1.16.0.jar`、`commons-collections4-4.4.jar`、`commons-io-2.15.1.jar`、`commons-logging-1.3.0.jar`、`log4j-api-2.22.1.jar`、`SparseBitSet-1.2.jar`、`curvesapi-1.07.jar`

`.classpath` 已包含对上述 JAR 的引用。

### 3. Eclipse 运行

1. File → Import → **Existing Projects into Workspace** → 选择项目根目录
2. 确保 Target Runtime 为 **Apache Tomcat 10.1**
3. 右键项目 → Run As → **Run on Server**
4. 浏览器访问：
   - `http://localhost:8080/studentmanager/`（自动跳转）
   - 或直接访问 `http://localhost:8080/studentmanager/ListStudentServlet.do`

## 功能模块

| 模块 | 入口 URL | 说明 |
|------|---------|------|
| 学生信息列表 | `/ListStudentServlet.do` | 主页，展示所有学生 |
| 新增学生信息 | `/jsp/studentinsert.jsp` → `/InsertStudentServlet.do` | 表单提交新增学生 |
| 修改学生信息 | `/UpStudentServlet.do`（查询）→ `/DoStudentServlet.do`（保存） | 两阶段流程 |
| 删除学生信息 | `/ShowStudentServlet.do`（确认）→ `/DeleteStudentServlet.do`（执行） | 两阶段流程 |
| Excel 批量导入 | `/ImportExcelServlet.do` | 支持 .xls / .xlsx，表头见下 |

### Excel 批量导入表头格式

| 学号 | 姓名 | 性别 | 年龄 | 专业 | 联系电话 |
|------|------|------|------|------|---------|
| 2024100 | 测试 | 男 | 20 | 软件工程 | 13800001234 |

## 项目结构

```
studentmanager/
├─ src/
│  ├─ entity/          Student.java、User.java
│  ├─ dbutil/          Dbconn.java（MySQL 工具）
│  ├─ model/           StudentModel.java（CRUD + 批量）
│  └─ control/         7 个 Servlet 控制器（List/Insert/Up/Do/Show/Delete/Import）
├─ web/
│  ├─ WEB-INF/
│  │  ├─ web.xml       Servlet 配置（注解扫描已关闭，完全走 web.xml）
│  │  └─ lib/          mysql-connector-j-8.4.0.jar（**唯一第三方依赖**）
│  ├─ jsp/             studentlist.jsp、studentinsert.jsp、studentupdate.jsp、studentshow.jsp
│  └─ index.jsp
├─ student.sql         数据库脚本
├─ README.md
└─ 实验六报告.md       完整实验报告
```

## 实验报告

详细实验报告、UML 类图说明、用例图、WBS、分工等，参见 [实验六报告.md](./实验六报告.md)。
