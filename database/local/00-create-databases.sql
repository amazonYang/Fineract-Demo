CREATE DATABASE `fineract_tenants`;
CREATE USER 'fineract_tenants'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON fineract_tenants.* TO 'fineract_tenants'@'%';
CREATE DATABASE `fineract_default`;
CREATE USER 'fineract_default'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON fineract_default.* TO 'fineract_default'@'%';
FLUSH PRIVILEGES;