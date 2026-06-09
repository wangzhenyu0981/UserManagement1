-- ============================================================
-- 学生信息管理系统 数据库脚本
-- 数据库: students
-- 表: student
-- 说明: 用于实验六 面向对象软件案例的UML建模
-- ============================================================

-- 1. 创建数据库
CREATE DATABASE IF NOT EXISTS students DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE students;

-- 2. 创建学生信息表（把「联系电话」改为「成绩」，字段类型为 DECIMAL 便于排序/平均分）
DROP TABLE IF EXISTS student;
CREATE TABLE student (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键，自增',
    sno VARCHAR(30) NOT NULL UNIQUE COMMENT '学号',
    sname VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) DEFAULT NULL COMMENT '性别',
    age INT DEFAULT 0 COMMENT '年龄',
    major VARCHAR(100) DEFAULT NULL COMMENT '专业',
    grade DECIMAL(5,2) DEFAULT 0.00 COMMENT '成绩'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

-- 3. 插入示例数据
INSERT INTO student (sno, sname, gender, age, major, grade) VALUES
('2024001', '张三', '男', 20, '软件工程', 89.50),
('2024002', '李四', '男', 21, '计算机科学与技术', 76.00),
('2024003', '王五', '女', 19, '软件工程', 92.30),
('2024004', '赵六', '女', 22, '信息管理', 65.50),
('2024005', '孙七', '男', 20, '人工智能', 88.00);

SELECT * FROM student;
