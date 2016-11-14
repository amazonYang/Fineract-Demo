CREATE DATABASE `fineract_tenants_dev`;
CREATE USER 'fineract_tenants'@'%' IDENTIFIED BY 'DONOTUSETHISPASSWORD';
GRANT ALL PRIVILEGES ON fineract_tenants_dev.* TO 'fineract_tenants'@'%';
CREATE DATABASE `fineract_default_dev`;
CREATE USER 'fineract_default'@'%' IDENTIFIED BY 'DONOTUSETHISPASSWORD';
GRANT ALL PRIVILEGES ON fineract_default_dev.* TO 'fineract_default'@'%';
FLUSH PRIVILEGES;