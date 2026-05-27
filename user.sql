CREATE DATABASE IF NOT EXISTS userdb;
USE userdb;

CREATE TABLE IF NOT EXISTS user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20)
);

INSERT INTO user (name, password, email, phone) VALUES
('张三', '123456', 'zhangsan@example.com', '13800138001'),
('李四', '654321', 'lisi@example.com', '13800138002'),
('王五', '111111', 'wangwu@example.com', '13800138003');
