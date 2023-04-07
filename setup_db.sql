-- prepares a MySQL server for the project

CREATE DATABASE IF NOT EXISTS servet_db;

CREATE USER IF NOT EXISTS 'servet_user'@'localhost' IDENTIFIED BY 'servet_pwd';

GRANT ALL PRIVILEGES ON `servet_db`.* TO 'servet_user'@'localhost';

GRANT SELECT ON `performance_schema`.* TO 'servet_user'@'localhost';

FLUSH PRIVILEGES;
