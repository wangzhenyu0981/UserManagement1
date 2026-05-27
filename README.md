# 用户综合管理系统

这是一个基于Java Web技术的用户管理系统，适用于Eclipse 2023-9开发环境。

## 环境要求

- Eclipse 2023-9
- MySQL 8.4.8-winx64
- mysql-connector-j-8.4.0.jar
- Apache Tomcat 10.0.27

## 项目结构

```
UserManagement1/
├── user.sql                    # 数据库脚本
├── src/
│   ├── dbutil/
│   │   └── Dbconn.java         # 数据库连接工具类
│   ├── entity/
│   │   └── User.java           # 用户实体类
│   └── model/
│       └── Model.java          # 业务逻辑类
└── web/
    ├── WEB-INF/
    │   └── web.xml             # Web配置文件
    ├── index.jsp               # 主界面
    ├── insert.jsp              # 添加用户页面
    ├── insertShow.jsp          # 添加结果页面
    ├── update.jsp              # 更新用户页面
    ├── updateShow.jsp          # 更新结果页面
    ├── dele.jsp                # 删除用户页面
    ├── deleShow.jsp            # 删除结果页面
    ├── search.jsp              # 查询用户页面
    ├── showUser.jsp            # 用户详情页面
    └── allShow.jsp             # 所有用户列表页面
```

## 部署步骤

### 1. 数据库配置

在MySQL中执行 `user.sql` 脚本：
```bash
mysql -u root -p < user.sql
```

或者在MySQL Workbench等工具中打开并执行该脚本。

### 2. 修改数据库连接配置

打开 `src/dbutil/Dbconn.java`，根据实际情况修改数据库连接信息：
```java
private static final String URL = "jdbc:mysql://localhost:3306/userdb?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
private static final String USERNAME = "root";  // 修改为您的MySQL用户名
private static final String PASSWORD = "123456"; // 修改为您的MySQL密码
```

### 3. 在Eclipse中创建项目

1. 打开Eclipse，选择 `File` -> `New` -> `Dynamic Web Project`
2. 项目名称：`UserManagement`（或其他您喜欢的名称）
3. Target runtime：选择 Apache Tomcat 10.0
4. 点击 `Finish`

### 4. 导入代码

1. 将 `src` 目录下的三个包（dbutil、entity、model）复制到项目的 `src` 目录
2. 将 `web` 目录下的所有JSP文件复制到项目的 `WebContent` 目录
3. 将 `web/WEB-INF/web.xml` 复制到项目的 `WebContent/WEB-INF` 目录

### 5. 添加MySQL驱动

1. 在项目上右键 -> `Build Path` -> `Configure Build Path`
2. 选择 `Libraries` 标签 -> `Add External JARs...`
3. 选择 `mysql-connector-j-8.4.0.jar` 文件
4. 点击 `Apply and Close`

或者将 `mysql-connector-j-8.4.0.jar` 复制到项目的 `WebContent/WEB-INF/lib` 目录。

### 6. 部署到Tomcat

1. 在Eclipse中右键项目 -> `Run As` -> `Run on Server`
2. 选择 Tomcat 10.0 服务器
3. 点击 `Finish`

### 7. 访问系统

打开浏览器，访问：`http://localhost:8080/UserManagement/`

## 功能说明

- **添加用户**：添加新用户信息
- **更新用户**：修改已有用户信息
- **删除用户**：删除指定用户
- **查询用户**：根据用户ID查询用户信息
- **显示所有用户**：显示数据库中所有用户
