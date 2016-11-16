# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: mekar-mysql-dev.ceufcrwhm3fb.ap-southeast-2.rds.amazonaws.com (MySQL 5.6.27-log)
# Database: fineract_default_dev
# Generation Time: 2016-11-16 04:24:36 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table acc_accounting_rule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_accounting_rule`;

CREATE TABLE `acc_accounting_rule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `office_id` bigint(20) DEFAULT NULL,
  `debit_account_id` bigint(20) DEFAULT NULL,
  `allow_multiple_debits` tinyint(1) NOT NULL DEFAULT '0',
  `credit_account_id` bigint(20) DEFAULT NULL,
  `allow_multiple_credits` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(500) DEFAULT NULL,
  `system_defined` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `accounting_rule_name_unique` (`name`),
  KEY `FK_acc_accounting_rule_acc_gl_account_debit` (`debit_account_id`),
  KEY `FK_acc_accounting_rule_acc_gl_account_credit` (`credit_account_id`),
  KEY `FK_acc_accounting_rule_m_office` (`office_id`),
  CONSTRAINT `FK_acc_accounting_rule_acc_gl_account_credit` FOREIGN KEY (`credit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_acc_accounting_rule_acc_gl_account_debit` FOREIGN KEY (`debit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_acc_accounting_rule_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table acc_gl_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_gl_account`;

CREATE TABLE `acc_gl_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `hierarchy` varchar(50) DEFAULT NULL,
  `gl_code` varchar(45) NOT NULL,
  `disabled` tinyint(1) NOT NULL DEFAULT '0',
  `manual_journal_entries_allowed` tinyint(1) NOT NULL DEFAULT '1',
  `account_usage` tinyint(1) NOT NULL DEFAULT '2',
  `classification_enum` smallint(5) NOT NULL,
  `tag_id` int(11) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acc_gl_code` (`gl_code`),
  KEY `FK_ACC_0000000001` (`parent_id`),
  KEY `FKGLACC000000002` (`tag_id`),
  CONSTRAINT `FKGLACC000000002` FOREIGN KEY (`tag_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_ACC_0000000001` FOREIGN KEY (`parent_id`) REFERENCES `acc_gl_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table acc_gl_closure
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_gl_closure`;

CREATE TABLE `acc_gl_closure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `office_id` bigint(20) NOT NULL,
  `closing_date` date NOT NULL,
  `is_deleted` int(20) NOT NULL DEFAULT '0',
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `office_id_closing_date` (`office_id`,`closing_date`),
  KEY `FK_acc_gl_closure_m_office` (`office_id`),
  KEY `FK_acc_gl_closure_m_appuser` (`createdby_id`),
  KEY `FK_acc_gl_closure_m_appuser_2` (`lastmodifiedby_id`),
  CONSTRAINT `FK_acc_gl_closure_m_appuser` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_closure_m_appuser_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_closure_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table acc_gl_financial_activity_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_gl_financial_activity_account`;

CREATE TABLE `acc_gl_financial_activity_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `gl_account_id` bigint(20) NOT NULL DEFAULT '0',
  `financial_activity_type` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `financial_activity_type` (`financial_activity_type`),
  KEY `FK_office_mapping_acc_gl_account` (`gl_account_id`),
  CONSTRAINT `FK_office_mapping_acc_gl_account` FOREIGN KEY (`gl_account_id`) REFERENCES `acc_gl_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table acc_gl_journal_entry
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_gl_journal_entry`;

CREATE TABLE `acc_gl_journal_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `reversal_id` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `transaction_id` varchar(50) NOT NULL,
  `loan_transaction_id` bigint(20) DEFAULT NULL,
  `savings_transaction_id` bigint(20) DEFAULT NULL,
  `client_transaction_id` bigint(20) DEFAULT NULL,
  `reversed` tinyint(1) NOT NULL DEFAULT '0',
  `ref_num` varchar(100) DEFAULT NULL,
  `manual_entry` tinyint(1) NOT NULL DEFAULT '0',
  `entry_date` date NOT NULL,
  `type_enum` smallint(5) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `entity_type_enum` smallint(5) DEFAULT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  `is_running_balance_calculated` tinyint(4) NOT NULL DEFAULT '0',
  `office_running_balance` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `organization_running_balance` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `payment_details_id` bigint(20) DEFAULT NULL,
  `share_transaction_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_acc_gl_journal_entry_m_office` (`office_id`),
  KEY `FK_acc_gl_journal_entry_m_appuser` (`createdby_id`),
  KEY `FK_acc_gl_journal_entry_m_appuser_2` (`lastmodifiedby_id`),
  KEY `FK_acc_gl_journal_entry_acc_gl_journal_entry` (`reversal_id`),
  KEY `FK_acc_gl_journal_entry_acc_gl_account` (`account_id`),
  KEY `FK_acc_gl_journal_entry_m_loan_transaction` (`loan_transaction_id`),
  KEY `FK_acc_gl_journal_entry_m_savings_account_transaction` (`savings_transaction_id`),
  KEY `FK_acc_gl_journal_entry_m_payment_detail` (`payment_details_id`),
  KEY `FK_acc_gl_journal_entry_m_client_transaction` (`client_transaction_id`),
  KEY `FK_acc_gl_journal_entry_m_share_account_transaction` (`share_transaction_id`),
  CONSTRAINT `FK_acc_gl_journal_entry_acc_gl_account` FOREIGN KEY (`account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_acc_gl_journal_entry` FOREIGN KEY (`reversal_id`) REFERENCES `acc_gl_journal_entry` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_appuser` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_appuser_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_client_transaction` FOREIGN KEY (`client_transaction_id`) REFERENCES `m_client_transaction` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_payment_detail` FOREIGN KEY (`payment_details_id`) REFERENCES `m_payment_detail` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_savings_account_transaction` FOREIGN KEY (`savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`),
  CONSTRAINT `FK_acc_gl_journal_entry_m_share_account_transaction` FOREIGN KEY (`share_transaction_id`) REFERENCES `m_share_account_transactions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table acc_product_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_product_mapping`;

CREATE TABLE `acc_product_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `gl_account_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `product_type` smallint(5) DEFAULT NULL,
  `payment_type` int(11) DEFAULT NULL,
  `charge_id` bigint(20) DEFAULT NULL,
  `financial_account_type` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_acc_product_mapping_m_charge` (`charge_id`),
  KEY `FK_acc_product_mapping_m_payment_type` (`payment_type`),
  CONSTRAINT `FK_acc_product_mapping_m_charge` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `FK_acc_product_mapping_m_payment_type` FOREIGN KEY (`payment_type`) REFERENCES `m_payment_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table acc_rule_tags
# ------------------------------------------------------------

DROP TABLE IF EXISTS `acc_rule_tags`;

CREATE TABLE `acc_rule_tags` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `acc_rule_id` bigint(20) NOT NULL,
  `tag_id` int(11) NOT NULL,
  `acc_type_enum` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_ACCOUNT_RULE_TAGS` (`acc_rule_id`,`tag_id`,`acc_type_enum`),
  KEY `FK_acc_accounting_rule_id` (`acc_rule_id`),
  KEY `FK_m_code_value_id` (`tag_id`),
  CONSTRAINT `FK_acc_accounting_rule_id` FOREIGN KEY (`acc_rule_id`) REFERENCES `acc_accounting_rule` (`id`),
  CONSTRAINT `FK_m_code_value_id` FOREIGN KEY (`tag_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table c_account_number_format
# ------------------------------------------------------------

DROP TABLE IF EXISTS `c_account_number_format`;

CREATE TABLE `c_account_number_format` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_type_enum` smallint(1) NOT NULL,
  `prefix_type_enum` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_type_enum` (`account_type_enum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table c_cache
# ------------------------------------------------------------

DROP TABLE IF EXISTS `c_cache`;

CREATE TABLE `c_cache` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cache_type_enum` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `c_cache` WRITE;
/*!40000 ALTER TABLE `c_cache` DISABLE KEYS */;

INSERT INTO `c_cache` (`id`, `cache_type_enum`)
VALUES
	(1,1);

/*!40000 ALTER TABLE `c_cache` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table c_configuration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `c_configuration`;

CREATE TABLE `c_configuration` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `value` int(11) DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT '0',
  `is_trap_door` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `c_configuration` WRITE;
/*!40000 ALTER TABLE `c_configuration` DISABLE KEYS */;

INSERT INTO `c_configuration` (`id`, `name`, `value`, `date_value`, `enabled`, `is_trap_door`, `description`)
VALUES
	(1,'maker-checker',NULL,NULL,0,0,NULL),
	(4,'amazon-S3',NULL,NULL,0,0,NULL),
	(5,'reschedule-future-repayments',NULL,NULL,1,0,NULL),
	(6,'reschedule-repayments-on-holidays',NULL,NULL,0,0,NULL),
	(7,'allow-transactions-on-holiday',NULL,NULL,0,0,NULL),
	(8,'allow-transactions-on-non_workingday',NULL,NULL,0,0,NULL),
	(9,'constraint_approach_for_datatables',NULL,NULL,0,0,NULL),
	(10,'penalty-wait-period',2,NULL,1,0,NULL),
	(11,'force-password-reset-days',0,NULL,0,0,NULL),
	(12,'grace-on-penalty-posting',0,NULL,1,0,NULL),
	(15,'savings-interest-posting-current-period-end',NULL,NULL,0,0,'Recommended to be changed only once during start of production. When set as false(default), interest will be posted on the first date of next period. If set as true, interest will be posted on last date of current period. There is no difference in the interest amount posted.'),
	(16,'financial-year-beginning-month',1,NULL,1,0,'Recommended to be changed only once during start of production. Allowed values 1 - 12 (January - December). Interest posting periods are evaluated based on this configuration.'),
	(17,'min-clients-in-group',5,NULL,0,0,'Minimum number of Clients that a Group should have'),
	(18,'max-clients-in-group',5,NULL,0,0,'Maximum number of Clients that a Group can have'),
	(19,'meetings-mandatory-for-jlg-loans',NULL,NULL,0,0,'Enforces all JLG loans to follow a meeting schedule belonging to parent group or Center'),
	(20,'office-specific-products-enabled',0,NULL,0,0,'Whether products and fees should be office specific or not? This property should NOT be changed once Mifos is Live.'),
	(21,'restrict-products-to-user-office',0,NULL,0,0,'This should be enabled only if, products & fees are office specific (i.e. office-specific-products-enabled is enabled). This property specifies if the products should be auto-restricted to office of the user who created the proudct? Note: This property should NOT be changed once Mifos is Live.'),
	(22,'office-opening-balances-contra-account',0,NULL,1,0,NULL),
	(23,'rounding-mode',6,NULL,1,1,'0 - UP, 1 - DOWN, 2- CEILING, 3- FLOOR, 4- HALF_UP, 5- HALF_DOWN, 6 - HALF_EVEN'),
	(24,'backdate-penalties-enabled',0,NULL,1,0,'If this parameter is disabled penalties will only be added to instalments due moving forward, any old overdue instalments will not be affected.'),
	(25,'organisation-start-date',0,NULL,0,0,NULL),
	(26,'paymenttype-applicable-for-disbursement-charges',NULL,NULL,0,0,'Is the Disbursement Entry need to be considering the fund source of the paymnet type'),
	(27,'interest-charged-from-date-same-as-disbursal-date',0,NULL,0,0,NULL),
	(28,'skip-repayment-on-first-day-of-month',14,NULL,0,0,'skipping repayment on first day of month'),
	(29,'change-emi-if-repaymentdate-same-as-disbursementdate',0,NULL,1,0,'In tranche loans, if repayment date is same as tranche disbursement date then allow to change the emi amount'),
	(30,'daily-tpt-limit',0,NULL,0,0,'Daily limit for third party transfers'),
	(31,'Enable-Address',NULL,NULL,0,0,NULL);

/*!40000 ALTER TABLE `c_configuration` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table c_external_service
# ------------------------------------------------------------

DROP TABLE IF EXISTS `c_external_service`;

CREATE TABLE `c_external_service` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `c_external_service` WRITE;
/*!40000 ALTER TABLE `c_external_service` DISABLE KEYS */;

INSERT INTO `c_external_service` (`id`, `name`)
VALUES
	(1,'S3'),
	(2,'SMTP_Email_Account');

/*!40000 ALTER TABLE `c_external_service` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table c_external_service_properties
# ------------------------------------------------------------

DROP TABLE IF EXISTS `c_external_service_properties`;

CREATE TABLE `c_external_service_properties` (
  `name` varchar(150) NOT NULL,
  `value` varchar(250) DEFAULT NULL,
  `external_service_id` bigint(20) NOT NULL,
  KEY `FK_c_external_service_properties_c_external_service` (`external_service_id`),
  CONSTRAINT `FK_c_external_service_properties_c_external_service` FOREIGN KEY (`external_service_id`) REFERENCES `c_external_service` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `c_external_service_properties` WRITE;
/*!40000 ALTER TABLE `c_external_service_properties` DISABLE KEYS */;

INSERT INTO `c_external_service_properties` (`name`, `value`, `external_service_id`)
VALUES
	('s3_access_key',NULL,1),
	('s3_bucket_name',NULL,1),
	('s3_secret_key',NULL,1),
	('username','support@cloudmicrofinance.com',2),
	('password','support81',2),
	('host','smtp.gmail.com',2),
	('port','25',2),
	('useTLS','true',2);

/*!40000 ALTER TABLE `c_external_service_properties` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job`;

CREATE TABLE `job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `cron_expression` varchar(20) CHARACTER SET latin1 NOT NULL,
  `create_time` datetime NOT NULL,
  `task_priority` smallint(6) NOT NULL DEFAULT '5',
  `group_name` varchar(50) CHARACTER SET latin1 DEFAULT NULL,
  `previous_run_start_time` datetime DEFAULT NULL,
  `next_run_time` datetime DEFAULT NULL,
  `job_key` varchar(500) DEFAULT NULL,
  `initializing_errorlog` text,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `currently_running` tinyint(1) NOT NULL DEFAULT '0',
  `updates_allowed` tinyint(1) NOT NULL DEFAULT '1',
  `scheduler_group` smallint(2) NOT NULL DEFAULT '0',
  `is_misfired` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `job` WRITE;
/*!40000 ALTER TABLE `job` DISABLE KEYS */;

INSERT INTO `job` (`id`, `name`, `display_name`, `cron_expression`, `create_time`, `task_priority`, `group_name`, `previous_run_start_time`, `next_run_time`, `job_key`, `initializing_errorlog`, `is_active`, `currently_running`, `updates_allowed`, `scheduler_group`, `is_misfired`)
VALUES
	(1,'Update loan Summary','Update loan Summary','0 0 22 1/1 * ? *','2016-11-15 08:26:13',5,NULL,NULL,'2016-11-16 15:00:00','Update loan SummaryJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(2,'Update Loan Arrears Ageing','Update Loan Arrears Ageing','0 1 0 1/1 * ? *','2016-11-15 08:26:13',5,NULL,'2016-11-15 17:01:00','2016-11-16 17:01:00','Update Loan Arrears AgeingJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(3,'Update Loan Paid In Advance','Update Loan Paid In Advance','0 5 0 1/1 * ? *','2016-11-15 08:26:13',5,NULL,'2016-11-15 17:05:00','2016-11-16 17:05:00','Update Loan Paid In AdvanceJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(4,'Apply Annual Fee For Savings','Apply Annual Fee For Savings','0 20 22 1/1 * ? *','2016-11-15 08:26:13',5,NULL,NULL,'2016-11-16 15:20:00','Apply Annual Fee For SavingsJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(5,'Apply Holidays To Loans','Apply Holidays To Loans','0 0 12 * * ?','2016-11-15 08:26:13',5,NULL,NULL,'2016-11-16 05:00:00','Apply Holidays To LoansJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(6,'Post Interest For Savings','Post Interest For Savings','0 0 0 1/1 * ? *','2016-11-15 08:26:15',5,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Post Interest For SavingsJobDetail1 _ DEFAULT',NULL,1,0,1,1,0),
	(7,'Transfer Fee For Loans From Savings','Transfer Fee For Loans From Savings','0 1 0 1/1 * ? *','2016-11-15 08:26:19',5,NULL,'2016-11-15 17:01:00','2016-11-16 17:01:00','Transfer Fee For Loans From SavingsJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(8,'Pay Due Savings Charges','Pay Due Savings Charges','0 0 12 * * ?','2013-09-23 00:00:00',5,NULL,NULL,'2016-11-16 05:00:00','Pay Due Savings ChargesJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(9,'Update Accounting Running Balances','Update Accounting Running Balances','0 1 0 1/1 * ? *','2016-11-15 08:26:20',5,NULL,'2016-11-15 17:01:00','2016-11-16 17:01:00','Update Accounting Running BalancesJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(10,'Execute Standing Instruction','Execute Standing Instruction','0 0 0 1/1 * ? *','2016-11-15 08:26:27',5,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Execute Standing InstructionJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(11,'Add Accrual Transactions','Add Accrual Transactions','0 1 0 1/1 * ? *','2016-11-15 08:26:27',3,NULL,'2016-11-15 17:01:01','2016-11-16 17:01:00','Add Accrual TransactionsJobDetail1 _ DEFAULT',NULL,1,0,1,3,0),
	(12,'Apply penalty to overdue loans','Apply penalty to overdue loans','0 0 0 1/1 * ? *','2016-11-15 08:26:27',5,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Apply penalty to overdue loansJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(13,'Update Non Performing Assets','Update Non Performing Assets','0 0 0 1/1 * ? *','2016-11-15 08:26:27',6,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Update Non Performing AssetsJobDetail1 _ DEFAULT',NULL,1,0,1,3,0),
	(14,'Transfer Interest To Savings','Transfer Interest To Savings','0 2 0 1/1 * ? *','2016-11-15 08:26:29',4,NULL,'2016-11-15 17:02:00','2016-11-16 17:02:00','Transfer Interest To SavingsJobDetail1 _ DEFAULT',NULL,1,0,1,1,0),
	(15,'Update Deposit Accounts Maturity details','Update Deposit Accounts Maturity details','0 0 0 1/1 * ? *','2016-11-15 08:26:29',5,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Update Deposit Accounts Maturity detailsJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(16,'Add Periodic Accrual Transactions','Add Periodic Accrual Transactions','0 2 0 1/1 * ? *','2016-11-15 08:26:31',2,NULL,'2016-11-15 17:02:00','2016-11-16 17:02:00','Add Periodic Accrual TransactionsJobDetail1 _ DEFAULT',NULL,1,0,1,3,0),
	(17,'Recalculate Interest For Loans','Recalculate Interest For Loans','0 1 0 1/1 * ? *','2016-11-15 08:26:32',4,NULL,'2016-11-15 17:01:01','2016-11-16 17:01:00','Recalculate Interest For LoansJobDetail1 _ DEFAULT',NULL,1,0,1,3,0),
	(18,'Generate Mandatory Savings Schedule','Generate Mandatory Savings Schedule','0 5 0 1/1 * ? *','2016-11-15 08:26:42',5,NULL,'2016-11-15 17:05:00','2016-11-16 17:05:00','Generate Mandatory Savings ScheduleJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(19,'Generate Loan Loss Provisioning','Generate Loan Loss Provisioning','0 0 0 1/1 * ? *','2016-11-15 08:26:45',5,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Generate Loan Loss ProvisioningJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(20,'Post Dividends For Shares','Post Dividends For Shares','0 0 0 1/1 * ? *','2016-11-15 08:26:50',5,NULL,'2016-11-15 17:00:00','2016-11-16 17:00:00','Post Dividends For SharesJobDetail1 _ DEFAULT',NULL,1,0,1,0,0),
	(21,'Update Savings Dormant Accounts','Update Savings Dormant Accounts','0 0 0 1/1 * ? *','2016-11-15 08:26:50',3,NULL,'2016-11-15 17:00:01','2016-11-16 17:00:00','Update Savings Dormant AccountsJobDetail1 _ DEFAULT',NULL,1,0,1,1,0),
	(22,'Add Accrual Transactions For Loans With Income Posted As Transactions','Add Accrual Transactions For Loans With Income Posted As Transactions','0 1 0 1/1 * ? *','2016-11-15 08:26:51',5,NULL,'2016-11-15 17:01:00','2016-11-16 17:01:00','Add Accrual Transactions For Loans With Income Posted As TransactionsJobDetail1 _ DEFAULT',NULL,1,0,1,3,0),
	(23,'Execute Report Mailing Jobs','Execute Report Mailing Jobs','0 0/15 * * * ?','2016-11-15 08:26:53',5,NULL,'2016-11-16 04:15:00','2016-11-16 04:30:00','Execute Report Mailing JobsJobDetail1 _ DEFAULT',NULL,1,0,1,0,0);

/*!40000 ALTER TABLE `job` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table job_run_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `job_run_history`;

CREATE TABLE `job_run_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) NOT NULL,
  `version` bigint(20) NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` varchar(10) CHARACTER SET latin1 NOT NULL,
  `error_message` text,
  `trigger_type` varchar(25) NOT NULL,
  `error_log` text,
  PRIMARY KEY (`id`),
  KEY `scheduledjobsFK` (`job_id`),
  CONSTRAINT `scheduledjobsFK` FOREIGN KEY (`job_id`) REFERENCES `job` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `job_run_history` WRITE;
/*!40000 ALTER TABLE `job_run_history` DISABLE KEYS */;

INSERT INTO `job_run_history` (`id`, `job_id`, `version`, `start_time`, `end_time`, `status`, `error_message`, `trigger_type`, `error_log`)
VALUES
	(1,23,1,'2016-11-15 08:30:00','2016-11-15 08:30:01','success',NULL,'cron',NULL),
	(2,23,2,'2016-11-15 08:45:00','2016-11-15 08:45:01','success',NULL,'cron',NULL),
	(3,23,3,'2016-11-15 09:00:00','2016-11-15 09:00:01','success',NULL,'cron',NULL),
	(4,23,4,'2016-11-15 09:15:00','2016-11-15 09:15:01','success',NULL,'cron',NULL),
	(5,23,5,'2016-11-15 09:30:00','2016-11-15 09:30:01','success',NULL,'cron',NULL),
	(6,23,6,'2016-11-15 09:45:00','2016-11-15 09:45:01','success',NULL,'cron',NULL),
	(7,23,7,'2016-11-15 10:00:00','2016-11-15 10:00:01','success',NULL,'cron',NULL),
	(8,23,8,'2016-11-15 10:15:00','2016-11-15 10:15:01','success',NULL,'cron',NULL),
	(9,23,9,'2016-11-15 10:30:00','2016-11-15 10:30:01','success',NULL,'cron',NULL),
	(10,23,10,'2016-11-15 10:45:00','2016-11-15 10:45:01','success',NULL,'cron',NULL),
	(11,23,11,'2016-11-15 11:00:00','2016-11-15 11:00:01','success',NULL,'cron',NULL),
	(12,23,12,'2016-11-15 11:15:00','2016-11-15 11:15:01','success',NULL,'cron',NULL),
	(13,23,13,'2016-11-15 11:30:00','2016-11-15 11:30:01','success',NULL,'cron',NULL),
	(14,23,14,'2016-11-15 11:45:00','2016-11-15 11:45:01','success',NULL,'cron',NULL),
	(15,23,15,'2016-11-15 12:00:00','2016-11-15 12:00:01','success',NULL,'cron',NULL),
	(16,23,16,'2016-11-15 12:15:00','2016-11-15 12:15:01','success',NULL,'cron',NULL),
	(17,23,17,'2016-11-15 12:30:00','2016-11-15 12:30:01','success',NULL,'cron',NULL),
	(18,23,18,'2016-11-15 12:45:00','2016-11-15 12:45:01','success',NULL,'cron',NULL),
	(19,23,19,'2016-11-15 13:00:00','2016-11-15 13:00:01','success',NULL,'cron',NULL),
	(20,23,20,'2016-11-15 13:15:00','2016-11-15 13:15:01','success',NULL,'cron',NULL),
	(21,23,21,'2016-11-15 13:30:00','2016-11-15 13:30:01','success',NULL,'cron',NULL),
	(22,23,22,'2016-11-15 13:45:00','2016-11-15 13:45:01','success',NULL,'cron',NULL),
	(23,23,23,'2016-11-15 14:00:00','2016-11-15 14:00:01','success',NULL,'cron',NULL),
	(24,23,24,'2016-11-15 14:15:00','2016-11-15 14:15:02','success',NULL,'cron',NULL),
	(25,23,25,'2016-11-15 14:30:00','2016-11-15 14:30:01','success',NULL,'cron',NULL),
	(26,23,26,'2016-11-15 14:45:00','2016-11-15 14:45:01','success',NULL,'cron',NULL),
	(27,23,27,'2016-11-15 15:00:00','2016-11-15 15:00:01','success',NULL,'cron',NULL),
	(28,23,28,'2016-11-15 15:15:00','2016-11-15 15:15:01','success',NULL,'cron',NULL),
	(29,23,29,'2016-11-15 15:30:00','2016-11-15 15:30:01','success',NULL,'cron',NULL),
	(30,23,30,'2016-11-15 15:45:00','2016-11-15 15:45:01','success',NULL,'cron',NULL),
	(31,23,31,'2016-11-15 16:00:00','2016-11-15 16:00:01','success',NULL,'cron',NULL),
	(32,23,32,'2016-11-15 16:15:00','2016-11-15 16:15:01','success',NULL,'cron',NULL),
	(33,23,33,'2016-11-15 16:30:00','2016-11-15 16:30:01','success',NULL,'cron',NULL),
	(34,23,34,'2016-11-15 16:45:00','2016-11-15 16:45:01','success',NULL,'cron',NULL),
	(35,19,1,'2016-11-15 17:00:00','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(36,10,1,'2016-11-15 17:00:00','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(37,23,35,'2016-11-15 17:00:00','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(38,12,1,'2016-11-15 17:00:00','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(39,15,1,'2016-11-15 17:00:00','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(40,6,1,'2016-11-15 17:00:00','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(41,21,1,'2016-11-15 17:00:01','2016-11-15 17:00:01','success',NULL,'cron',NULL),
	(42,13,1,'2016-11-15 17:00:00','2016-11-15 17:00:02','success',NULL,'cron',NULL),
	(43,20,1,'2016-11-15 17:00:00','2016-11-15 17:00:03','success',NULL,'cron',NULL),
	(44,22,1,'2016-11-15 17:01:00','2016-11-15 17:01:01','success',NULL,'cron',NULL),
	(45,9,1,'2016-11-15 17:01:00','2016-11-15 17:01:01','success',NULL,'cron',NULL),
	(46,7,1,'2016-11-15 17:01:00','2016-11-15 17:01:01','success',NULL,'cron',NULL),
	(47,17,1,'2016-11-15 17:01:01','2016-11-15 17:01:01','success',NULL,'cron',NULL),
	(48,11,1,'2016-11-15 17:01:01','2016-11-15 17:01:01','success',NULL,'cron',NULL),
	(49,2,1,'2016-11-15 17:01:00','2016-11-15 17:01:03','success',NULL,'cron',NULL),
	(50,16,1,'2016-11-15 17:02:00','2016-11-15 17:02:01','success',NULL,'cron',NULL),
	(51,14,1,'2016-11-15 17:02:00','2016-11-15 17:02:01','success',NULL,'cron',NULL),
	(52,18,1,'2016-11-15 17:05:00','2016-11-15 17:05:01','success',NULL,'cron',NULL),
	(53,3,1,'2016-11-15 17:05:00','2016-11-15 17:05:01','success',NULL,'cron',NULL),
	(54,23,36,'2016-11-15 17:15:00','2016-11-15 17:15:01','success',NULL,'cron',NULL),
	(55,23,37,'2016-11-15 17:30:00','2016-11-15 17:30:01','success',NULL,'cron',NULL),
	(56,23,38,'2016-11-15 17:45:00','2016-11-15 17:45:01','success',NULL,'cron',NULL),
	(57,23,39,'2016-11-15 18:00:00','2016-11-15 18:00:01','success',NULL,'cron',NULL),
	(58,23,40,'2016-11-15 18:15:00','2016-11-15 18:15:01','success',NULL,'cron',NULL),
	(59,23,41,'2016-11-15 18:30:00','2016-11-15 18:30:01','success',NULL,'cron',NULL),
	(60,23,42,'2016-11-15 18:45:00','2016-11-15 18:45:01','success',NULL,'cron',NULL),
	(61,23,43,'2016-11-15 19:00:00','2016-11-15 19:00:01','success',NULL,'cron',NULL),
	(62,23,44,'2016-11-15 19:15:00','2016-11-15 19:15:01','success',NULL,'cron',NULL),
	(63,23,45,'2016-11-15 19:30:00','2016-11-15 19:30:01','success',NULL,'cron',NULL),
	(64,23,46,'2016-11-15 19:45:00','2016-11-15 19:45:01','success',NULL,'cron',NULL),
	(65,23,47,'2016-11-15 20:00:00','2016-11-15 20:00:01','success',NULL,'cron',NULL),
	(66,23,48,'2016-11-15 20:15:00','2016-11-15 20:15:01','success',NULL,'cron',NULL),
	(67,23,49,'2016-11-15 20:30:00','2016-11-15 20:30:01','success',NULL,'cron',NULL),
	(68,23,50,'2016-11-15 20:45:00','2016-11-15 20:45:01','success',NULL,'cron',NULL),
	(69,23,51,'2016-11-15 21:00:00','2016-11-15 21:00:01','success',NULL,'cron',NULL),
	(70,23,52,'2016-11-15 21:15:00','2016-11-15 21:15:01','success',NULL,'cron',NULL),
	(71,23,53,'2016-11-15 21:30:00','2016-11-15 21:30:01','success',NULL,'cron',NULL),
	(72,23,54,'2016-11-15 21:45:00','2016-11-15 21:45:01','success',NULL,'cron',NULL),
	(73,23,55,'2016-11-15 22:00:00','2016-11-15 22:00:01','success',NULL,'cron',NULL),
	(74,23,56,'2016-11-15 22:15:00','2016-11-15 22:15:01','success',NULL,'cron',NULL),
	(75,23,57,'2016-11-15 22:30:00','2016-11-15 22:30:01','success',NULL,'cron',NULL),
	(76,23,58,'2016-11-15 22:45:00','2016-11-15 22:45:01','success',NULL,'cron',NULL),
	(77,23,59,'2016-11-15 23:00:00','2016-11-15 23:00:01','success',NULL,'cron',NULL),
	(78,23,60,'2016-11-15 23:15:00','2016-11-15 23:15:01','success',NULL,'cron',NULL),
	(79,23,61,'2016-11-15 23:30:00','2016-11-15 23:30:01','success',NULL,'cron',NULL),
	(80,23,62,'2016-11-15 23:45:00','2016-11-15 23:45:01','success',NULL,'cron',NULL),
	(81,23,63,'2016-11-16 00:00:00','2016-11-16 00:00:01','success',NULL,'cron',NULL),
	(82,23,64,'2016-11-16 00:15:00','2016-11-16 00:15:01','success',NULL,'cron',NULL),
	(83,23,65,'2016-11-16 00:30:00','2016-11-16 00:30:01','success',NULL,'cron',NULL),
	(84,23,66,'2016-11-16 00:45:00','2016-11-16 00:45:01','success',NULL,'cron',NULL),
	(85,23,67,'2016-11-16 01:00:00','2016-11-16 01:00:01','success',NULL,'cron',NULL),
	(86,23,68,'2016-11-16 01:15:00','2016-11-16 01:15:01','success',NULL,'cron',NULL),
	(87,23,69,'2016-11-16 01:30:00','2016-11-16 01:30:01','success',NULL,'cron',NULL),
	(88,23,70,'2016-11-16 01:45:00','2016-11-16 01:45:01','success',NULL,'cron',NULL),
	(89,23,71,'2016-11-16 02:00:00','2016-11-16 02:00:01','success',NULL,'cron',NULL),
	(90,23,72,'2016-11-16 02:15:00','2016-11-16 02:15:01','success',NULL,'cron',NULL),
	(91,23,73,'2016-11-16 02:30:00','2016-11-16 02:30:01','success',NULL,'cron',NULL),
	(92,23,74,'2016-11-16 02:45:00','2016-11-16 02:45:01','success',NULL,'cron',NULL),
	(93,23,75,'2016-11-16 03:00:00','2016-11-16 03:00:01','success',NULL,'cron',NULL),
	(94,23,76,'2016-11-16 03:15:00','2016-11-16 03:15:01','success',NULL,'cron',NULL),
	(95,23,77,'2016-11-16 03:30:00','2016-11-16 03:30:01','success',NULL,'cron',NULL),
	(96,23,78,'2016-11-16 03:45:00','2016-11-16 03:45:01','success',NULL,'cron',NULL),
	(97,23,79,'2016-11-16 04:00:00','2016-11-16 04:00:01','success',NULL,'cron',NULL),
	(98,23,80,'2016-11-16 04:15:00','2016-11-16 04:15:01','success',NULL,'cron',NULL);

/*!40000 ALTER TABLE `job_run_history` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_account_transfer_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_account_transfer_details`;

CREATE TABLE `m_account_transfer_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_office_id` bigint(20) NOT NULL,
  `to_office_id` bigint(20) NOT NULL,
  `from_client_id` bigint(20) DEFAULT NULL,
  `to_client_id` bigint(20) DEFAULT NULL,
  `from_savings_account_id` bigint(20) DEFAULT NULL,
  `to_savings_account_id` bigint(20) DEFAULT NULL,
  `from_loan_account_id` bigint(20) DEFAULT NULL,
  `to_loan_account_id` bigint(20) DEFAULT NULL,
  `transfer_type` smallint(2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_account_transfer_details_from_office` (`from_office_id`),
  KEY `FK_m_account_transfer_details_to_office` (`to_office_id`),
  KEY `FK_m_account_transfer_details_from_client` (`from_client_id`),
  KEY `FK_m_account_transfer_details_to_client` (`to_client_id`),
  KEY `FK_m_account_transfer_details_from_savings_account` (`from_savings_account_id`),
  KEY `FK_m_account_transfer_details_to_savings_account` (`to_savings_account_id`),
  KEY `FK_m_account_transfer_details_from_loan_account` (`from_loan_account_id`),
  KEY `FK_m_account_transfer_details_to_loan_account` (`to_loan_account_id`),
  CONSTRAINT `FK_m_account_transfer_details_from_client` FOREIGN KEY (`from_client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_from_loan_account` FOREIGN KEY (`from_loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_from_office` FOREIGN KEY (`from_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_from_savings_account` FOREIGN KEY (`from_savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_client` FOREIGN KEY (`to_client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_loan_account` FOREIGN KEY (`to_loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_office` FOREIGN KEY (`to_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_account_transfer_details_to_savings_account` FOREIGN KEY (`to_savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_account_transfer_standing_instructions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_account_transfer_standing_instructions`;

CREATE TABLE `m_account_transfer_standing_instructions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(250) NOT NULL,
  `account_transfer_details_id` bigint(20) NOT NULL,
  `priority` tinyint(2) NOT NULL,
  `status` tinyint(2) NOT NULL,
  `instruction_type` tinyint(2) NOT NULL,
  `amount` decimal(19,6) DEFAULT NULL,
  `valid_from` date NOT NULL,
  `valid_till` date DEFAULT NULL,
  `recurrence_type` tinyint(1) NOT NULL,
  `recurrence_frequency` smallint(5) DEFAULT NULL,
  `recurrence_interval` smallint(5) DEFAULT NULL,
  `recurrence_on_day` smallint(2) DEFAULT NULL,
  `recurrence_on_month` smallint(2) DEFAULT NULL,
  `last_run_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `FK_m_standing_instructions_account_transfer_details` (`account_transfer_details_id`),
  CONSTRAINT `FK_m_standing_instructions_account_transfer_details` FOREIGN KEY (`account_transfer_details_id`) REFERENCES `m_account_transfer_details` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_account_transfer_standing_instructions_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_account_transfer_standing_instructions_history`;

CREATE TABLE `m_account_transfer_standing_instructions_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `standing_instruction_id` bigint(20) NOT NULL,
  `status` varchar(20) NOT NULL,
  `execution_time` datetime NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `error_log` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_account_transfer_standing_instructions_history` (`standing_instruction_id`),
  CONSTRAINT `FK_m_account_transfer_standing_instructions_m_history` FOREIGN KEY (`standing_instruction_id`) REFERENCES `m_account_transfer_standing_instructions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_account_transfer_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_account_transfer_transaction`;

CREATE TABLE `m_account_transfer_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_transfer_details_id` bigint(20) NOT NULL,
  `from_savings_transaction_id` bigint(20) DEFAULT NULL,
  `from_loan_transaction_id` bigint(20) DEFAULT NULL,
  `to_savings_transaction_id` bigint(20) DEFAULT NULL,
  `to_loan_transaction_id` bigint(20) DEFAULT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `transaction_date` date NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `description` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_account_transfer_transaction_from_m_savings_transaction` (`from_savings_transaction_id`),
  KEY `FK_m_account_transfer_transaction_to_m_savings_transaction` (`to_savings_transaction_id`),
  KEY `FK_m_account_transfer_transaction_to_m_loan_transaction` (`to_loan_transaction_id`),
  KEY `FK_m_account_transfer_transaction_from_m_loan_transaction` (`from_loan_transaction_id`),
  KEY `FK_m_account_transfer_transaction_account_detail` (`account_transfer_details_id`),
  CONSTRAINT `FK_m_account_transfer_transaction_account_detail` FOREIGN KEY (`account_transfer_details_id`) REFERENCES `m_account_transfer_details` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_from_m_loan_transaction` FOREIGN KEY (`from_loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_from_m_savings_transaction` FOREIGN KEY (`from_savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_to_m_loan_transaction` FOREIGN KEY (`to_loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK_m_account_transfer_transaction_to_m_savings_transaction` FOREIGN KEY (`to_savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_address
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_address`;

CREATE TABLE `m_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `street` varchar(100) DEFAULT NULL,
  `address_line_1` varchar(100) DEFAULT NULL,
  `address_line_2` varchar(100) DEFAULT NULL,
  `address_line_3` varchar(100) DEFAULT NULL,
  `town_village` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `county_district` varchar(100) DEFAULT NULL,
  `state_province_id` int(11) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `latitude` decimal(10,8) unsigned DEFAULT '0.00000000',
  `longitude` decimal(10,8) unsigned DEFAULT '0.00000000',
  `created_by` varchar(100) DEFAULT NULL,
  `created_on` date DEFAULT NULL,
  `updated_by` varchar(100) DEFAULT NULL,
  `updated_on` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `address_fields_codefk1` (`state_province_id`),
  KEY `address_fields_codefk2` (`country_id`),
  CONSTRAINT `address_fields_codefk1` FOREIGN KEY (`state_province_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `address_fields_codefk2` FOREIGN KEY (`country_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_appuser
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_appuser`;

CREATE TABLE `m_appuser` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `office_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `lastname` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `firsttime_login_remaining` bit(1) NOT NULL,
  `nonexpired` bit(1) NOT NULL,
  `nonlocked` bit(1) NOT NULL,
  `nonexpired_credentials` bit(1) NOT NULL,
  `enabled` bit(1) NOT NULL,
  `last_time_password_updated` date NOT NULL,
  `password_never_expires` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'define if the password, should be check for validity period or not',
  `is_self_service_user` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_org` (`username`),
  KEY `FKB3D587CE0DD567A` (`office_id`),
  KEY `fk_m_appuser_002x` (`staff_id`),
  KEY `last_time_password_updated` (`last_time_password_updated`),
  CONSTRAINT `FKB3D587CE0DD567A` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `fk_m_appuser_002` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_appuser` WRITE;
/*!40000 ALTER TABLE `m_appuser` DISABLE KEYS */;

INSERT INTO `m_appuser` (`id`, `is_deleted`, `office_id`, `staff_id`, `username`, `firstname`, `lastname`, `password`, `email`, `firsttime_login_remaining`, `nonexpired`, `nonlocked`, `nonexpired_credentials`, `enabled`, `last_time_password_updated`, `password_never_expires`, `is_self_service_user`)
VALUES
	(1,0,1,NULL,'mifos','App','Administrator','5787039480429368bf94732aacc771cd0a3ea02bcf504ffe1185ab94213bc63a','demomfi@mifos.org',b'0',b'1',b'1',b'1',b'1','2016-11-15',0,b'0'),
	(2,0,1,NULL,'system','system','system','5787039480429368bf94732aacc771cd0a3ea02bcf504ffe1185ab94213bc63a','demomfi@mifos.org',b'0',b'1',b'1',b'1',b'1','2014-03-07',0,b'0');

/*!40000 ALTER TABLE `m_appuser` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_appuser_previous_password
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_appuser_previous_password`;

CREATE TABLE `m_appuser_previous_password` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `password` varchar(255) NOT NULL,
  `removal_date` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `m_appuser_previous_password_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_appuser_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_appuser_role`;

CREATE TABLE `m_appuser_role` (
  `appuser_id` bigint(20) NOT NULL,
  `role_id` bigint(20) NOT NULL,
  PRIMARY KEY (`appuser_id`,`role_id`),
  KEY `FK7662CE59B4100309` (`appuser_id`),
  KEY `FK7662CE5915CEC7AB` (`role_id`),
  CONSTRAINT `FK7662CE5915CEC7AB` FOREIGN KEY (`role_id`) REFERENCES `m_role` (`id`),
  CONSTRAINT `FK7662CE59B4100309` FOREIGN KEY (`appuser_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_appuser_role` WRITE;
/*!40000 ALTER TABLE `m_appuser_role` DISABLE KEYS */;

INSERT INTO `m_appuser_role` (`appuser_id`, `role_id`)
VALUES
	(1,1);

/*!40000 ALTER TABLE `m_appuser_role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_calendar
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_calendar`;

CREATE TABLE `m_calendar` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `title` varchar(70) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `duration` smallint(6) DEFAULT NULL,
  `calendar_type_enum` smallint(5) NOT NULL,
  `repeating` tinyint(1) NOT NULL DEFAULT '0',
  `recurrence` varchar(100) DEFAULT NULL,
  `remind_by_enum` smallint(5) DEFAULT NULL,
  `first_reminder` smallint(11) DEFAULT NULL,
  `second_reminder` smallint(11) DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `meeting_time` time DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_calendar_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_calendar_history`;

CREATE TABLE `m_calendar_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `calendar_id` bigint(20) NOT NULL,
  `title` varchar(70) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `location` varchar(50) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `duration` smallint(6) DEFAULT NULL,
  `calendar_type_enum` smallint(5) NOT NULL,
  `repeating` tinyint(1) NOT NULL DEFAULT '0',
  `recurrence` varchar(100) DEFAULT NULL,
  `remind_by_enum` smallint(5) DEFAULT NULL,
  `first_reminder` smallint(11) DEFAULT NULL,
  `second_reminder` smallint(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_calendar_m_calendar_history` (`calendar_id`),
  CONSTRAINT `FK_m_calendar_m_calendar_history` FOREIGN KEY (`calendar_id`) REFERENCES `m_calendar` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_calendar_instance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_calendar_instance`;

CREATE TABLE `m_calendar_instance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `calendar_id` bigint(20) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `entity_type_enum` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_calendar_m_calendar_instance` (`calendar_id`),
  CONSTRAINT `FK_m_calendar_m_calendar_instance` FOREIGN KEY (`calendar_id`) REFERENCES `m_calendar` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_cashier_transactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_cashier_transactions`;

CREATE TABLE `m_cashier_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cashier_id` bigint(20) NOT NULL,
  `txn_type` smallint(5) NOT NULL,
  `txn_amount` decimal(19,6) NOT NULL,
  `txn_date` date NOT NULL,
  `created_date` datetime NOT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `txn_note` varchar(200) DEFAULT NULL,
  `currency_code` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IK_m_teller_transactions_m_cashier` (`cashier_id`),
  CONSTRAINT `FK_m_teller_transactions_m_cashiers` FOREIGN KEY (`cashier_id`) REFERENCES `m_cashiers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_cashiers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_cashiers`;

CREATE TABLE `m_cashiers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `staff_id` bigint(20) DEFAULT NULL,
  `teller_id` bigint(20) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `start_time` varchar(10) DEFAULT NULL,
  `end_time` varchar(10) DEFAULT NULL,
  `full_day` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IK_m_cashiers_m_staff` (`staff_id`),
  KEY `IK_m_cashiers_m_teller` (`teller_id`),
  CONSTRAINT `FK_m_cashiers_m_staff` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`),
  CONSTRAINT `FK_m_cashiers_m_teller` FOREIGN KEY (`teller_id`) REFERENCES `m_tellers` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_charge`;

CREATE TABLE `m_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `charge_applies_to_enum` smallint(5) NOT NULL,
  `charge_time_enum` smallint(5) NOT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `charge_payment_mode_enum` smallint(5) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `fee_on_day` smallint(5) DEFAULT NULL,
  `fee_interval` smallint(5) DEFAULT NULL,
  `fee_on_month` smallint(5) DEFAULT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `min_cap` decimal(19,6) DEFAULT NULL,
  `max_cap` decimal(19,6) DEFAULT NULL,
  `fee_frequency` smallint(5) DEFAULT NULL,
  `income_or_liability_account_id` bigint(20) DEFAULT NULL,
  `tax_group_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `FK_m_charge_acc_gl_account` (`income_or_liability_account_id`),
  KEY `FK_m_charge_m_tax_group` (`tax_group_id`),
  CONSTRAINT `FK_m_charge_acc_gl_account` FOREIGN KEY (`income_or_liability_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_m_charge_m_tax_group` FOREIGN KEY (`tax_group_id`) REFERENCES `m_tax_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_client
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client`;

CREATE TABLE `m_client` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '300',
  `sub_status` int(11) DEFAULT NULL,
  `activation_date` date DEFAULT NULL,
  `office_joining_date` date DEFAULT NULL,
  `office_id` bigint(20) NOT NULL,
  `transfer_to_office_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `middlename` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `fullname` varchar(100) DEFAULT NULL,
  `display_name` varchar(100) NOT NULL,
  `mobile_no` varchar(50) DEFAULT NULL,
  `gender_cv_id` int(11) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `image_id` bigint(20) DEFAULT NULL,
  `closure_reason_cv_id` int(11) DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `updated_by` bigint(20) DEFAULT NULL,
  `updated_on` date DEFAULT NULL,
  `submittedon_date` date DEFAULT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `activatedon_userid` bigint(20) DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `default_savings_product` bigint(20) DEFAULT NULL,
  `default_savings_account` bigint(20) DEFAULT NULL,
  `client_type_cv_id` int(11) DEFAULT NULL,
  `client_classification_cv_id` int(11) DEFAULT NULL,
  `reject_reason_cv_id` int(11) DEFAULT NULL,
  `rejectedon_date` date DEFAULT NULL,
  `rejectedon_userid` bigint(20) DEFAULT NULL,
  `withdraw_reason_cv_id` int(11) DEFAULT NULL,
  `withdrawn_on_date` date DEFAULT NULL,
  `withdraw_on_userid` bigint(20) DEFAULT NULL,
  `reactivated_on_date` date DEFAULT NULL,
  `reactivated_on_userid` bigint(20) DEFAULT NULL,
  `legal_form_enum` int(5) DEFAULT NULL,
  `reopened_on_date` date DEFAULT NULL,
  `reopened_by_userid` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_no_UNIQUE` (`account_no`),
  UNIQUE KEY `external_id` (`external_id`),
  UNIQUE KEY `mobile_no_UNIQUE` (`mobile_no`),
  KEY `FKCE00CAB3E0DD567A` (`office_id`),
  KEY `FK_m_client_m_image` (`image_id`),
  KEY `client_staff_id` (`staff_id`),
  KEY `FK_m_client_m_code` (`closure_reason_cv_id`),
  KEY `FK_m_client_m_office` (`transfer_to_office_id`),
  KEY `FK_m_client_m_savings_product` (`default_savings_product`),
  KEY `FK_m_client_m_savings_account` (`default_savings_account`),
  KEY `FK_m_client_type_m_code_value` (`client_type_cv_id`),
  KEY `FK_m_client_classification_m_code_value` (`client_classification_cv_id`),
  KEY `FK1_m_client_gender_m_code_value` (`gender_cv_id`),
  KEY `FK_m_client_substatus_m_code_value` (`sub_status`),
  KEY `FK_m_client_type_mcode_value_reject` (`reject_reason_cv_id`),
  KEY `FK_m_client_type_m_code_value_withdraw` (`withdraw_reason_cv_id`),
  CONSTRAINT `FK1_m_client_gender_m_code_value` FOREIGN KEY (`gender_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FKCE00CAB3E0DD567A` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_client_classification_m_code_value` FOREIGN KEY (`client_classification_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_client_m_code` FOREIGN KEY (`closure_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_client_m_image` FOREIGN KEY (`image_id`) REFERENCES `m_image` (`id`),
  CONSTRAINT `FK_m_client_m_office` FOREIGN KEY (`transfer_to_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_client_m_savings_account` FOREIGN KEY (`default_savings_account`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `FK_m_client_m_savings_product` FOREIGN KEY (`default_savings_product`) REFERENCES `m_savings_product` (`id`),
  CONSTRAINT `FK_m_client_m_staff` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`),
  CONSTRAINT `FK_m_client_substatus_m_code_value` FOREIGN KEY (`sub_status`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_client_type_m_code_value` FOREIGN KEY (`client_type_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_client_type_m_code_value_withdraw` FOREIGN KEY (`withdraw_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_client_type_mcode_value_reject` FOREIGN KEY (`reject_reason_cv_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_client_address
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_address`;

CREATE TABLE `m_client_address` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL DEFAULT '0',
  `address_id` bigint(20) NOT NULL DEFAULT '0',
  `address_type_id` int(11) NOT NULL DEFAULT '0',
  `is_active` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `addressIdFk` (`address_id`),
  KEY `address_codefk` (`address_type_id`),
  KEY `clientaddressfk` (`client_id`),
  CONSTRAINT `address_codefk` FOREIGN KEY (`address_type_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `clientaddressfk` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_client_attendance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_attendance`;

CREATE TABLE `m_client_attendance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL DEFAULT '0',
  `meeting_id` bigint(20) NOT NULL,
  `attendance_type_enum` smallint(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_client_meeting_attendance` (`client_id`,`meeting_id`),
  KEY `FK_m_meeting_m_client_attendance` (`meeting_id`),
  CONSTRAINT `FK_m_client_m_client_attendance` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_meeting_m_client_attendance` FOREIGN KEY (`meeting_id`) REFERENCES `m_meeting` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_client_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_charge`;

CREATE TABLE `m_client_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  `is_penalty` tinyint(1) NOT NULL,
  `charge_time_enum` smallint(5) NOT NULL,
  `charge_due_date` date DEFAULT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL,
  `is_paid_derived` tinyint(1) DEFAULT NULL,
  `waived` tinyint(1) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `inactivated_on_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_client_charge_m_client` (`client_id`),
  KEY `FK_m_client_charge_m_charge` (`charge_id`),
  CONSTRAINT `FK_m_client_charge_m_charge` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `FK_m_client_charge_m_client` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_client_charge_paid_by
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_charge_paid_by`;

CREATE TABLE `m_client_charge_paid_by` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_transaction_id` bigint(20) NOT NULL,
  `client_charge_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_client_charge_paid_by_m_client_transaction` (`client_transaction_id`),
  KEY `FK_m_client_charge_paid_by_m_client_charge` (`client_charge_id`),
  CONSTRAINT `FK_m_client_charge_paid_by_m_client_charge` FOREIGN KEY (`client_charge_id`) REFERENCES `m_client_charge` (`id`),
  CONSTRAINT `FK_m_client_charge_paid_by_m_client_transaction` FOREIGN KEY (`client_transaction_id`) REFERENCES `m_client_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_client_identifier
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_identifier`;

CREATE TABLE `m_client_identifier` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL,
  `document_type_id` int(11) NOT NULL,
  `document_key` varchar(50) NOT NULL,
  `status` int(5) NOT NULL DEFAULT '300',
  `active` int(5) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_identifier_key` (`document_type_id`,`document_key`),
  UNIQUE KEY `unique_active_client_identifier` (`client_id`,`document_type_id`,`active`),
  KEY `FK_m_client_document_m_client` (`client_id`),
  KEY `FK_m_client_document_m_code_value` (`document_type_id`),
  CONSTRAINT `FK_m_client_document_m_client` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK_m_client_document_m_code_value` FOREIGN KEY (`document_type_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_client_non_person
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_non_person`;

CREATE TABLE `m_client_non_person` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL,
  `constitution_cv_id` int(11) NOT NULL,
  `incorp_no` varchar(50) DEFAULT NULL,
  `incorp_validity_till` datetime DEFAULT NULL,
  `main_business_line_cv_id` int(11) DEFAULT NULL,
  `remarks` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `client_id` (`client_id`),
  KEY `FK_client_id` (`client_id`),
  CONSTRAINT `FK_client_id` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_client_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_client_transaction`;

CREATE TABLE `m_client_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `payment_detail_id` bigint(20) DEFAULT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `external_id` varchar(50) DEFAULT NULL,
  `transaction_date` date NOT NULL,
  `transaction_type_enum` smallint(5) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `created_date` datetime NOT NULL,
  `appuser_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_id` (`external_id`),
  KEY `FK_m_client_transaction_m_client` (`client_id`),
  KEY `FK_m_client_transaction_m_appuser` (`appuser_id`),
  CONSTRAINT `FK_m_client_transaction_m_appuser` FOREIGN KEY (`appuser_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_client_transaction_m_client` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_code
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_code`;

CREATE TABLE `m_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code_name` varchar(100) DEFAULT NULL,
  `is_system_defined` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_name` (`code_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_code` WRITE;
/*!40000 ALTER TABLE `m_code` DISABLE KEYS */;

INSERT INTO `m_code` (`id`, `code_name`, `is_system_defined`)
VALUES
	(1,'Customer Identifier',1),
	(2,'LoanCollateral',1),
	(3,'LoanPurpose',1),
	(4,'Gender',1),
	(5,'YesNo',1),
	(6,'GuarantorRelationship',1),
	(7,'AssetAccountTags',1),
	(8,'LiabilityAccountTags',1),
	(9,'EquityAccountTags',1),
	(10,'IncomeAccountTags',1),
	(11,'ExpenseAccountTags',1),
	(13,'GROUPROLE',1),
	(14,'ClientClosureReason',1),
	(15,'GroupClosureReason',1),
	(16,'ClientType',1),
	(17,'ClientClassification',1),
	(18,'ClientSubStatus',1),
	(19,'ClientRejectReason',1),
	(20,'ClientWithdrawReason',1),
	(21,'Entity to Entity Access Types',1),
	(22,'CenterClosureReason',1),
	(23,'LoanRescheduleReason',1),
	(24,'Constitution',1),
	(25,'Main Business Line',1),
	(26,'WriteOffReasons',1),
	(27,'STATE',1),
	(28,'COUNTRY',1),
	(29,'ADDRESS_TYPE',1);

/*!40000 ALTER TABLE `m_code` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_code_value
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_code_value`;

CREATE TABLE `m_code_value` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code_id` int(11) NOT NULL,
  `code_value` varchar(100) DEFAULT NULL,
  `code_description` varchar(500) DEFAULT NULL,
  `order_position` int(11) NOT NULL DEFAULT '0',
  `code_score` int(11) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `is_mandatory` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code_value` (`code_id`,`code_value`),
  KEY `FKCFCEA42640BE071Z` (`code_id`),
  CONSTRAINT `FKCFCEA42640BE071Z` FOREIGN KEY (`code_id`) REFERENCES `m_code` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_code_value` WRITE;
/*!40000 ALTER TABLE `m_code_value` DISABLE KEYS */;

INSERT INTO `m_code_value` (`id`, `code_id`, `code_value`, `code_description`, `order_position`, `code_score`, `is_active`, `is_mandatory`)
VALUES
	(1,1,'Passport',NULL,1,NULL,1,0),
	(2,1,'Id',NULL,2,NULL,1,0),
	(3,1,'Drivers License',NULL,3,NULL,1,0),
	(4,1,'Any Other Id Type',NULL,4,NULL,1,0),
	(5,6,'Spouse',NULL,0,NULL,1,0),
	(6,6,'Parent',NULL,0,NULL,1,0),
	(7,6,'Sibling',NULL,0,NULL,1,0),
	(8,6,'Business Associate',NULL,0,NULL,1,0),
	(9,6,'Other',NULL,0,NULL,1,0),
	(10,21,'Office Access to Loan Products',NULL,0,NULL,1,0),
	(11,21,'Office Access to Savings Products',NULL,0,NULL,1,0),
	(12,21,'Office Access to Fees/Charges',NULL,0,NULL,1,0);

/*!40000 ALTER TABLE `m_code_value` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_currency
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_currency`;

CREATE TABLE `m_currency` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `decimal_places` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `display_symbol` varchar(10) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `internationalized_name_code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_currency` WRITE;
/*!40000 ALTER TABLE `m_currency` DISABLE KEYS */;

INSERT INTO `m_currency` (`id`, `code`, `decimal_places`, `currency_multiplesof`, `display_symbol`, `name`, `internationalized_name_code`)
VALUES
	(1,'AED',2,NULL,NULL,'UAE Dirham','currency.AED'),
	(2,'AFN',2,NULL,NULL,'Afghanistan Afghani','currency.AFN'),
	(3,'ALL',2,NULL,NULL,'Albanian Lek','currency.ALL'),
	(4,'AMD',2,NULL,NULL,'Armenian Dram','currency.AMD'),
	(5,'ANG',2,NULL,NULL,'Netherlands Antillian Guilder','currency.ANG'),
	(6,'AOA',2,NULL,NULL,'Angolan Kwanza','currency.AOA'),
	(7,'ARS',2,NULL,'$','Argentine Peso','currency.ARS'),
	(8,'AUD',2,NULL,'A$','Australian Dollar','currency.AUD'),
	(9,'AWG',2,NULL,NULL,'Aruban Guilder','currency.AWG'),
	(10,'AZM',2,NULL,NULL,'Azerbaijanian Manat','currency.AZM'),
	(11,'BAM',2,NULL,NULL,'Bosnia and Herzegovina Convertible Marks','currency.BAM'),
	(12,'BBD',2,NULL,NULL,'Barbados Dollar','currency.BBD'),
	(13,'BDT',2,NULL,NULL,'Bangladesh Taka','currency.BDT'),
	(14,'BGN',2,NULL,NULL,'Bulgarian Lev','currency.BGN'),
	(15,'BHD',3,NULL,NULL,'Bahraini Dinar','currency.BHD'),
	(16,'BIF',0,NULL,NULL,'Burundi Franc','currency.BIF'),
	(17,'BMD',2,NULL,NULL,'Bermudian Dollar','currency.BMD'),
	(18,'BND',2,NULL,'B$','Brunei Dollar','currency.BND'),
	(19,'BOB',2,NULL,'Bs.','Bolivian Boliviano','currency.BOB'),
	(20,'BRL',2,NULL,'R$','Brazilian Real','currency.BRL'),
	(21,'BSD',2,NULL,NULL,'Bahamian Dollar','currency.BSD'),
	(22,'BTN',2,NULL,NULL,'Bhutan Ngultrum','currency.BTN'),
	(23,'BWP',2,NULL,NULL,'Botswana Pula','currency.BWP'),
	(24,'BYR',0,NULL,NULL,'Belarussian Ruble','currency.BYR'),
	(25,'BZD',2,NULL,'BZ$','Belize Dollar','currency.BZD'),
	(26,'CAD',2,NULL,NULL,'Canadian Dollar','currency.CAD'),
	(27,'CDF',2,NULL,NULL,'Franc Congolais','currency.CDF'),
	(28,'CHF',2,NULL,NULL,'Swiss Franc','currency.CHF'),
	(29,'CLP',0,NULL,'$','Chilean Peso','currency.CLP'),
	(30,'CNY',2,NULL,NULL,'Chinese Yuan Renminbi','currency.CNY'),
	(31,'COP',2,NULL,'$','Colombian Peso','currency.COP'),
	(32,'CRC',2,NULL,'?','Costa Rican Colon','currency.CRC'),
	(33,'CSD',2,NULL,NULL,'Serbian Dinar','currency.CSD'),
	(34,'CUP',2,NULL,'$MN','Cuban Peso','currency.CUP'),
	(35,'CVE',2,NULL,NULL,'Cape Verde Escudo','currency.CVE'),
	(36,'CYP',2,NULL,NULL,'Cyprus Pound','currency.CYP'),
	(37,'CZK',2,NULL,NULL,'Czech Koruna','currency.CZK'),
	(38,'DJF',0,NULL,NULL,'Djibouti Franc','currency.DJF'),
	(39,'DKK',2,NULL,NULL,'Danish Krone','currency.DKK'),
	(40,'DOP',2,NULL,'RD$','Dominican Peso','currency.DOP'),
	(41,'DZD',2,NULL,NULL,'Algerian Dinar','currency.DZD'),
	(42,'EEK',2,NULL,NULL,'Estonian Kroon','currency.EEK'),
	(43,'EGP',2,NULL,NULL,'Egyptian Pound','currency.EGP'),
	(44,'ERN',2,NULL,NULL,'Eritrea Nafka','currency.ERN'),
	(45,'ETB',2,NULL,NULL,'Ethiopian Birr','currency.ETB'),
	(46,'EUR',2,NULL,'€','Euro','currency.EUR'),
	(47,'FJD',2,NULL,NULL,'Fiji Dollar','currency.FJD'),
	(48,'FKP',2,NULL,NULL,'Falkland Islands Pound','currency.FKP'),
	(49,'GBP',2,NULL,NULL,'Pound Sterling','currency.GBP'),
	(50,'GEL',2,NULL,NULL,'Georgian Lari','currency.GEL'),
	(51,'GHC',2,NULL,'GHc','Ghana Cedi','currency.GHC'),
	(52,'GIP',2,NULL,NULL,'Gibraltar Pound','currency.GIP'),
	(53,'GMD',2,NULL,NULL,'Gambian Dalasi','currency.GMD'),
	(54,'GNF',0,NULL,NULL,'Guinea Franc','currency.GNF'),
	(55,'GTQ',2,NULL,'Q','Guatemala Quetzal','currency.GTQ'),
	(56,'GYD',2,NULL,NULL,'Guyana Dollar','currency.GYD'),
	(57,'HKD',2,NULL,NULL,'Hong Kong Dollar','currency.HKD'),
	(58,'HNL',2,NULL,'L','Honduras Lempira','currency.HNL'),
	(59,'HRK',2,NULL,NULL,'Croatian Kuna','currency.HRK'),
	(60,'HTG',2,NULL,'G','Haiti Gourde','currency.HTG'),
	(61,'HUF',2,NULL,NULL,'Hungarian Forint','currency.HUF'),
	(62,'IDR',2,NULL,NULL,'Indonesian Rupiah','currency.IDR'),
	(63,'ILS',2,NULL,NULL,'New Israeli Shekel','currency.ILS'),
	(64,'INR',2,NULL,'₹','Indian Rupee','currency.INR'),
	(65,'IQD',3,NULL,NULL,'Iraqi Dinar','currency.IQD'),
	(66,'IRR',2,NULL,NULL,'Iranian Rial','currency.IRR'),
	(67,'ISK',0,NULL,NULL,'Iceland Krona','currency.ISK'),
	(68,'JMD',2,NULL,NULL,'Jamaican Dollar','currency.JMD'),
	(69,'JOD',3,NULL,NULL,'Jordanian Dinar','currency.JOD'),
	(70,'JPY',0,NULL,NULL,'Japanese Yen','currency.JPY'),
	(71,'KES',2,NULL,'KSh','Kenyan Shilling','currency.KES'),
	(72,'KGS',2,NULL,NULL,'Kyrgyzstan Som','currency.KGS'),
	(73,'KHR',2,NULL,NULL,'Cambodia Riel','currency.KHR'),
	(74,'KMF',0,NULL,NULL,'Comoro Franc','currency.KMF'),
	(75,'KPW',2,NULL,NULL,'North Korean Won','currency.KPW'),
	(76,'KRW',0,NULL,NULL,'Korean Won','currency.KRW'),
	(77,'KWD',3,NULL,NULL,'Kuwaiti Dinar','currency.KWD'),
	(78,'KYD',2,NULL,NULL,'Cayman Islands Dollar','currency.KYD'),
	(79,'KZT',2,NULL,NULL,'Kazakhstan Tenge','currency.KZT'),
	(80,'LAK',2,NULL,NULL,'Lao Kip','currency.LAK'),
	(81,'LBP',2,NULL,'L£','Lebanese Pound','currency.LBP'),
	(82,'LKR',2,NULL,NULL,'Sri Lanka Rupee','currency.LKR'),
	(83,'LRD',2,NULL,NULL,'Liberian Dollar','currency.LRD'),
	(84,'LSL',2,NULL,NULL,'Lesotho Loti','currency.LSL'),
	(85,'LTL',2,NULL,NULL,'Lithuanian Litas','currency.LTL'),
	(86,'LVL',2,NULL,NULL,'Latvian Lats','currency.LVL'),
	(87,'LYD',3,NULL,NULL,'Libyan Dinar','currency.LYD'),
	(88,'MAD',2,NULL,NULL,'Moroccan Dirham','currency.MAD'),
	(89,'MDL',2,NULL,NULL,'Moldovan Leu','currency.MDL'),
	(90,'MGA',2,NULL,NULL,'Malagasy Ariary','currency.MGA'),
	(91,'MKD',2,NULL,NULL,'Macedonian Denar','currency.MKD'),
	(92,'MMK',2,NULL,'K','Myanmar Kyat','currency.MMK'),
	(93,'MNT',2,NULL,NULL,'Mongolian Tugrik','currency.MNT'),
	(94,'MOP',2,NULL,NULL,'Macau Pataca','currency.MOP'),
	(95,'MRO',2,NULL,NULL,'Mauritania Ouguiya','currency.MRO'),
	(96,'MTL',2,NULL,NULL,'Maltese Lira','currency.MTL'),
	(97,'MUR',2,NULL,NULL,'Mauritius Rupee','currency.MUR'),
	(98,'MVR',2,NULL,NULL,'Maldives Rufiyaa','currency.MVR'),
	(99,'MWK',2,NULL,NULL,'Malawi Kwacha','currency.MWK'),
	(100,'MXN',2,NULL,'$','Mexican Peso','currency.MXN'),
	(101,'MYR',2,NULL,NULL,'Malaysian Ringgit','currency.MYR'),
	(102,'MZM',2,NULL,NULL,'Mozambique Metical','currency.MZM'),
	(103,'NAD',2,NULL,NULL,'Namibia Dollar','currency.NAD'),
	(104,'NGN',2,NULL,NULL,'Nigerian Naira','currency.NGN'),
	(105,'NIO',2,NULL,'C$','Nicaragua Cordoba Oro','currency.NIO'),
	(106,'NOK',2,NULL,NULL,'Norwegian Krone','currency.NOK'),
	(107,'NPR',2,NULL,NULL,'Nepalese Rupee','currency.NPR'),
	(108,'NZD',2,NULL,NULL,'New Zealand Dollar','currency.NZD'),
	(109,'OMR',3,NULL,NULL,'Rial Omani','currency.OMR'),
	(110,'PAB',2,NULL,'B/.','Panama Balboa','currency.PAB'),
	(111,'PEN',2,NULL,'S/.','Peruvian Nuevo Sol','currency.PEN'),
	(112,'PGK',2,NULL,NULL,'Papua New Guinea Kina','currency.PGK'),
	(113,'PHP',2,NULL,NULL,'Philippine Peso','currency.PHP'),
	(114,'PKR',2,NULL,NULL,'Pakistan Rupee','currency.PKR'),
	(115,'PLN',2,NULL,NULL,'Polish Zloty','currency.PLN'),
	(116,'PYG',0,NULL,'?','Paraguayan Guarani','currency.PYG'),
	(117,'QAR',2,NULL,NULL,'Qatari Rial','currency.QAR'),
	(118,'RON',2,NULL,NULL,'Romanian Leu','currency.RON'),
	(119,'RUB',2,NULL,NULL,'Russian Ruble','currency.RUB'),
	(120,'RWF',0,NULL,NULL,'Rwanda Franc','currency.RWF'),
	(121,'SAR',2,NULL,NULL,'Saudi Riyal','currency.SAR'),
	(122,'SBD',2,NULL,NULL,'Solomon Islands Dollar','currency.SBD'),
	(123,'SCR',2,NULL,NULL,'Seychelles Rupee','currency.SCR'),
	(124,'SDD',2,NULL,NULL,'Sudanese Dinar','currency.SDD'),
	(125,'SEK',2,NULL,NULL,'Swedish Krona','currency.SEK'),
	(126,'SGD',2,NULL,NULL,'Singapore Dollar','currency.SGD'),
	(127,'SHP',2,NULL,NULL,'St Helena Pound','currency.SHP'),
	(128,'SIT',2,NULL,NULL,'Slovenian Tolar','currency.SIT'),
	(129,'SKK',2,NULL,NULL,'Slovak Koruna','currency.SKK'),
	(130,'SLL',2,NULL,NULL,'Sierra Leone Leone','currency.SLL'),
	(131,'SOS',2,NULL,NULL,'Somali Shilling','currency.SOS'),
	(132,'SRD',2,NULL,NULL,'Surinam Dollar','currency.SRD'),
	(133,'STD',2,NULL,NULL,'Sao Tome and Principe Dobra','currency.STD'),
	(134,'SVC',2,NULL,NULL,'El Salvador Colon','currency.SVC'),
	(135,'SYP',2,NULL,NULL,'Syrian Pound','currency.SYP'),
	(136,'SZL',2,NULL,NULL,'Swaziland Lilangeni','currency.SZL'),
	(137,'THB',2,NULL,NULL,'Thai Baht','currency.THB'),
	(138,'TJS',2,NULL,NULL,'Tajik Somoni','currency.TJS'),
	(139,'TMM',2,NULL,NULL,'Turkmenistan Manat','currency.TMM'),
	(140,'TND',3,NULL,'DT','Tunisian Dinar','currency.TND'),
	(141,'TOP',2,NULL,NULL,'Tonga Pa\'anga','currency.TOP'),
	(142,'TRY',2,NULL,NULL,'Turkish Lira','currency.TRY'),
	(143,'TTD',2,NULL,NULL,'Trinidad and Tobago Dollar','currency.TTD'),
	(144,'TWD',2,NULL,NULL,'New Taiwan Dollar','currency.TWD'),
	(145,'TZS',2,NULL,NULL,'Tanzanian Shilling','currency.TZS'),
	(146,'UAH',2,NULL,NULL,'Ukraine Hryvnia','currency.UAH'),
	(147,'UGX',2,NULL,'USh','Uganda Shilling','currency.UGX'),
	(148,'USD',2,NULL,'$','US Dollar','currency.USD'),
	(149,'UYU',2,NULL,'$U','Peso Uruguayo','currency.UYU'),
	(150,'UZS',2,NULL,NULL,'Uzbekistan Sum','currency.UZS'),
	(151,'VEB',2,NULL,'Bs.F.','Venezuelan Bolivar','currency.VEB'),
	(152,'VND',2,NULL,NULL,'Vietnamese Dong','currency.VND'),
	(153,'VUV',0,NULL,NULL,'Vanuatu Vatu','currency.VUV'),
	(154,'WST',2,NULL,NULL,'Samoa Tala','currency.WST'),
	(155,'XAF',0,NULL,NULL,'CFA Franc BEAC','currency.XAF'),
	(156,'XCD',2,NULL,NULL,'East Caribbean Dollar','currency.XCD'),
	(157,'XDR',5,NULL,NULL,'SDR (Special Drawing Rights)','currency.XDR'),
	(158,'XOF',0,NULL,'CFA','CFA Franc BCEAO','currency.XOF'),
	(159,'XPF',0,NULL,NULL,'CFP Franc','currency.XPF'),
	(160,'YER',2,NULL,NULL,'Yemeni Rial','currency.YER'),
	(161,'ZAR',2,NULL,'R','South African Rand','currency.ZAR'),
	(162,'ZMK',2,NULL,NULL,'Zambian Kwacha','currency.ZMK'),
	(163,'ZWD',2,NULL,NULL,'Zimbabwe Dollar','currency.ZWD');

/*!40000 ALTER TABLE `m_currency` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_deposit_account_on_hold_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_deposit_account_on_hold_transaction`;

CREATE TABLE `m_deposit_account_on_hold_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `transaction_type_enum` smallint(1) NOT NULL,
  `transaction_date` date NOT NULL,
  `is_reversed` tinyint(1) NOT NULL DEFAULT '0',
  `created_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_deposit_on_hold_transaction_m_savings_account` (`savings_account_id`),
  CONSTRAINT `FK_deposit_on_hold_transaction_m_savings_account` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_deposit_account_recurring_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_deposit_account_recurring_detail`;

CREATE TABLE `m_deposit_account_recurring_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL DEFAULT '0',
  `mandatory_recommended_deposit_amount` decimal(19,6) DEFAULT NULL,
  `is_mandatory` tinyint(4) NOT NULL DEFAULT '0',
  `allow_withdrawal` tinyint(4) NOT NULL DEFAULT '0',
  `adjust_advance_towards_future_payments` tinyint(4) NOT NULL DEFAULT '1',
  `is_calendar_inherited` tinyint(4) NOT NULL DEFAULT '0',
  `total_overdue_amount` decimal(19,6) DEFAULT NULL,
  `no_of_overdue_installments` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDARD00000000000001` (`savings_account_id`),
  CONSTRAINT `FKDARD00000000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_deposit_account_term_and_preclosure
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_deposit_account_term_and_preclosure`;

CREATE TABLE `m_deposit_account_term_and_preclosure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL DEFAULT '0',
  `min_deposit_term` int(11) DEFAULT NULL,
  `max_deposit_term` int(11) DEFAULT NULL,
  `min_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `max_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `in_multiples_of_deposit_term` int(11) DEFAULT NULL,
  `in_multiples_of_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `pre_closure_penal_applicable` smallint(5) DEFAULT NULL,
  `pre_closure_penal_interest` decimal(19,6) DEFAULT NULL,
  `pre_closure_penal_interest_on_enum` smallint(5) DEFAULT NULL,
  `deposit_period` int(11) DEFAULT NULL,
  `deposit_period_frequency_enum` smallint(5) DEFAULT NULL,
  `deposit_amount` decimal(19,6) DEFAULT NULL,
  `maturity_amount` decimal(19,6) DEFAULT NULL,
  `maturity_date` date DEFAULT NULL,
  `on_account_closure_enum` smallint(5) DEFAULT NULL,
  `expected_firstdepositon_date` date DEFAULT NULL,
  `transfer_interest_to_linked_account` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FKDATP00000000000001` (`savings_account_id`),
  CONSTRAINT `FKDATP00000000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_deposit_product_interest_rate_chart
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_deposit_product_interest_rate_chart`;

CREATE TABLE `m_deposit_product_interest_rate_chart` (
  `deposit_product_id` bigint(20) NOT NULL,
  `interest_rate_chart_id` bigint(20) NOT NULL,
  UNIQUE KEY `deposit_product_id_interest_rate_chart_id` (`deposit_product_id`,`interest_rate_chart_id`),
  KEY `FKDPIRC00000000000002` (`interest_rate_chart_id`),
  CONSTRAINT `FKDPIRC00000000000001` FOREIGN KEY (`deposit_product_id`) REFERENCES `m_savings_product` (`id`),
  CONSTRAINT `FKDPIRC00000000000002` FOREIGN KEY (`interest_rate_chart_id`) REFERENCES `m_interest_rate_chart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_deposit_product_recurring_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_deposit_product_recurring_detail`;

CREATE TABLE `m_deposit_product_recurring_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_product_id` bigint(20) NOT NULL DEFAULT '0',
  `is_mandatory` tinyint(1) NOT NULL DEFAULT '1',
  `allow_withdrawal` tinyint(1) NOT NULL DEFAULT '0',
  `adjust_advance_towards_future_payments` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `FKDPRD00000000000001` (`savings_product_id`),
  CONSTRAINT `FKDPRD00000000000001` FOREIGN KEY (`savings_product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_deposit_product_term_and_preclosure
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_deposit_product_term_and_preclosure`;

CREATE TABLE `m_deposit_product_term_and_preclosure` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_product_id` bigint(20) NOT NULL DEFAULT '0',
  `min_deposit_term` int(11) DEFAULT NULL,
  `max_deposit_term` int(11) DEFAULT NULL,
  `min_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `max_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `in_multiples_of_deposit_term` int(11) DEFAULT NULL,
  `in_multiples_of_deposit_term_type_enum` smallint(5) DEFAULT NULL,
  `pre_closure_penal_applicable` smallint(5) DEFAULT NULL,
  `pre_closure_penal_interest` decimal(19,6) DEFAULT NULL,
  `pre_closure_penal_interest_on_enum` smallint(5) DEFAULT NULL,
  `min_deposit_amount` decimal(19,6) DEFAULT NULL,
  `max_deposit_amount` decimal(19,6) DEFAULT NULL,
  `deposit_amount` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKDPTP00000000000001` (`savings_product_id`),
  CONSTRAINT `FKDPTP00000000000001` FOREIGN KEY (`savings_product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_document
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_document`;

CREATE TABLE `m_document` (
  `id` int(20) NOT NULL AUTO_INCREMENT,
  `parent_entity_type` varchar(50) NOT NULL,
  `parent_entity_id` int(20) NOT NULL DEFAULT '0',
  `name` varchar(250) NOT NULL,
  `file_name` varchar(250) NOT NULL,
  `size` int(20) DEFAULT '0',
  `type` varchar(500) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `location` varchar(500) NOT NULL DEFAULT '0',
  `storage_type_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_entity_relation
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_entity_relation`;

CREATE TABLE `m_entity_relation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_entity_type` int(10) NOT NULL,
  `to_entity_type` int(10) NOT NULL,
  `code_name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `from_entity_type_to_entity_type_code_name` (`from_entity_type`,`to_entity_type`,`code_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_entity_relation` WRITE;
/*!40000 ALTER TABLE `m_entity_relation` DISABLE KEYS */;

INSERT INTO `m_entity_relation` (`id`, `from_entity_type`, `to_entity_type`, `code_name`)
VALUES
	(1,1,2,'office_access_to_loan_products'),
	(2,1,3,'office_access_to_savings_products'),
	(3,1,4,'office_access_to_fees/charges'),
	(4,5,2,'role_access_to_loan_products'),
	(5,5,3,'role_access_to_savings_products');

/*!40000 ALTER TABLE `m_entity_relation` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_entity_to_entity_access
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_entity_to_entity_access`;

CREATE TABLE `m_entity_to_entity_access` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `access_type_code_value_id` int(11) NOT NULL,
  `second_entity_type` varchar(50) NOT NULL,
  `second_entity_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_uniq_m_entity_to_entity_access` (`entity_type`,`entity_id`,`access_type_code_value_id`,`second_entity_type`,`second_entity_id`),
  KEY `IDX_OFFICE` (`entity_type`,`entity_id`),
  KEY `FK_access_type_code_m_code_value` (`access_type_code_value_id`),
  CONSTRAINT `FK_access_type_code_m_code_value` FOREIGN KEY (`access_type_code_value_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_entity_to_entity_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_entity_to_entity_mapping`;

CREATE TABLE `m_entity_to_entity_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rel_id` bigint(20) NOT NULL DEFAULT '0',
  `from_id` bigint(20) NOT NULL DEFAULT '0',
  `to_id` bigint(20) unsigned NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `rel_id_from_id_to_id` (`rel_id`,`from_id`,`to_id`),
  CONSTRAINT `FK__rel_id_m_entity_relation_id` FOREIGN KEY (`rel_id`) REFERENCES `m_entity_relation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_field_configuration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_field_configuration`;

CREATE TABLE `m_field_configuration` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `entity` varchar(100) NOT NULL,
  `subentity` varchar(100) NOT NULL,
  `field` varchar(100) NOT NULL,
  `is_enabled` tinyint(4) NOT NULL,
  `is_mandatory` tinyint(4) NOT NULL,
  `validation_regex` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `m_field_configuration` WRITE;
/*!40000 ALTER TABLE `m_field_configuration` DISABLE KEYS */;

INSERT INTO `m_field_configuration` (`id`, `entity`, `subentity`, `field`, `is_enabled`, `is_mandatory`, `validation_regex`)
VALUES
	(1,'ADDRESS','CLIENT','addressType',1,0,''),
	(2,'ADDRESS','CLIENT','street',1,1,''),
	(3,'ADDRESS','CLIENT','addressLine1',1,0,''),
	(4,'ADDRESS','CLIENT','addressLine2',1,0,''),
	(5,'ADDRESS','CLIENT','addressLine3',1,0,''),
	(6,'ADDRESS','CLIENT','townVillage',0,0,''),
	(7,'ADDRESS','CLIENT','city',1,0,''),
	(8,'ADDRESS','CLIENT','countyDistrict',0,0,''),
	(9,'ADDRESS','CLIENT','stateProvinceId',1,0,''),
	(10,'ADDRESS','CLIENT','countryId',1,0,''),
	(11,'ADDRESS','CLIENT','postalCode',1,0,''),
	(12,'ADDRESS','CLIENT','latitude',0,0,''),
	(13,'ADDRESS','CLIENT','longitude',0,0,''),
	(14,'ADDRESS','CLIENT','createdBy',1,0,''),
	(15,'ADDRESS','CLIENT','createdOn',1,0,''),
	(16,'ADDRESS','CLIENT','updatedBy',1,0,''),
	(17,'ADDRESS','CLIENT','updatedOn',1,0,''),
	(18,'ADDRESS','CLIENT','isActive',1,0,'');

/*!40000 ALTER TABLE `m_field_configuration` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_floating_rates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_floating_rates`;

CREATE TABLE `m_floating_rates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `is_base_lending_rate` bit(1) NOT NULL DEFAULT b'0',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `createdby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_floating_rates_periods
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_floating_rates_periods`;

CREATE TABLE `m_floating_rates_periods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `floating_rates_id` bigint(20) NOT NULL,
  `from_date` datetime NOT NULL,
  `interest_rate` decimal(19,6) NOT NULL,
  `is_differential_to_base_lending_rate` bit(1) NOT NULL DEFAULT b'0',
  `is_active` bit(1) NOT NULL DEFAULT b'1',
  `createdby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_mappings_m_floating_rates` (`floating_rates_id`),
  CONSTRAINT `FK_mappings_m_floating_rates` FOREIGN KEY (`floating_rates_id`) REFERENCES `m_floating_rates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_fund
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_fund`;

CREATE TABLE `m_fund` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `fund_name_org` (`name`),
  UNIQUE KEY `fund_externalid_org` (`external_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_group`;

CREATE TABLE `m_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `external_id` varchar(100) DEFAULT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '300',
  `activation_date` date DEFAULT NULL,
  `office_id` bigint(20) NOT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `parent_id` bigint(20) DEFAULT NULL,
  `level_id` int(11) NOT NULL,
  `display_name` varchar(100) NOT NULL,
  `hierarchy` varchar(100) DEFAULT NULL,
  `closure_reason_cv_id` int(11) DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `activatedon_userid` bigint(20) DEFAULT NULL,
  `submittedon_date` date DEFAULT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `account_no` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`display_name`,`level_id`),
  UNIQUE KEY `external_id` (`external_id`,`level_id`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  KEY `office_id` (`office_id`),
  KEY `staff_id` (`staff_id`),
  KEY `Parent_Id_reference` (`parent_id`),
  KEY `FK_m_group_level` (`level_id`),
  KEY `FK_m_group_m_code` (`closure_reason_cv_id`),
  CONSTRAINT `FK_m_group_level` FOREIGN KEY (`level_id`) REFERENCES `m_group_level` (`id`),
  CONSTRAINT `FK_m_group_m_code` FOREIGN KEY (`closure_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_group_m_staff` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`),
  CONSTRAINT `Parent_Id_reference` FOREIGN KEY (`parent_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `m_group_ibfk_1` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_group_client
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_group_client`;

CREATE TABLE `m_group_client` (
  `group_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  PRIMARY KEY (`group_id`,`client_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `m_group_client_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `m_group_client_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_group_level
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_group_level`;

CREATE TABLE `m_group_level` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `super_parent` tinyint(1) NOT NULL,
  `level_name` varchar(100) NOT NULL,
  `recursable` tinyint(1) NOT NULL,
  `can_have_clients` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `Parent_levelId_reference` (`parent_id`),
  CONSTRAINT `Parent_levelId_reference` FOREIGN KEY (`parent_id`) REFERENCES `m_group_level` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_group_level` WRITE;
/*!40000 ALTER TABLE `m_group_level` DISABLE KEYS */;

INSERT INTO `m_group_level` (`id`, `parent_id`, `super_parent`, `level_name`, `recursable`, `can_have_clients`)
VALUES
	(1,NULL,1,'Center',1,0),
	(2,1,0,'Group',0,1);

/*!40000 ALTER TABLE `m_group_level` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_group_roles
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_group_roles`;

CREATE TABLE `m_group_roles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `role_cv_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQUE_GROUP_ROLES` (`client_id`,`group_id`,`role_cv_id`),
  KEY `FKGroupRoleClientId` (`client_id`),
  KEY `FKGroupRoleGroupId` (`group_id`),
  KEY `FK_grouprole_m_codevalue` (`role_cv_id`),
  CONSTRAINT `FKGroupRoleClientId` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKGroupRoleGroupId` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FK_grouprole_m_codevalue` FOREIGN KEY (`role_cv_id`) REFERENCES `m_code_value` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_guarantor
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_guarantor`;

CREATE TABLE `m_guarantor` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `client_reln_cv_id` int(11) DEFAULT NULL,
  `type_enum` smallint(5) NOT NULL,
  `entity_id` bigint(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `address_line_1` varchar(500) DEFAULT NULL,
  `address_line_2` varchar(500) DEFAULT NULL,
  `city` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `country` varchar(50) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `house_phone_number` varchar(20) DEFAULT NULL,
  `mobile_number` varchar(20) DEFAULT NULL,
  `comment` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `FK_m_guarantor_m_loan` (`loan_id`),
  KEY `FK_m_guarantor_m_code_value` (`client_reln_cv_id`),
  CONSTRAINT `FK_m_guarantor_m_code_value` FOREIGN KEY (`client_reln_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_m_guarantor_m_loan` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_guarantor_funding_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_guarantor_funding_details`;

CREATE TABLE `m_guarantor_funding_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guarantor_id` bigint(20) NOT NULL,
  `account_associations_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_released_derived` decimal(19,6) DEFAULT NULL,
  `amount_remaining_derived` decimal(19,6) DEFAULT NULL,
  `amount_transfered_derived` decimal(19,6) DEFAULT NULL,
  `status_enum` smallint(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_guarantor_fund_details_m_guarantor` (`guarantor_id`),
  KEY `FK_m_guarantor_fund_details_account_associations_id` (`account_associations_id`),
  CONSTRAINT `FK_m_guarantor_fund_details_account_associations_id` FOREIGN KEY (`account_associations_id`) REFERENCES `m_portfolio_account_associations` (`id`),
  CONSTRAINT `FK_m_guarantor_fund_details_m_guarantor` FOREIGN KEY (`guarantor_id`) REFERENCES `m_guarantor` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_guarantor_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_guarantor_transaction`;

CREATE TABLE `m_guarantor_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `guarantor_fund_detail_id` bigint(20) NOT NULL,
  `loan_transaction_id` bigint(20) DEFAULT NULL,
  `deposit_on_hold_transaction_id` bigint(20) NOT NULL,
  `is_reversed` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_guarantor_transaction_m_deposit_account_on_hold_transaction` (`deposit_on_hold_transaction_id`),
  KEY `FK_guarantor_transaction_guarantor_fund_detail` (`guarantor_fund_detail_id`),
  KEY `FK_guarantor_transaction_m_loan_transaction` (`loan_transaction_id`),
  CONSTRAINT `FK_guarantor_transaction_guarantor_fund_detail` FOREIGN KEY (`guarantor_fund_detail_id`) REFERENCES `m_guarantor_funding_details` (`id`),
  CONSTRAINT `FK_guarantor_transaction_m_deposit_account_on_hold_transaction` FOREIGN KEY (`deposit_on_hold_transaction_id`) REFERENCES `m_deposit_account_on_hold_transaction` (`id`),
  CONSTRAINT `FK_guarantor_transaction_m_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_holiday
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_holiday`;

CREATE TABLE `m_holiday` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `from_date` datetime NOT NULL,
  `to_date` datetime NOT NULL,
  `repayments_rescheduled_to` datetime NOT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '100',
  `processed` tinyint(1) NOT NULL DEFAULT '0',
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `holiday_name` (`name`,`from_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_holiday_office
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_holiday_office`;

CREATE TABLE `m_holiday_office` (
  `holiday_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  PRIMARY KEY (`holiday_id`,`office_id`),
  KEY `m_holiday_id_ibfk_1` (`holiday_id`),
  KEY `m_office_id_ibfk_2` (`office_id`),
  CONSTRAINT `m_holiday_id_ibfk_1` FOREIGN KEY (`holiday_id`) REFERENCES `m_holiday` (`id`),
  CONSTRAINT `m_office_id_ibfk_2` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_hook
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_hook`;

CREATE TABLE `m_hook` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `template_id` smallint(6) NOT NULL,
  `is_active` smallint(3) NOT NULL DEFAULT '1',
  `name` varchar(45) NOT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `ugd_template_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_template_id_idx` (`template_id`),
  KEY `fk_ugd_template_id` (`ugd_template_id`),
  CONSTRAINT `fk_template_id` FOREIGN KEY (`template_id`) REFERENCES `m_hook_templates` (`id`),
  CONSTRAINT `fk_ugd_template_id` FOREIGN KEY (`ugd_template_id`) REFERENCES `m_template` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_hook_configuration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_hook_configuration`;

CREATE TABLE `m_hook_configuration` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hook_id` bigint(20) DEFAULT NULL,
  `field_type` varchar(45) NOT NULL,
  `field_name` varchar(100) NOT NULL,
  `field_value` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_hook_id_idx` (`hook_id`),
  CONSTRAINT `fk_hook_id_cfg` FOREIGN KEY (`hook_id`) REFERENCES `m_hook` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_hook_registered_events
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_hook_registered_events`;

CREATE TABLE `m_hook_registered_events` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hook_id` bigint(20) NOT NULL,
  `entity_name` varchar(45) NOT NULL,
  `action_name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_hook_id_idx` (`hook_id`),
  CONSTRAINT `fk_hook_idc` FOREIGN KEY (`hook_id`) REFERENCES `m_hook` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_hook_schema
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_hook_schema`;

CREATE TABLE `m_hook_schema` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `hook_template_id` smallint(6) NOT NULL,
  `field_type` varchar(45) NOT NULL,
  `field_name` varchar(100) NOT NULL,
  `placeholder` varchar(100) DEFAULT NULL,
  `optional` tinyint(3) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_hook_template_id_idx` (`hook_template_id`),
  CONSTRAINT `fk_hook_template_id` FOREIGN KEY (`hook_template_id`) REFERENCES `m_hook_templates` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_hook_schema` WRITE;
/*!40000 ALTER TABLE `m_hook_schema` DISABLE KEYS */;

INSERT INTO `m_hook_schema` (`id`, `hook_template_id`, `field_type`, `field_name`, `placeholder`, `optional`)
VALUES
	(1,1,'string','Payload URL',NULL,0),
	(2,1,'string','Content Type','json / form',0),
	(3,2,'string','Payload URL',NULL,0),
	(4,2,'string','SMS Provider',NULL,0),
	(5,2,'string','Phone Number',NULL,0),
	(6,2,'string','SMS Provider Token',NULL,0),
	(7,2,'string','SMS Provider Account Id',NULL,0);

/*!40000 ALTER TABLE `m_hook_schema` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_hook_templates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_hook_templates`;

CREATE TABLE `m_hook_templates` (
  `id` smallint(6) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_hook_templates` WRITE;
/*!40000 ALTER TABLE `m_hook_templates` DISABLE KEYS */;

INSERT INTO `m_hook_templates` (`id`, `name`)
VALUES
	(1,'Web'),
	(2,'SMS Bridge');

/*!40000 ALTER TABLE `m_hook_templates` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_image
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_image`;

CREATE TABLE `m_image` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `location` varchar(500) DEFAULT NULL,
  `storage_type_enum` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_interest_incentives
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_interest_incentives`;

CREATE TABLE `m_interest_incentives` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `interest_rate_slab_id` bigint(20) NOT NULL,
  `entiry_type` smallint(2) NOT NULL,
  `attribute_name` smallint(2) NOT NULL,
  `condition_type` smallint(2) NOT NULL,
  `attribute_value` varchar(50) NOT NULL,
  `incentive_type` smallint(2) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_interest_incentives_m_interest_rate_slab` (`interest_rate_slab_id`),
  CONSTRAINT `FK_m_interest_incentives_m_interest_rate_slab` FOREIGN KEY (`interest_rate_slab_id`) REFERENCES `m_interest_rate_slab` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_interest_rate_chart
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_interest_rate_chart`;

CREATE TABLE `m_interest_rate_chart` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `from_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_primary_grouping_by_amount` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_interest_rate_slab
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_interest_rate_slab`;

CREATE TABLE `m_interest_rate_slab` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `interest_rate_chart_id` bigint(20) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `period_type_enum` smallint(5) DEFAULT NULL,
  `from_period` int(11) DEFAULT NULL,
  `to_period` int(11) DEFAULT NULL,
  `amount_range_from` decimal(19,6) DEFAULT NULL,
  `amount_range_to` decimal(19,6) DEFAULT NULL,
  `annual_interest_rate` decimal(19,6) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKIRS00000000000001` (`interest_rate_chart_id`),
  CONSTRAINT `FKIRS00000000000001` FOREIGN KEY (`interest_rate_chart_id`) REFERENCES `m_interest_rate_chart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan`;

CREATE TABLE `m_loan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `fund_id` bigint(20) DEFAULT NULL,
  `loan_officer_id` bigint(20) DEFAULT NULL,
  `loanpurpose_cv_id` int(11) DEFAULT NULL,
  `loan_status_id` smallint(5) NOT NULL,
  `loan_type_enum` smallint(5) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `principal_amount_proposed` decimal(19,6) NOT NULL,
  `principal_amount` decimal(19,6) NOT NULL,
  `approved_principal` decimal(19,6) NOT NULL,
  `arrearstolerance_amount` decimal(19,6) DEFAULT NULL,
  `is_floating_interest_rate` bit(1) DEFAULT b'0',
  `interest_rate_differential` decimal(19,6) DEFAULT '0.000000',
  `nominal_interest_rate_per_period` decimal(19,6) DEFAULT NULL,
  `interest_period_frequency_enum` smallint(5) DEFAULT NULL,
  `annual_nominal_interest_rate` decimal(19,6) DEFAULT NULL,
  `interest_method_enum` smallint(5) NOT NULL,
  `interest_calculated_in_period_enum` smallint(5) NOT NULL DEFAULT '1',
  `allow_partial_period_interest_calcualtion` tinyint(1) NOT NULL DEFAULT '0',
  `term_frequency` smallint(5) NOT NULL DEFAULT '0',
  `term_period_frequency_enum` smallint(5) NOT NULL DEFAULT '2',
  `repay_every` smallint(5) NOT NULL,
  `repayment_period_frequency_enum` smallint(5) NOT NULL,
  `number_of_repayments` smallint(5) NOT NULL,
  `grace_on_principal_periods` smallint(5) DEFAULT NULL,
  `recurring_moratorium_principal_periods` smallint(5) DEFAULT NULL,
  `grace_on_interest_periods` smallint(5) DEFAULT NULL,
  `grace_interest_free_periods` smallint(5) DEFAULT NULL,
  `amortization_method_enum` smallint(5) NOT NULL,
  `submittedon_date` date DEFAULT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `approvedon_date` date DEFAULT NULL,
  `approvedon_userid` bigint(20) DEFAULT NULL,
  `expected_disbursedon_date` date DEFAULT NULL,
  `expected_firstrepaymenton_date` date DEFAULT NULL,
  `interest_calculated_from_date` date DEFAULT NULL,
  `disbursedon_date` date DEFAULT NULL,
  `disbursedon_userid` bigint(20) DEFAULT NULL,
  `expected_maturedon_date` date DEFAULT NULL,
  `maturedon_date` date DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `total_charges_due_at_disbursement_derived` decimal(19,6) DEFAULT NULL,
  `principal_disbursed_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `principal_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `principal_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `principal_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_charged_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_charged_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_charged_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_repaid_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_expected_repayment_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_repayment_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_expected_costofloan_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_costofloan_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_waived_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_writtenoff_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_overpaid_derived` decimal(19,6) DEFAULT NULL,
  `rejectedon_date` date DEFAULT NULL,
  `rejectedon_userid` bigint(20) DEFAULT NULL,
  `rescheduledon_date` date DEFAULT NULL,
  `rescheduledon_userid` bigint(20) DEFAULT NULL,
  `withdrawnon_date` date DEFAULT NULL,
  `withdrawnon_userid` bigint(20) DEFAULT NULL,
  `writtenoffon_date` date DEFAULT NULL,
  `loan_transaction_strategy_id` bigint(20) DEFAULT NULL,
  `sync_disbursement_with_meeting` tinyint(1) DEFAULT NULL,
  `loan_counter` smallint(6) DEFAULT NULL,
  `loan_product_counter` smallint(6) DEFAULT NULL,
  `fixed_emi_amount` decimal(19,6) DEFAULT NULL,
  `max_outstanding_loan_balance` decimal(19,6) DEFAULT NULL,
  `grace_on_arrears_ageing` smallint(5) DEFAULT NULL,
  `is_npa` tinyint(1) NOT NULL DEFAULT '0',
  `total_recovered_derived` decimal(19,6) DEFAULT NULL,
  `accrued_till` date DEFAULT NULL,
  `interest_recalcualated_on` date DEFAULT NULL,
  `days_in_month_enum` smallint(5) NOT NULL DEFAULT '1',
  `days_in_year_enum` smallint(5) NOT NULL DEFAULT '1',
  `interest_recalculation_enabled` tinyint(4) NOT NULL DEFAULT '0',
  `guarantee_amount_derived` decimal(19,6) DEFAULT NULL,
  `create_standing_instruction_at_disbursement` tinyint(1) DEFAULT NULL,
  `version` int(15) NOT NULL DEFAULT '1',
  `writeoff_reason_cv_id` int(11) DEFAULT NULL,
  `loan_sub_status_id` smallint(5) DEFAULT NULL,
  `is_topup` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `loan_account_no_UNIQUE` (`account_no`),
  UNIQUE KEY `loan_externalid_UNIQUE` (`external_id`),
  KEY `FKB6F935D87179A0CB` (`client_id`),
  KEY `FKB6F935D8C8D4B434` (`product_id`),
  KEY `FK7C885877240145` (`fund_id`),
  KEY `FK_loan_ltp_strategy` (`loan_transaction_strategy_id`),
  KEY `FK_m_loan_m_staff` (`loan_officer_id`),
  KEY `group_id` (`group_id`),
  KEY `FK_m_loanpurpose_codevalue` (`loanpurpose_cv_id`),
  KEY `FK_submittedon_userid` (`submittedon_userid`),
  KEY `FK_approvedon_userid` (`approvedon_userid`),
  KEY `FK_rejectedon_userid` (`rejectedon_userid`),
  KEY `FK_withdrawnon_userid` (`withdrawnon_userid`),
  KEY `FK_disbursedon_userid` (`disbursedon_userid`),
  KEY `FK_closedon_userid` (`closedon_userid`),
  KEY `fk_m_group_client_001_idx` (`group_id`,`client_id`),
  KEY `FK_writeoffreason_m_loan_m_code_value` (`writeoff_reason_cv_id`),
  CONSTRAINT `FK7C885877240145` FOREIGN KEY (`fund_id`) REFERENCES `m_fund` (`id`),
  CONSTRAINT `FKB6F935D87179A0CB` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKB6F935D8C8D4B434` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`),
  CONSTRAINT `FK_approvedon_userid` FOREIGN KEY (`approvedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_closedon_userid` FOREIGN KEY (`closedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_disbursedon_userid` FOREIGN KEY (`disbursedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_loan_ltp_strategy` FOREIGN KEY (`loan_transaction_strategy_id`) REFERENCES `ref_loan_transaction_processing_strategy` (`id`),
  CONSTRAINT `FK_m_loan_m_staff` FOREIGN KEY (`loan_officer_id`) REFERENCES `m_staff` (`id`),
  CONSTRAINT `FK_m_loanpurpose_codevalue` FOREIGN KEY (`loanpurpose_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_rejectedon_userid` FOREIGN KEY (`rejectedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_submittedon_userid` FOREIGN KEY (`submittedon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_withdrawnon_userid` FOREIGN KEY (`withdrawnon_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_writeoffreason_m_loan_m_code_value` FOREIGN KEY (`writeoff_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `m_loan_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_arrears_aging
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_arrears_aging`;

CREATE TABLE `m_loan_arrears_aging` (
  `loan_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `principal_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_overdue_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `overdue_since_date_derived` date DEFAULT NULL,
  PRIMARY KEY (`loan_id`),
  CONSTRAINT `m_loan_arrears_aging_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_charge`;

CREATE TABLE `m_loan_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `charge_time_enum` smallint(5) NOT NULL,
  `due_for_collection_as_of_date` date DEFAULT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `charge_payment_mode_enum` smallint(5) NOT NULL DEFAULT '0',
  `calculation_percentage` decimal(19,6) DEFAULT NULL,
  `calculation_on_amount` decimal(19,6) DEFAULT NULL,
  `charge_amount_or_percentage` decimal(19,6) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `min_cap` decimal(19,6) DEFAULT NULL,
  `max_cap` decimal(19,6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `charge_id` (`charge_id`),
  KEY `m_loan_charge_ibfk_2` (`loan_id`),
  CONSTRAINT `m_loan_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_loan_charge_ibfk_2` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_charge_paid_by
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_charge_paid_by`;

CREATE TABLE `m_loan_charge_paid_by` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_transaction_id` bigint(20) NOT NULL,
  `loan_charge_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `installment_number` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__m_loan_transaction` (`loan_transaction_id`),
  KEY `FK__m_loan_charge` (`loan_charge_id`),
  CONSTRAINT `FK__m_loan_charge` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK__m_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_collateral
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_collateral`;

CREATE TABLE `m_loan_collateral` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `type_cv_id` int(11) NOT NULL,
  `value` decimal(19,6) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_collateral_m_loan` (`loan_id`),
  KEY `FK_collateral_code_value` (`type_cv_id`),
  CONSTRAINT `FK_collateral_code_value` FOREIGN KEY (`type_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `FK_collateral_m_loan` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_disbursement_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_disbursement_detail`;

CREATE TABLE `m_loan_disbursement_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `expected_disburse_date` datetime NOT NULL,
  `disbursedon_date` datetime DEFAULT NULL,
  `principal` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_loan_disbursement_detail_loan_id` (`loan_id`),
  CONSTRAINT `FK_loan_disbursement_detail_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_installment_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_installment_charge`;

CREATE TABLE `m_loan_installment_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_charge_id` bigint(20) NOT NULL,
  `loan_schedule_id` bigint(20) NOT NULL,
  `due_date` date DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `amount_through_charge_payment` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_loan_charge_id_charge_schedule` (`loan_charge_id`),
  KEY `FK_loan_schedule_id_charge_schedule` (`loan_schedule_id`),
  CONSTRAINT `FK_loan_charge_id_charge_schedule` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK_loan_schedule_id_charge_schedule` FOREIGN KEY (`loan_schedule_id`) REFERENCES `m_loan_repayment_schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_interest_recalculation_additional_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_interest_recalculation_additional_details`;

CREATE TABLE `m_loan_interest_recalculation_additional_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_repayment_schedule_id` bigint(20) NOT NULL,
  `effective_date` date NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_additional_details_repayment_schedule_id` (`loan_repayment_schedule_id`),
  CONSTRAINT `FK_additional_details_repayment_schedule_id` FOREIGN KEY (`loan_repayment_schedule_id`) REFERENCES `m_loan_repayment_schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loan_officer_assignment_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_officer_assignment_history`;

CREATE TABLE `m_loan_officer_assignment_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `loan_officer_id` bigint(20) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_m_loan_officer_assignment_history_0001` (`loan_id`),
  KEY `fk_m_loan_officer_assignment_history_0002` (`loan_officer_id`),
  CONSTRAINT `fk_m_loan_officer_assignment_history_0001` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `fk_m_loan_officer_assignment_history_0002` FOREIGN KEY (`loan_officer_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_overdue_installment_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_overdue_installment_charge`;

CREATE TABLE `m_loan_overdue_installment_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_charge_id` bigint(20) NOT NULL,
  `loan_schedule_id` bigint(20) NOT NULL,
  `frequency_number` int(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_loan_overdue_installment_charge_m_loan_charge` (`loan_charge_id`),
  KEY `FK_m_loan_overdue_installment_charge_m_loan_repayment_schedule` (`loan_schedule_id`),
  CONSTRAINT `FK_m_loan_overdue_installment_charge_m_loan_charge` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK_m_loan_overdue_installment_charge_m_loan_repayment_schedule` FOREIGN KEY (`loan_schedule_id`) REFERENCES `m_loan_repayment_schedule` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_paid_in_advance
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_paid_in_advance`;

CREATE TABLE `m_loan_paid_in_advance` (
  `loan_id` bigint(20) NOT NULL,
  `principal_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `interest_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `fee_charges_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `penalty_charges_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `total_in_advance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  PRIMARY KEY (`loan_id`),
  CONSTRAINT `m_loan_paid_in_advance_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_recalculation_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_recalculation_details`;

CREATE TABLE `m_loan_recalculation_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `compound_type_enum` smallint(5) NOT NULL,
  `reschedule_strategy_enum` smallint(5) NOT NULL,
  `rest_frequency_type_enum` smallint(1) NOT NULL,
  `rest_frequency_interval` smallint(3) NOT NULL DEFAULT '0',
  `compounding_frequency_type_enum` smallint(1) DEFAULT NULL,
  `compounding_frequency_interval` smallint(3) DEFAULT NULL,
  `rest_frequency_nth_day_enum` int(5) DEFAULT NULL,
  `rest_frequency_on_day` int(5) DEFAULT NULL,
  `rest_frequency_weekday_enum` int(5) DEFAULT NULL,
  `compounding_frequency_nth_day_enum` int(5) DEFAULT NULL,
  `compounding_frequency_on_day` int(5) DEFAULT NULL,
  `is_compounding_to_be_posted_as_transaction` tinyint(1) NOT NULL DEFAULT '0',
  `compounding_frequency_weekday_enum` int(5) DEFAULT NULL,
  `allow_compounding_on_eod` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_m_loan_m_loan_recalculation_details` (`loan_id`),
  CONSTRAINT `FK_m_loan_m_loan_recalculation_details` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loan_repayment_schedule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_repayment_schedule`;

CREATE TABLE `m_loan_repayment_schedule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `fromdate` date DEFAULT NULL,
  `duedate` date NOT NULL,
  `installment` smallint(5) NOT NULL,
  `principal_amount` decimal(19,6) DEFAULT NULL,
  `principal_completed_derived` decimal(19,6) DEFAULT NULL,
  `principal_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `interest_amount` decimal(19,6) DEFAULT NULL,
  `interest_completed_derived` decimal(19,6) DEFAULT NULL,
  `interest_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `interest_waived_derived` decimal(19,6) DEFAULT NULL,
  `accrual_interest_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_amount` decimal(19,6) DEFAULT NULL,
  `fee_charges_completed_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_waived_derived` decimal(19,6) DEFAULT NULL,
  `accrual_fee_charges_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_amount` decimal(19,6) DEFAULT NULL,
  `penalty_charges_completed_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_waived_derived` decimal(19,6) DEFAULT NULL,
  `accrual_penalty_charges_derived` decimal(19,6) DEFAULT NULL,
  `total_paid_in_advance_derived` decimal(19,6) DEFAULT NULL,
  `total_paid_late_derived` decimal(19,6) DEFAULT NULL,
  `completed_derived` bit(1) NOT NULL,
  `obligations_met_on_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `recalculated_interest_component` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK488B92AA40BE0710` (`loan_id`),
  CONSTRAINT `FK488B92AA40BE0710` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_repayment_schedule_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_repayment_schedule_history`;

CREATE TABLE `m_loan_repayment_schedule_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `loan_reschedule_request_id` bigint(20) DEFAULT NULL,
  `fromdate` date DEFAULT NULL,
  `duedate` date NOT NULL,
  `installment` smallint(5) NOT NULL,
  `principal_amount` decimal(19,6) DEFAULT NULL,
  `interest_amount` decimal(19,6) DEFAULT NULL,
  `fee_charges_amount` decimal(19,6) DEFAULT NULL,
  `penalty_charges_amount` decimal(19,6) DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `version` int(5) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_id` (`loan_id`),
  KEY `loan_reschedule_request_id` (`loan_reschedule_request_id`),
  CONSTRAINT `m_loan_repayment_schedule_history_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `m_loan_repayment_schedule_history_ibfk_2` FOREIGN KEY (`loan_reschedule_request_id`) REFERENCES `m_loan_reschedule_request` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loan_reschedule_request
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_reschedule_request`;

CREATE TABLE `m_loan_reschedule_request` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `status_enum` smallint(5) NOT NULL,
  `reschedule_from_installment` smallint(5) NOT NULL COMMENT 'Rescheduling will start from this installment',
  `reschedule_from_date` date NOT NULL COMMENT 'Rescheduling will start from the installment with due date similar to this date.',
  `recalculate_interest` tinyint(1) DEFAULT NULL COMMENT 'If set to 1, interest will be recalculated starting from the reschedule period.',
  `reschedule_reason_cv_id` int(11) DEFAULT NULL COMMENT 'ID of code value of reason for rescheduling',
  `reschedule_reason_comment` varchar(500) DEFAULT NULL COMMENT 'Text provided in addition to the reason code value',
  `submitted_on_date` date NOT NULL,
  `submitted_by_user_id` bigint(20) NOT NULL,
  `approved_on_date` date DEFAULT NULL,
  `approved_by_user_id` bigint(20) DEFAULT NULL,
  `rejected_on_date` date DEFAULT NULL,
  `rejected_by_user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `loan_id` (`loan_id`),
  KEY `reschedule_reason_cv_id` (`reschedule_reason_cv_id`),
  KEY `submitted_by_user_id` (`submitted_by_user_id`),
  KEY `approved_by_user_id` (`approved_by_user_id`),
  KEY `rejected_by_user_id` (`rejected_by_user_id`),
  CONSTRAINT `m_loan_reschedule_request_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `m_loan_reschedule_request_ibfk_2` FOREIGN KEY (`reschedule_reason_cv_id`) REFERENCES `m_code_value` (`id`),
  CONSTRAINT `m_loan_reschedule_request_ibfk_3` FOREIGN KEY (`submitted_by_user_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_loan_reschedule_request_ibfk_4` FOREIGN KEY (`approved_by_user_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_loan_reschedule_request_ibfk_5` FOREIGN KEY (`rejected_by_user_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loan_reschedule_request_term_variations_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_reschedule_request_term_variations_mapping`;

CREATE TABLE `m_loan_reschedule_request_term_variations_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_reschedule_request_id` bigint(20) NOT NULL,
  `loan_term_variations_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__m_loan_reschedule_request` (`loan_reschedule_request_id`),
  KEY `FK__m_loan_term_variations` (`loan_term_variations_id`),
  CONSTRAINT `FK__m_loan_reschedule_request` FOREIGN KEY (`loan_reschedule_request_id`) REFERENCES `m_loan_reschedule_request` (`id`),
  CONSTRAINT `FK__m_loan_term_variations` FOREIGN KEY (`loan_term_variations_id`) REFERENCES `m_loan_term_variations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_term_variations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_term_variations`;

CREATE TABLE `m_loan_term_variations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `term_type` smallint(2) NOT NULL,
  `applicable_date` date NOT NULL,
  `decimal_value` decimal(19,6) DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `is_specific_to_installment` tinyint(4) NOT NULL DEFAULT '0',
  `applied_on_loan_status` smallint(5) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `parent_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_loan_id_m_loan_id` (`loan_id`),
  CONSTRAINT `FK_loan_id_m_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_topup
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_topup`;

CREATE TABLE `m_loan_topup` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `closure_loan_id` bigint(20) NOT NULL,
  `account_transfer_details_id` bigint(20) DEFAULT NULL,
  `topup_amount` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `m_loan_topup_FK_loan_id` (`loan_id`),
  KEY `m_loan_topup_FK_closure_loan_id` (`closure_loan_id`),
  KEY `m_loan_topup_FK_account_transfer_details_id` (`account_transfer_details_id`),
  CONSTRAINT `m_loan_topup_FK_account_transfer_details_id` FOREIGN KEY (`account_transfer_details_id`) REFERENCES `m_account_transfer_details` (`id`),
  CONSTRAINT `m_loan_topup_FK_closure_loan_id` FOREIGN KEY (`closure_loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `m_loan_topup_FK_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_tranche_charges
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_tranche_charges`;

CREATE TABLE `m_loan_tranche_charges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_loan_tranche_charges_m_loan` (`loan_id`),
  KEY `FK_m_loan_tranche_charges_m_charge` (`charge_id`),
  CONSTRAINT `FK_m_loan_tranche_charges_m_charge` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `FK_m_loan_tranche_charges_m_loan` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loan_tranche_disbursement_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_tranche_disbursement_charge`;

CREATE TABLE `m_loan_tranche_disbursement_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_charge_id` bigint(20) NOT NULL,
  `disbursement_detail_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_loan_tranche_disbursement_charge_m_loan_charge` (`loan_charge_id`),
  KEY `FK_m_loan_tranche_disbursement_charge_m_loan_disbursement_detail` (`disbursement_detail_id`),
  CONSTRAINT `FK_m_loan_tranche_disbursement_charge_m_loan_charge` FOREIGN KEY (`loan_charge_id`) REFERENCES `m_loan_charge` (`id`),
  CONSTRAINT `FK_m_loan_tranche_disbursement_charge_m_loan_disbursement_detail` FOREIGN KEY (`disbursement_detail_id`) REFERENCES `m_loan_disbursement_detail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_transaction`;

CREATE TABLE `m_loan_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `payment_detail_id` bigint(20) DEFAULT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `transaction_type_enum` smallint(5) NOT NULL,
  `transaction_date` date NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `principal_portion_derived` decimal(19,6) DEFAULT NULL,
  `interest_portion_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_portion_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_portion_derived` decimal(19,6) DEFAULT NULL,
  `overpayment_portion_derived` decimal(19,6) DEFAULT NULL,
  `unrecognized_income_portion` decimal(19,6) DEFAULT NULL,
  `outstanding_loan_balance_derived` decimal(19,6) DEFAULT NULL,
  `submitted_on_date` date NOT NULL,
  `manually_adjusted_or_reversed` tinyint(1) DEFAULT '0',
  `created_date` datetime DEFAULT NULL,
  `appuser_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  KEY `FKCFCEA42640BE0710` (`loan_id`),
  KEY `FK_m_loan_transaction_m_payment_detail` (`payment_detail_id`),
  KEY `FK_m_loan_transaction_m_office` (`office_id`),
  CONSTRAINT `FKCFCEA42640BE0710` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK_m_loan_transaction_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_loan_transaction_m_payment_detail` FOREIGN KEY (`payment_detail_id`) REFERENCES `m_payment_detail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_loan_transaction_repayment_schedule_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loan_transaction_repayment_schedule_mapping`;

CREATE TABLE `m_loan_transaction_repayment_schedule_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_transaction_id` bigint(20) NOT NULL,
  `loan_repayment_schedule_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `principal_portion_derived` decimal(19,6) DEFAULT NULL,
  `interest_portion_derived` decimal(19,6) DEFAULT NULL,
  `fee_charges_portion_derived` decimal(19,6) DEFAULT NULL,
  `penalty_charges_portion_derived` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_mappings_m_loan_transaction` (`loan_transaction_id`),
  KEY `FK_mappings_m_loan_repayment_schedule` (`loan_repayment_schedule_id`),
  CONSTRAINT `FK_mappings_m_loan_repayment_schedule` FOREIGN KEY (`loan_repayment_schedule_id`) REFERENCES `m_loan_repayment_schedule` (`id`),
  CONSTRAINT `FK_mappings_m_loan_transaction` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loanproduct_provisioning_entry
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loanproduct_provisioning_entry`;

CREATE TABLE `m_loanproduct_provisioning_entry` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `history_id` bigint(20) NOT NULL,
  `criteria_id` bigint(20) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  `overdue_in_days` bigint(20) DEFAULT '0',
  `reseve_amount` decimal(20,6) DEFAULT '0.000000',
  `liability_account` bigint(20) DEFAULT NULL,
  `expense_account` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `history_id` (`history_id`),
  KEY `criteria_id` (`criteria_id`),
  KEY `office_id` (`office_id`),
  KEY `product_id` (`product_id`),
  KEY `category_id` (`category_id`),
  KEY `liability_account` (`liability_account`),
  KEY `expense_account` (`expense_account`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_1` FOREIGN KEY (`history_id`) REFERENCES `m_provisioning_history` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_2` FOREIGN KEY (`criteria_id`) REFERENCES `m_provisioning_criteria` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_3` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_4` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_5` FOREIGN KEY (`category_id`) REFERENCES `m_provision_category` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_6` FOREIGN KEY (`liability_account`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_entry_ibfk_7` FOREIGN KEY (`expense_account`) REFERENCES `acc_gl_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_loanproduct_provisioning_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_loanproduct_provisioning_mapping`;

CREATE TABLE `m_loanproduct_provisioning_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `criteria_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`),
  KEY `criteria_id` (`criteria_id`),
  CONSTRAINT `m_loanproduct_provisioning_mapping_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`),
  CONSTRAINT `m_loanproduct_provisioning_mapping_ibfk_2` FOREIGN KEY (`criteria_id`) REFERENCES `m_provisioning_criteria` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_mandatory_savings_schedule
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_mandatory_savings_schedule`;

CREATE TABLE `m_mandatory_savings_schedule` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `fromdate` date DEFAULT NULL,
  `duedate` date NOT NULL,
  `installment` smallint(5) NOT NULL,
  `deposit_amount` decimal(19,6) DEFAULT NULL,
  `deposit_amount_completed_derived` decimal(19,6) DEFAULT NULL,
  `total_paid_in_advance_derived` decimal(19,6) DEFAULT NULL,
  `total_paid_late_derived` decimal(19,6) DEFAULT NULL,
  `completed_derived` bit(1) NOT NULL,
  `obligations_met_on_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKMSS0000000001` (`savings_account_id`),
  CONSTRAINT `FKMSS0000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_meeting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_meeting`;

CREATE TABLE `m_meeting` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `calendar_instance_id` bigint(20) NOT NULL,
  `meeting_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_calendar_instance_id_meeting_date` (`calendar_instance_id`,`meeting_date`),
  CONSTRAINT `FK_m_calendar_instance_m_meeting` FOREIGN KEY (`calendar_instance_id`) REFERENCES `m_calendar_instance` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_note
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_note`;

CREATE TABLE `m_note` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `loan_id` bigint(20) DEFAULT NULL,
  `loan_transaction_id` bigint(20) DEFAULT NULL,
  `savings_account_id` bigint(20) DEFAULT NULL,
  `savings_account_transaction_id` bigint(20) DEFAULT NULL,
  `share_account_id` bigint(20) DEFAULT NULL,
  `note_type_enum` smallint(5) NOT NULL,
  `note` varchar(1000) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK7C9708924D26803` (`loan_transaction_id`),
  KEY `FK7C97089541F0A56` (`createdby_id`),
  KEY `FK7C970897179A0CB` (`client_id`),
  KEY `FK_m_note_m_group` (`group_id`),
  KEY `FK7C970898F889C3F` (`lastmodifiedby_id`),
  KEY `FK7C9708940BE0710` (`loan_id`),
  KEY `FK_savings_account_id` (`savings_account_id`),
  CONSTRAINT `FK7C9708924D26803` FOREIGN KEY (`loan_transaction_id`) REFERENCES `m_loan_transaction` (`id`),
  CONSTRAINT `FK7C9708940BE0710` FOREIGN KEY (`loan_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `FK7C97089541F0A56` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK7C970897179A0CB` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FK7C970898F889C3F` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_note_m_group` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FK_savings_account_id` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_office
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_office`;

CREATE TABLE `m_office` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT NULL,
  `hierarchy` varchar(100) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `opening_date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_org` (`name`),
  UNIQUE KEY `externalid_org` (`external_id`),
  KEY `FK2291C477E2551DCC` (`parent_id`),
  CONSTRAINT `FK2291C477E2551DCC` FOREIGN KEY (`parent_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_office` WRITE;
/*!40000 ALTER TABLE `m_office` DISABLE KEYS */;

INSERT INTO `m_office` (`id`, `parent_id`, `hierarchy`, `external_id`, `name`, `opening_date`)
VALUES
	(1,NULL,'.','1','Head Office','2009-01-01');

/*!40000 ALTER TABLE `m_office` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_office_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_office_transaction`;

CREATE TABLE `m_office_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `from_office_id` bigint(20) DEFAULT NULL,
  `to_office_id` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` int(11) NOT NULL,
  `transaction_amount` decimal(19,6) NOT NULL,
  `transaction_date` date NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1E37728B93C6C1B6` (`to_office_id`),
  KEY `FK1E37728B783C5C25` (`from_office_id`),
  CONSTRAINT `FK1E37728B783C5C25` FOREIGN KEY (`from_office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK1E37728B93C6C1B6` FOREIGN KEY (`to_office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_organisation_currency
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_organisation_currency`;

CREATE TABLE `m_organisation_currency` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(3) NOT NULL,
  `decimal_places` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `display_symbol` varchar(10) DEFAULT NULL,
  `internationalized_name_code` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_organisation_currency` WRITE;
/*!40000 ALTER TABLE `m_organisation_currency` DISABLE KEYS */;

INSERT INTO `m_organisation_currency` (`id`, `code`, `decimal_places`, `currency_multiplesof`, `name`, `display_symbol`, `internationalized_name_code`)
VALUES
	(21,'USD',2,NULL,'US Dollar','$','currency.USD');

/*!40000 ALTER TABLE `m_organisation_currency` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_password_validation_policy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_password_validation_policy`;

CREATE TABLE `m_password_validation_policy` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `regex` text NOT NULL,
  `description` text NOT NULL,
  `active` tinyint(4) NOT NULL DEFAULT '0',
  `key` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_password_validation_policy` WRITE;
/*!40000 ALTER TABLE `m_password_validation_policy` DISABLE KEYS */;

INSERT INTO `m_password_validation_policy` (`id`, `regex`, `description`, `active`, `key`)
VALUES
	(1,'^.{1,50}$','Password most be at least 1 character and not more that 50 characters long',1,'simple'),
	(2,'^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\\s).{6,50}$','Password must be at least 6 characters, no more than 50 characters long, must include at least one upper case letter, one lower case letter, one numeric digit and no space',0,'secure');

/*!40000 ALTER TABLE `m_password_validation_policy` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_payment_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_payment_detail`;

CREATE TABLE `m_payment_detail` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `payment_type_id` int(11) DEFAULT NULL,
  `account_number` varchar(100) DEFAULT NULL,
  `check_number` varchar(100) DEFAULT NULL,
  `receipt_number` varchar(100) DEFAULT NULL,
  `bank_number` varchar(100) DEFAULT NULL,
  `routing_code` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_payment_detail_m_payment_type` (`payment_type_id`),
  CONSTRAINT `FK_m_payment_detail_m_payment_type` FOREIGN KEY (`payment_type_id`) REFERENCES `m_payment_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_payment_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_payment_type`;

CREATE TABLE `m_payment_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(100) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `is_cash_payment` tinyint(1) DEFAULT '0',
  `order_position` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_permission`;

CREATE TABLE `m_permission` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `grouping` varchar(45) DEFAULT NULL,
  `code` varchar(100) NOT NULL,
  `entity_name` varchar(100) DEFAULT NULL,
  `action_name` varchar(100) DEFAULT NULL,
  `can_maker_checker` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_permission` WRITE;
/*!40000 ALTER TABLE `m_permission` DISABLE KEYS */;

INSERT INTO `m_permission` (`id`, `grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`)
VALUES
	(1,'special','ALL_FUNCTIONS',NULL,NULL,0),
	(2,'special','ALL_FUNCTIONS_READ',NULL,NULL,0),
	(3,'special','CHECKER_SUPER_USER',NULL,NULL,0),
	(4,'special','REPORTING_SUPER_USER',NULL,NULL,0),
	(5,'authorisation','READ_PERMISSION','PERMISSION','READ',0),
	(6,'authorisation','PERMISSIONS_ROLE','ROLE','PERMISSIONS',0),
	(7,'authorisation','CREATE_ROLE','ROLE','CREATE',0),
	(8,'authorisation','CREATE_ROLE_CHECKER','ROLE','CREATE_CHECKER',0),
	(9,'authorisation','READ_ROLE','ROLE','READ',0),
	(10,'authorisation','UPDATE_ROLE','ROLE','UPDATE',0),
	(11,'authorisation','UPDATE_ROLE_CHECKER','ROLE','UPDATE_CHECKER',0),
	(12,'authorisation','DELETE_ROLE','ROLE','DELETE',0),
	(13,'authorisation','DELETE_ROLE_CHECKER','ROLE','DELETE_CHECKER',0),
	(14,'authorisation','CREATE_USER','USER','CREATE',0),
	(15,'authorisation','CREATE_USER_CHECKER','USER','CREATE_CHECKER',0),
	(16,'authorisation','READ_USER','USER','READ',0),
	(17,'authorisation','UPDATE_USER','USER','UPDATE',0),
	(18,'authorisation','UPDATE_USER_CHECKER','USER','UPDATE_CHECKER',0),
	(19,'authorisation','DELETE_USER','USER','DELETE',0),
	(20,'authorisation','DELETE_USER_CHECKER','USER','DELETE_CHECKER',0),
	(21,'configuration','READ_CONFIGURATION','CONFIGURATION','READ',0),
	(22,'configuration','UPDATE_CONFIGURATION','CONFIGURATION','UPDATE',0),
	(23,'configuration','UPDATE_CONFIGURATION_CHECKER','CONFIGURATION','UPDATE_CHECKER',0),
	(24,'configuration','READ_CODE','CODE','READ',0),
	(25,'configuration','CREATE_CODE','CODE','CREATE',0),
	(26,'configuration','CREATE_CODE_CHECKER','CODE','CREATE_CHECKER',0),
	(27,'configuration','UPDATE_CODE','CODE','UPDATE',0),
	(28,'configuration','UPDATE_CODE_CHECKER','CODE','UPDATE_CHECKER',0),
	(29,'configuration','DELETE_CODE','CODE','DELETE',0),
	(30,'configuration','DELETE_CODE_CHECKER','CODE','DELETE_CHECKER',0),
	(31,'configuration','READ_CODEVALUE','CODEVALUE','READ',0),
	(32,'configuration','CREATE_CODEVALUE','CODEVALUE','CREATE',0),
	(33,'configuration','CREATE_CODEVALUE_CHECKER','CODEVALUE','CREATE_CHECKER',0),
	(34,'configuration','UPDATE_CODEVALUE','CODEVALUE','UPDATE',0),
	(35,'configuration','UPDATE_CODEVALUE_CHECKER','CODEVALUE','UPDATE_CHECKER',0),
	(36,'configuration','DELETE_CODEVALUE','CODEVALUE','DELETE',0),
	(37,'configuration','DELETE_CODEVALUE_CHECKER','CODEVALUE','DELETE_CHECKER',0),
	(38,'configuration','READ_CURRENCY','CURRENCY','READ',0),
	(39,'configuration','UPDATE_CURRENCY','CURRENCY','UPDATE',0),
	(40,'configuration','UPDATE_CURRENCY_CHECKER','CURRENCY','UPDATE_CHECKER',0),
	(41,'configuration','UPDATE_PERMISSION','PERMISSION','UPDATE',0),
	(42,'configuration','UPDATE_PERMISSION_CHECKER','PERMISSION','UPDATE_CHECKER',0),
	(43,'configuration','READ_DATATABLE','DATATABLE','READ',0),
	(44,'configuration','REGISTER_DATATABLE','DATATABLE','REGISTER',0),
	(45,'configuration','REGISTER_DATATABLE_CHECKER','DATATABLE','REGISTER_CHECKER',0),
	(46,'configuration','DEREGISTER_DATATABLE','DATATABLE','DEREGISTER',0),
	(47,'configuration','DEREGISTER_DATATABLE_CHECKER','DATATABLE','DEREGISTER_CHECKER',0),
	(48,'configuration','READ_AUDIT','AUDIT','READ',0),
	(49,'configuration','CREATE_CALENDAR','CALENDAR','CREATE',0),
	(50,'configuration','READ_CALENDAR','CALENDAR','READ',0),
	(51,'configuration','UPDATE_CALENDAR','CALENDAR','UPDATE',0),
	(52,'configuration','DELETE_CALENDAR','CALENDAR','DELETE',0),
	(53,'configuration','CREATE_CALENDAR_CHECKER','CALENDAR','CREATE_CHECKER',0),
	(54,'configuration','UPDATE_CALENDAR_CHECKER','CALENDAR','UPDATE_CHECKER',0),
	(55,'configuration','DELETE_CALENDAR_CHECKER','CALENDAR','DELETE_CHECKER',0),
	(57,'organisation','READ_CHARGE','CHARGE','READ',0),
	(58,'organisation','CREATE_CHARGE','CHARGE','CREATE',0),
	(59,'organisation','CREATE_CHARGE_CHECKER','CHARGE','CREATE_CHECKER',0),
	(60,'organisation','UPDATE_CHARGE','CHARGE','UPDATE',0),
	(61,'organisation','UPDATE_CHARGE_CHECKER','CHARGE','UPDATE_CHECKER',0),
	(62,'organisation','DELETE_CHARGE','CHARGE','DELETE',0),
	(63,'organisation','DELETE_CHARGE_CHECKER','CHARGE','DELETE_CHECKER',0),
	(64,'organisation','READ_FUND','FUND','READ',0),
	(65,'organisation','CREATE_FUND','FUND','CREATE',0),
	(66,'organisation','CREATE_FUND_CHECKER','FUND','CREATE_CHECKER',0),
	(67,'organisation','UPDATE_FUND','FUND','UPDATE',0),
	(68,'organisation','UPDATE_FUND_CHECKER','FUND','UPDATE_CHECKER',0),
	(69,'organisation','DELETE_FUND','FUND','DELETE',0),
	(70,'organisation','DELETE_FUND_CHECKER','FUND','DELETE_CHECKER',0),
	(71,'organisation','READ_LOANPRODUCT','LOANPRODUCT','READ',0),
	(72,'organisation','CREATE_LOANPRODUCT','LOANPRODUCT','CREATE',0),
	(73,'organisation','CREATE_LOANPRODUCT_CHECKER','LOANPRODUCT','CREATE_CHECKER',0),
	(74,'organisation','UPDATE_LOANPRODUCT','LOANPRODUCT','UPDATE',0),
	(75,'organisation','UPDATE_LOANPRODUCT_CHECKER','LOANPRODUCT','UPDATE_CHECKER',0),
	(76,'organisation','DELETE_LOANPRODUCT','LOANPRODUCT','DELETE',0),
	(77,'organisation','DELETE_LOANPRODUCT_CHECKER','LOANPRODUCT','DELETE_CHECKER',0),
	(78,'organisation','READ_OFFICE','OFFICE','READ',0),
	(79,'organisation','CREATE_OFFICE','OFFICE','CREATE',0),
	(80,'organisation','CREATE_OFFICE_CHECKER','OFFICE','CREATE_CHECKER',0),
	(81,'organisation','UPDATE_OFFICE','OFFICE','UPDATE',0),
	(82,'organisation','UPDATE_OFFICE_CHECKER','OFFICE','UPDATE_CHECKER',0),
	(83,'organisation','READ_OFFICETRANSACTION','OFFICETRANSACTION','READ',0),
	(84,'organisation','DELETE_OFFICE_CHECKER','OFFICE','DELETE_CHECKER',0),
	(85,'organisation','CREATE_OFFICETRANSACTION','OFFICETRANSACTION','CREATE',0),
	(86,'organisation','CREATE_OFFICETRANSACTION_CHECKER','OFFICETRANSACTION','CREATE_CHECKER',0),
	(87,'organisation','DELETE_OFFICETRANSACTION','OFFICETRANSACTION','DELETE',0),
	(88,'organisation','DELETE_OFFICETRANSACTION_CHECKER','OFFICETRANSACTION','DELETE_CHECKER',0),
	(89,'organisation','READ_STAFF','STAFF','READ',0),
	(90,'organisation','CREATE_STAFF','STAFF','CREATE',0),
	(91,'organisation','CREATE_STAFF_CHECKER','STAFF','CREATE_CHECKER',0),
	(92,'organisation','UPDATE_STAFF','STAFF','UPDATE',0),
	(93,'organisation','UPDATE_STAFF_CHECKER','STAFF','UPDATE_CHECKER',0),
	(94,'organisation','DELETE_STAFF','STAFF','DELETE',0),
	(95,'organisation','DELETE_STAFF_CHECKER','STAFF','DELETE_CHECKER',0),
	(96,'organisation','READ_SAVINGSPRODUCT','SAVINGSPRODUCT','READ',0),
	(97,'organisation','CREATE_SAVINGSPRODUCT','SAVINGSPRODUCT','CREATE',0),
	(98,'organisation','CREATE_SAVINGSPRODUCT_CHECKER','SAVINGSPRODUCT','CREATE_CHECKER',0),
	(99,'organisation','UPDATE_SAVINGSPRODUCT','SAVINGSPRODUCT','UPDATE',0),
	(100,'organisation','UPDATE_SAVINGSPRODUCT_CHECKER','SAVINGSPRODUCT','UPDATE_CHECKER',0),
	(101,'organisation','DELETE_SAVINGSPRODUCT','SAVINGSPRODUCT','DELETE',0),
	(102,'organisation','DELETE_SAVINGSPRODUCT_CHECKER','SAVINGSPRODUCT','DELETE_CHECKER',0),
	(103,'portfolio','READ_LOAN','LOAN','READ',0),
	(104,'portfolio','CREATE_LOAN','LOAN','CREATE',0),
	(105,'portfolio','CREATE_LOAN_CHECKER','LOAN','CREATE_CHECKER',0),
	(106,'portfolio','UPDATE_LOAN','LOAN','UPDATE',0),
	(107,'portfolio','UPDATE_LOAN_CHECKER','LOAN','UPDATE_CHECKER',0),
	(108,'portfolio','DELETE_LOAN','LOAN','DELETE',0),
	(109,'portfolio','DELETE_LOAN_CHECKER','LOAN','DELETE_CHECKER',0),
	(110,'portfolio','READ_CLIENT','CLIENT','READ',0),
	(111,'portfolio','CREATE_CLIENT','CLIENT','CREATE',0),
	(112,'portfolio','CREATE_CLIENT_CHECKER','CLIENT','CREATE_CHECKER',0),
	(113,'portfolio','UPDATE_CLIENT','CLIENT','UPDATE',0),
	(114,'portfolio','UPDATE_CLIENT_CHECKER','CLIENT','UPDATE_CHECKER',0),
	(115,'portfolio','DELETE_CLIENT','CLIENT','DELETE',0),
	(116,'portfolio','DELETE_CLIENT_CHECKER','CLIENT','DELETE_CHECKER',0),
	(117,'portfolio','READ_CLIENTIMAGE','CLIENTIMAGE','READ',0),
	(118,'portfolio','CREATE_CLIENTIMAGE','CLIENTIMAGE','CREATE',0),
	(119,'portfolio','CREATE_CLIENTIMAGE_CHECKER','CLIENTIMAGE','CREATE_CHECKER',0),
	(120,'portfolio','DELETE_CLIENTIMAGE','CLIENTIMAGE','DELETE',0),
	(121,'portfolio','DELETE_CLIENTIMAGE_CHECKER','CLIENTIMAGE','DELETE_CHECKER',0),
	(122,'portfolio','READ_CLIENTNOTE','CLIENTNOTE','READ',0),
	(123,'portfolio','CREATE_CLIENTNOTE','CLIENTNOTE','CREATE',0),
	(124,'portfolio','CREATE_CLIENTNOTE_CHECKER','CLIENTNOTE','CREATE_CHECKER',0),
	(125,'portfolio','UPDATE_CLIENTNOTE','CLIENTNOTE','UPDATE',0),
	(126,'portfolio','UPDATE_CLIENTNOTE_CHECKER','CLIENTNOTE','UPDATE_CHECKER',0),
	(127,'portfolio','DELETE_CLIENTNOTE','CLIENTNOTE','DELETE',0),
	(128,'portfolio','DELETE_CLIENTNOTE_CHECKER','CLIENTNOTE','DELETE_CHECKER',0),
	(129,'portfolio_group','READ_GROUPNOTE','GROUPNOTE','READ',0),
	(130,'portfolio_group','CREATE_GROUPNOTE','GROUPNOTE','CREATE',0),
	(131,'portfolio_group','UPDATE_GROUPNOTE','GROUPNOTE','UPDATE',0),
	(132,'portfolio_group','DELETE_GROUPNOTE','GROUPNOTE','DELETE',0),
	(133,'portfolio_group','CREATE_GROUPNOTE_CHECKER','GROUPNOTE','CREATE_CHECKER',0),
	(134,'portfolio_group','UPDATE_GROUPNOTE_CHECKER','GROUPNOTE','UPDATE_CHECKER',0),
	(135,'portfolio_group','DELETE_GROUPNOTE_CHECKER','GROUPNOTE','DELETE_CHECKER',0),
	(136,'portfolio','READ_LOANNOTE','LOANNOTE','READ',0),
	(137,'portfolio','CREATE_LOANNOTE','LOANNOTE','CREATE',0),
	(138,'portfolio','UPDATE_LOANNOTE','LOANNOTE','UPDATE',0),
	(139,'portfolio','DELETE_LOANNOTE','LOANNOTE','DELETE',0),
	(140,'portfolio','CREATE_LOANNOTE_CHECKER','LOANNOTE','CREATE_CHECKER',0),
	(141,'portfolio','UPDATE_LOANNOTE_CHECKER','LOANNOTE','UPDATE_CHECKER',0),
	(142,'portfolio','DELETE_LOANNOTE_CHECKER','LOANNOTE','DELETE_CHECKER',0),
	(143,'portfolio','READ_LOANTRANSACTIONNOTE','LOANTRANSACTIONNOTE','READ',0),
	(144,'portfolio','CREATE_LOANTRANSACTIONNOTE','LOANTRANSACTIONNOTE','CREATE',0),
	(145,'portfolio','UPDATE_LOANTRANSACTIONNOTE','LOANTRANSACTIONNOTE','UPDATE',0),
	(146,'portfolio','DELETE_LOANTRANSACTIONNOTE','LOANTRANSACTIONNOTE','DELETE',0),
	(147,'portfolio','CREATE_LOANTRANSACTIONNOTE_CHECKER','LOANTRANSACTIONNOTE','CREATE_CHECKER',0),
	(148,'portfolio','UPDATE_LOANTRANSACTIONNOTE_CHECKER','LOANTRANSACTIONNOTE','UPDATE_CHECKER',0),
	(149,'portfolio','DELETE_LOANTRANSACTIONNOTE_CHECKER','LOANTRANSACTIONNOTE','DELETE_CHECKER',0),
	(150,'portfolio','READ_SAVINGNOTE','SAVINGNOTE','READ',0),
	(151,'portfolio','CREATE_SAVINGNOTE','SAVINGNOTE','CREATE',0),
	(152,'portfolio','UPDATE_SAVINGNOTE','SAVINGNOTE','UPDATE',0),
	(153,'portfolio','DELETE_SAVINGNOTE','SAVINGNOTE','DELETE',0),
	(154,'portfolio','CREATE_SAVINGNOTE_CHECKER','SAVINGNOTE','CREATE_CHECKER',0),
	(155,'portfolio','UPDATE_SAVINGNOTE_CHECKER','SAVINGNOTE','UPDATE_CHECKER',0),
	(156,'portfolio','DELETE_SAVINGNOTE_CHECKER','SAVINGNOTE','DELETE_CHECKER',0),
	(157,'portfolio','READ_CLIENTIDENTIFIER','CLIENTIDENTIFIER','READ',0),
	(158,'portfolio','CREATE_CLIENTIDENTIFIER','CLIENTIDENTIFIER','CREATE',0),
	(159,'portfolio','CREATE_CLIENTIDENTIFIER_CHECKER','CLIENTIDENTIFIER','CREATE_CHECKER',0),
	(160,'portfolio','UPDATE_CLIENTIDENTIFIER','CLIENTIDENTIFIER','UPDATE',0),
	(161,'portfolio','UPDATE_CLIENTIDENTIFIER_CHECKER','CLIENTIDENTIFIER','UPDATE_CHECKER',0),
	(162,'portfolio','DELETE_CLIENTIDENTIFIER','CLIENTIDENTIFIER','DELETE',0),
	(163,'portfolio','DELETE_CLIENTIDENTIFIER_CHECKER','CLIENTIDENTIFIER','DELETE_CHECKER',0),
	(164,'portfolio','READ_DOCUMENT','DOCUMENT','READ',0),
	(165,'portfolio','CREATE_DOCUMENT','DOCUMENT','CREATE',0),
	(166,'portfolio','CREATE_DOCUMENT_CHECKER','DOCUMENT','CREATE_CHECKER',0),
	(167,'portfolio','UPDATE_DOCUMENT','DOCUMENT','UPDATE',0),
	(168,'portfolio','UPDATE_DOCUMENT_CHECKER','DOCUMENT','UPDATE_CHECKER',0),
	(169,'portfolio','DELETE_DOCUMENT','DOCUMENT','DELETE',0),
	(170,'portfolio','DELETE_DOCUMENT_CHECKER','DOCUMENT','DELETE_CHECKER',0),
	(171,'portfolio_group','READ_GROUP','GROUP','READ',0),
	(172,'portfolio_group','CREATE_GROUP','GROUP','CREATE',0),
	(173,'portfolio_group','CREATE_GROUP_CHECKER','GROUP','CREATE_CHECKER',0),
	(174,'portfolio_group','UPDATE_GROUP','GROUP','UPDATE',0),
	(175,'portfolio_group','UPDATE_GROUP_CHECKER','GROUP','UPDATE_CHECKER',0),
	(176,'portfolio_group','DELETE_GROUP','GROUP','DELETE',0),
	(177,'portfolio_group','DELETE_GROUP_CHECKER','GROUP','DELETE_CHECKER',0),
	(178,'portfolio_group','UNASSIGNSTAFF_GROUP','GROUP','UNASSIGNSTAFF',0),
	(179,'portfolio_group','UNASSIGNSTAFF_GROUP_CHECKER','GROUP','UNASSIGNSTAFF_CHECKER',0),
	(180,'portfolio','CREATE_LOANCHARGE','LOANCHARGE','CREATE',0),
	(181,'portfolio','CREATE_LOANCHARGE_CHECKER','LOANCHARGE','CREATE_CHECKER',0),
	(182,'portfolio','UPDATE_LOANCHARGE','LOANCHARGE','UPDATE',0),
	(183,'portfolio','UPDATE_LOANCHARGE_CHECKER','LOANCHARGE','UPDATE_CHECKER',0),
	(184,'portfolio','DELETE_LOANCHARGE','LOANCHARGE','DELETE',0),
	(185,'portfolio','DELETE_LOANCHARGE_CHECKER','LOANCHARGE','DELETE_CHECKER',0),
	(186,'portfolio','WAIVE_LOANCHARGE','LOANCHARGE','WAIVE',0),
	(187,'portfolio','WAIVE_LOANCHARGE_CHECKER','LOANCHARGE','WAIVE_CHECKER',0),
	(188,'portfolio','READ_SAVINGSACCOUNT','SAVINGSACCOUNT','READ',0),
	(189,'portfolio','CREATE_SAVINGSACCOUNT','SAVINGSACCOUNT','CREATE',0),
	(190,'portfolio','CREATE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','CREATE_CHECKER',0),
	(191,'portfolio','UPDATE_SAVINGSACCOUNT','SAVINGSACCOUNT','UPDATE',0),
	(192,'portfolio','UPDATE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','UPDATE_CHECKER',0),
	(193,'portfolio','DELETE_SAVINGSACCOUNT','SAVINGSACCOUNT','DELETE',0),
	(194,'portfolio','DELETE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','DELETE_CHECKER',0),
	(195,'portfolio','READ_GUARANTOR','GUARANTOR','READ',0),
	(196,'portfolio','CREATE_GUARANTOR','GUARANTOR','CREATE',0),
	(197,'portfolio','CREATE_GUARANTOR_CHECKER','GUARANTOR','CREATE_CHECKER',0),
	(198,'portfolio','UPDATE_GUARANTOR','GUARANTOR','UPDATE',0),
	(199,'portfolio','UPDATE_GUARANTOR_CHECKER','GUARANTOR','UPDATE_CHECKER',0),
	(200,'portfolio','DELETE_GUARANTOR','GUARANTOR','DELETE',0),
	(201,'portfolio','DELETE_GUARANTOR_CHECKER','GUARANTOR','DELETE_CHECKER',0),
	(202,'portfolio','READ_COLLATERAL','COLLATERAL','READ',0),
	(203,'portfolio','CREATE_COLLATERAL','COLLATERAL','CREATE',0),
	(204,'portfolio','UPDATE_COLLATERAL','COLLATERAL','UPDATE',0),
	(205,'portfolio','DELETE_COLLATERAL','COLLATERAL','DELETE',0),
	(206,'portfolio','CREATE_COLLATERAL_CHECKER','COLLATERAL','CREATE_CHECKER',0),
	(207,'portfolio','UPDATE_COLLATERAL_CHECKER','COLLATERAL','UPDATE_CHECKER',0),
	(208,'portfolio','DELETE_COLLATERAL_CHECKER','COLLATERAL','DELETE_CHECKER',0),
	(209,'transaction_loan','APPROVE_LOAN','LOAN','APPROVE',0),
	(211,'transaction_loan','REJECT_LOAN','LOAN','REJECT',0),
	(213,'transaction_loan','WITHDRAW_LOAN','LOAN','WITHDRAW',0),
	(215,'transaction_loan','APPROVALUNDO_LOAN','LOAN','APPROVALUNDO',0),
	(216,'transaction_loan','DISBURSE_LOAN','LOAN','DISBURSE',0),
	(218,'transaction_loan','DISBURSALUNDO_LOAN','LOAN','DISBURSALUNDO',0),
	(219,'transaction_loan','REPAYMENT_LOAN','LOAN','REPAYMENT',0),
	(221,'transaction_loan','ADJUST_LOAN','LOAN','ADJUST',0),
	(222,'transaction_loan','WAIVEINTERESTPORTION_LOAN','LOAN','WAIVEINTERESTPORTION',0),
	(223,'transaction_loan','WRITEOFF_LOAN','LOAN','WRITEOFF',0),
	(224,'transaction_loan','CLOSE_LOAN','LOAN','CLOSE',0),
	(225,'transaction_loan','CLOSEASRESCHEDULED_LOAN','LOAN','CLOSEASRESCHEDULED',0),
	(226,'transaction_loan','UPDATELOANOFFICER_LOAN','LOAN','UPDATELOANOFFICER',0),
	(227,'transaction_loan','UPDATELOANOFFICER_LOAN_CHECKER','LOAN','UPDATELOANOFFICER_CHECKER',0),
	(228,'transaction_loan','REMOVELOANOFFICER_LOAN','LOAN','REMOVELOANOFFICER',0),
	(229,'transaction_loan','REMOVELOANOFFICER_LOAN_CHECKER','LOAN','REMOVELOANOFFICER_CHECKER',0),
	(230,'transaction_loan','BULKREASSIGN_LOAN','LOAN','BULKREASSIGN',0),
	(231,'transaction_loan','BULKREASSIGN_LOAN_CHECKER','LOAN','BULKREASSIGN_CHECKER',0),
	(232,'transaction_loan','APPROVE_LOAN_CHECKER','LOAN','APPROVE_CHECKER',0),
	(234,'transaction_loan','REJECT_LOAN_CHECKER','LOAN','REJECT_CHECKER',0),
	(236,'transaction_loan','WITHDRAW_LOAN_CHECKER','LOAN','WITHDRAW_CHECKER',0),
	(238,'transaction_loan','APPROVALUNDO_LOAN_CHECKER','LOAN','APPROVALUNDO_CHECKER',0),
	(239,'transaction_loan','DISBURSE_LOAN_CHECKER','LOAN','DISBURSE_CHECKER',0),
	(241,'transaction_loan','DISBURSALUNDO_LOAN_CHECKER','LOAN','DISBURSALUNDO_CHECKER',0),
	(242,'transaction_loan','REPAYMENT_LOAN_CHECKER','LOAN','REPAYMENT_CHECKER',0),
	(244,'transaction_loan','ADJUST_LOAN_CHECKER','LOAN','ADJUST_CHECKER',0),
	(245,'transaction_loan','WAIVEINTERESTPORTION_LOAN_CHECKER','LOAN','WAIVEINTERESTPORTION_CHECKER',0),
	(246,'transaction_loan','WRITEOFF_LOAN_CHECKER','LOAN','WRITEOFF_CHECKER',0),
	(247,'transaction_loan','CLOSE_LOAN_CHECKER','LOAN','CLOSE_CHECKER',0),
	(248,'transaction_loan','CLOSEASRESCHEDULED_LOAN_CHECKER','LOAN','CLOSEASRESCHEDULED_CHECKER',0),
	(249,'transaction_savings','DEPOSIT_SAVINGSACCOUNT','SAVINGSACCOUNT','DEPOSIT',0),
	(250,'transaction_savings','DEPOSIT_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','DEPOSIT_CHECKER',0),
	(251,'transaction_savings','WITHDRAWAL_SAVINGSACCOUNT','SAVINGSACCOUNT','WITHDRAWAL',0),
	(252,'transaction_savings','WITHDRAWAL_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','WITHDRAWAL_CHECKER',0),
	(253,'transaction_savings','ACTIVATE_SAVINGSACCOUNT','SAVINGSACCOUNT','ACTIVATE',0),
	(254,'transaction_savings','ACTIVATE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','ACTIVATE_CHECKER',0),
	(255,'transaction_savings','CALCULATEINTEREST_SAVINGSACCOUNT','SAVINGSACCOUNT','CALCULATEINTEREST',0),
	(256,'transaction_savings','CALCULATEINTEREST_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','CALCULATEINTEREST_CHECKER',0),
	(257,'accounting','CREATE_GLACCOUNT','GLACCOUNT','CREATE',0),
	(258,'accounting','UPDATE_GLACCOUNT','GLACCOUNT','UPDATE',0),
	(259,'accounting','DELETE_GLACCOUNT','GLACCOUNT','DELETE',0),
	(260,'accounting','CREATE_GLCLOSURE','GLCLOSURE','CREATE',0),
	(261,'accounting','UPDATE_GLCLOSURE','GLCLOSURE','UPDATE',0),
	(262,'accounting','DELETE_GLCLOSURE','GLCLOSURE','DELETE',0),
	(263,'accounting','CREATE_JOURNALENTRY','JOURNALENTRY','CREATE',0),
	(264,'accounting','REVERSE_JOURNALENTRY','JOURNALENTRY','REVERSE',0),
	(265,'report','READ_Active Loans - Details','Active Loans - Details','READ',0),
	(266,'report','READ_Active Loans - Summary','Active Loans - Summary','READ',0),
	(267,'report','READ_Active Loans by Disbursal Period','Active Loans by Disbursal Period','READ',0),
	(268,'report','READ_Active Loans in last installment','Active Loans in last installment','READ',0),
	(269,'report','READ_Active Loans in last installment Summary','Active Loans in last installment Summary','READ',0),
	(270,'report','READ_Active Loans Passed Final Maturity','Active Loans Passed Final Maturity','READ',0),
	(271,'report','READ_Active Loans Passed Final Maturity Summary','Active Loans Passed Final Maturity Summary','READ',0),
	(272,'report','READ_Aging Detail','Aging Detail','READ',0),
	(273,'report','READ_Aging Summary (Arrears in Months)','Aging Summary (Arrears in Months)','READ',0),
	(274,'report','READ_Aging Summary (Arrears in Weeks)','Aging Summary (Arrears in Weeks)','READ',0),
	(275,'report','READ_Balance Sheet','Balance Sheet','READ',0),
	(276,'report','READ_Branch Expected Cash Flow','Branch Expected Cash Flow','READ',0),
	(277,'report','READ_Client Listing','Client Listing','READ',0),
	(278,'report','READ_Client Loans Listing','Client Loans Listing','READ',0),
	(279,'report','READ_Expected Payments By Date - Basic','Expected Payments By Date - Basic','READ',0),
	(280,'report','READ_Expected Payments By Date - Formatted','Expected Payments By Date - Formatted','READ',0),
	(281,'report','READ_Funds Disbursed Between Dates Summary','Funds Disbursed Between Dates Summary','READ',0),
	(282,'report','READ_Funds Disbursed Between Dates Summary by Office','Funds Disbursed Between Dates Summary by Office','READ',0),
	(283,'report','READ_Income Statement','Income Statement','READ',0),
	(284,'report','READ_Loan Account Schedule','Loan Account Schedule','READ',0),
	(285,'report','READ_Loans Awaiting Disbursal','Loans Awaiting Disbursal','READ',0),
	(286,'report','READ_Loans Awaiting Disbursal Summary','Loans Awaiting Disbursal Summary','READ',0),
	(287,'report','READ_Loans Awaiting Disbursal Summary by Month','Loans Awaiting Disbursal Summary by Month','READ',0),
	(288,'report','READ_Loans Pending Approval','Loans Pending Approval','READ',0),
	(289,'report','READ_Obligation Met Loans Details','Obligation Met Loans Details','READ',0),
	(290,'report','READ_Obligation Met Loans Summary','Obligation Met Loans Summary','READ',0),
	(291,'report','READ_Portfolio at Risk','Portfolio at Risk','READ',0),
	(292,'report','READ_Portfolio at Risk by Branch','Portfolio at Risk by Branch','READ',0),
	(293,'report','READ_Rescheduled Loans','Rescheduled Loans','READ',0),
	(294,'report','READ_Trial Balance','Trial Balance','READ',0),
	(295,'report','READ_Written-Off Loans','Written-Off Loans','READ',0),
	(296,'transaction_savings','POSTINTEREST_SAVINGSACCOUNT','SAVINGSACCOUNT','POSTINTEREST',1),
	(297,'transaction_savings','POSTINTEREST_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','POSTINTEREST_CHECKER',0),
	(298,'portfolio_center','READ_CENTER','CENTER','READ',0),
	(299,'portfolio_center','CREATE_CENTER','CENTER','CREATE',0),
	(300,'portfolio_center','CREATE_CENTER_CHECKER','CENTER','CREATE_CHECKER',0),
	(301,'portfolio_center','UPDATE_CENTER','CENTER','UPDATE',0),
	(302,'portfolio_center','UPDATE_CENTER_CHECKER','CENTER','UPDATE_CHECKER',0),
	(303,'portfolio_center','DELETE_CENTER','CENTER','DELETE',0),
	(304,'portfolio_center','DELETE_CENTER_CHECKER','CENTER','DELETE_CHECKER',0),
	(305,'configuration','READ_REPORT','REPORT','READ',0),
	(306,'configuration','CREATE_REPORT','REPORT','CREATE',0),
	(307,'configuration','CREATE_REPORT_CHECKER','REPORT','CREATE_CHECKER',0),
	(308,'configuration','UPDATE_REPORT','REPORT','UPDATE',0),
	(309,'configuration','UPDATE_REPORT_CHECKER','REPORT','UPDATE_CHECKER',0),
	(310,'configuration','DELETE_REPORT','REPORT','DELETE',0),
	(311,'configuration','DELETE_REPORT_CHECKER','REPORT','DELETE_CHECKER',0),
	(312,'portfolio','ACTIVATE_CLIENT','CLIENT','ACTIVATE',1),
	(313,'portfolio','ACTIVATE_CLIENT_CHECKER','CLIENT','ACTIVATE_CHECKER',0),
	(314,'portfolio_center','ACTIVATE_CENTER','CENTER','ACTIVATE',1),
	(315,'portfolio_center','ACTIVATE_CENTER_CHECKER','CENTER','ACTIVATE_CHECKER',0),
	(316,'portfolio_group','ACTIVATE_GROUP','GROUP','ACTIVATE',1),
	(317,'portfolio_group','ACTIVATE_GROUP_CHECKER','GROUP','ACTIVATE_CHECKER',0),
	(318,'portfolio_group','ASSOCIATECLIENTS_GROUP','GROUP','ASSOCIATECLIENTS',0),
	(319,'portfolio_group','DISASSOCIATECLIENTS_GROUP','GROUP','DISASSOCIATECLIENTS',0),
	(320,'portfolio_group','SAVECOLLECTIONSHEET_GROUP','GROUP','SAVECOLLECTIONSHEET',0),
	(321,'portfolio_center','SAVECOLLECTIONSHEET_CENTER','CENTER','SAVECOLLECTIONSHEET',0),
	(323,'accounting','DELETE_ACCOUNTINGRULE','ACCOUNTINGRULE','DELETE',0),
	(324,'accounting','CREATE_ACCOUNTINGRULE','ACCOUNTINGRULE','CREATE',0),
	(325,'accounting','UPDATE_ACCOUNTINGRULE','ACCOUNTINGRULE','UPDATE',0),
	(326,'report','READ_GroupSummaryCounts','GroupSummaryCounts','READ',0),
	(327,'report','READ_GroupSummaryAmounts','GroupSummaryAmounts','READ',0),
	(328,'configuration','CREATE_DATATABLE','DATATABLE','CREATE',0),
	(329,'configuration','CREATE_DATATABLE_CHECKER','DATATABLE','CREATE_CHECKER',0),
	(330,'configuration','UPDATE_DATATABLE','DATATABLE','UPDATE',0),
	(331,'configuration','UPDATE_DATATABLE_CHECKER','DATATABLE','UPDATE_CHECKER',0),
	(332,'configuration','DELETE_DATATABLE','DATATABLE','DELETE',0),
	(333,'configuration','DELETE_DATATABLE_CHECKER','DATATABLE','DELETE_CHECKER',0),
	(334,'organisation','CREATE_HOLIDAY','HOLIDAY','CREATE',0),
	(335,'portfolio_group','ASSIGNROLE_GROUP','GROUP','ASSIGNROLE',0),
	(336,'portfolio_group','UNASSIGNROLE_GROUP','GROUP','UNASSIGNROLE',0),
	(337,'portfolio_group','UPDATEROLE_GROUP','GROUP','UPDATEROLE',0),
	(346,'report','READ_TxnRunningBalances','TxnRunningBalances','READ',0),
	(347,'portfolio','UNASSIGNSTAFF_CLIENT','CLIENT','UNASSIGNSTAFF',0),
	(348,'portfolio','ASSIGNSTAFF_CLIENT','CLIENT','ASSIGNSTAFF',0),
	(349,'portfolio','CLOSE_CLIENT','CLIENT','CLOSE',1),
	(350,'report','READ_FieldAgentStats','FieldAgentStats','READ',0),
	(351,'report','READ_FieldAgentPrograms','FieldAgentPrograms','READ',0),
	(352,'report','READ_ProgramDetails','ProgramDetails','READ',0),
	(353,'report','READ_ChildrenStaffList','ChildrenStaffList','READ',0),
	(354,'report','READ_CoordinatorStats','CoordinatorStats','READ',0),
	(355,'report','READ_BranchManagerStats','BranchManagerStats','READ',0),
	(356,'report','READ_ProgramDirectorStats','ProgramDirectorStats','READ',0),
	(357,'report','READ_ProgramStats','ProgramStats','READ',0),
	(358,'transaction_savings','APPROVE_SAVINGSACCOUNT','SAVINGSACCOUNT','APPROVE',1),
	(359,'transaction_savings','REJECT_SAVINGSACCOUNT','SAVINGSACCOUNT','REJECT',1),
	(360,'transaction_savings','WITHDRAW_SAVINGSACCOUNT','SAVINGSACCOUNT','WITHDRAW',1),
	(361,'transaction_savings','APPROVALUNDO_SAVINGSACCOUNT','SAVINGSACCOUNT','APPROVALUNDO',1),
	(362,'transaction_savings','CLOSE_SAVINGSACCOUNT','SAVINGSACCOUNT','CLOSE',1),
	(363,'transaction_savings','APPROVE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','APPROVE_CHECKER',0),
	(364,'transaction_savings','REJECT_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','REJECT_CHECKER',0),
	(365,'transaction_savings','WITHDRAW_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','WITHDRAW_CHECKER',0),
	(366,'transaction_savings','APPROVALUNDO_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','APPROVALUNDO_CHECKER',0),
	(367,'transaction_savings','CLOSE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','CLOSE_CHECKER',0),
	(368,'transaction_savings','UNDOTRANSACTION_SAVINGSACCOUNT','SAVINGSACCOUNT','UNDOTRANSACTION',1),
	(369,'transaction_savings','UNDOTRANSACTION_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','UNDOTRANSACTION_CHECKER',0),
	(370,'portfolio','CREATE_PRODUCTMIX','PRODUCTMIX','CREATE',0),
	(371,'portfolio','UPDATE_PRODUCTMIX','PRODUCTMIX','UPDATE',0),
	(372,'portfolio','DELETE_PRODUCTMIX','PRODUCTMIX','DELETE',0),
	(373,'jobs','UPDATE_SCHEDULER','SCHEDULER','UPDATE',0),
	(374,'transaction_savings','APPLYANNUALFEE_SAVINGSACCOUNT','SAVINGSACCOUNT','APPLYANNUALFEE',1),
	(375,'transaction_savings','APPLYANNUALFEE_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','APPLYANNUALFEE_CHECKER',0),
	(376,'portfolio_group','ASSIGNSTAFF_GROUP','GROUP','ASSIGNSTAFF',0),
	(377,'transaction_savings','READ_ACCOUNTTRANSFER','ACCOUNTTRANSFER','READ',0),
	(378,'transaction_savings','CREATE_ACCOUNTTRANSFER','ACCOUNTTRANSFER','CREATE',1),
	(379,'transaction_savings','CREATE_ACCOUNTTRANSFER_CHECKER','ACCOUNTTRANSFER','CREATE_CHECKER',0),
	(380,'transaction_savings','ADJUSTTRANSACTION_SAVINGSACCOUNT','SAVINGSACCOUNT','ADJUSTTRANSACTION',0),
	(381,'portfolio','CREATE_MEETING','MEETING','CREATE',0),
	(382,'portfolio','UPDATE_MEETING','MEETING','UPDATE',0),
	(383,'portfolio','DELETE_MEETING','MEETING','DELETE',0),
	(384,'portfolio','SAVEORUPDATEATTENDANCE_MEETING','MEETING','SAVEORUPDATEATTENDANCE',0),
	(385,'portfolio_group','TRANSFERCLIENTS_GROUP','GROUP','TRANSFERCLIENTS',0),
	(386,'portfolio_group','TRANSFERCLIENTS_GROUP_CHECKER','GROUP','TRANSFERCLIENTS_CHECKER',0),
	(389,'portfolio','PROPOSETRANSFER_CLIENT','CLIENT','PROPOSETRANSFER',0),
	(390,'portfolio','PROPOSETRANSFER_CLIENT_CHECKER','CLIENT','PROPOSETRANSFER_CHECKER',0),
	(391,'portfolio','ACCEPTTRANSFER_CLIENT','CLIENT','ACCEPTTRANSFER',0),
	(392,'portfolio','ACCEPTTRANSFER_CLIENT_CHECKER','CLIENT','ACCEPTTRANSFER_CHECKER',0),
	(393,'portfolio','REJECTTRANSFER_CLIENT','CLIENT','REJECTTRANSFER',0),
	(394,'portfolio','REJECTTRANSFER_CLIENT_CHECKER','CLIENT','REJECTTRANSFER_CHECKER',0),
	(395,'portfolio','WITHDRAWTRANSFER_CLIENT','CLIENT','WITHDRAWTRANSFER',0),
	(396,'portfolio','WITHDRAWTRANSFER_CLIENT_CHECKER','CLIENT','WITHDRAWTRANSFER_CHECKER',0),
	(397,'portfolio','CLOSE_GROUP','GROUP','CLOSE',1),
	(398,'portfolio','CLOSE_CENTER','CENTER','CLOSE',1),
	(399,'xbrlmapping','UPDATE_XBRLMAPPING','XBRLMAPPING','UPDATE',0),
	(400,'configuration','READ_CACHE','CACHE','READ',0),
	(401,'configuration','UPDATE_CACHE','CACHE','UPDATE',0),
	(402,'transaction_loan','PAY_LOANCHARGE','LOANCHARGE','PAY',0),
	(403,'portfolio','CREATE_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','CREATE',0),
	(404,'portfolio','CREATE_SAVINGSACCOUNTCHARGE_CHECKER','SAVINGSACCOUNTCHARGE','CREATE_CHECKER',0),
	(405,'portfolio','UPDATE_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','UPDATE',0),
	(406,'portfolio','UPDATE_SAVINGSACCOUNTCHARGE_CHECKER','SAVINGSACCOUNTCHARGE','UPDATE_CHECKER',0),
	(407,'portfolio','DELETE_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','DELETE',0),
	(408,'portfolio','DELETE_SAVINGSACCOUNTCHARGE_CHECKER','SAVINGSACCOUNTCHARGE','DELETE_CHECKER',0),
	(409,'portfolio','WAIVE_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','WAIVE',0),
	(410,'portfolio','WAIVE_SAVINGSACCOUNTCHARGE_CHECKER','SAVINGSACCOUNTCHARGE','WAIVE_CHECKER',0),
	(411,'portfolio','PAY_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','PAY',0),
	(412,'portfolio','PAY_SAVINGSACCOUNTCHARGE_CHECKER','SAVINGSACCOUNTCHARGE','PAY_CHECKER',0),
	(413,'portfolio','PROPOSEANDACCEPTTRANSFER_CLIENT','CLIENT','PROPOSEANDACCEPTTRANSFER',0),
	(414,'portfolio','PROPOSEANDACCEPTTRANSFER_CLIENT_CHECKER','CLIENT','PROPOSEANDACCEPTTRANSFER_CHECKER',0),
	(415,'organisation','DELETE_TEMPLATE','TEMPLATE','DELETE',0),
	(416,'organisation','CREATE_TEMPLATE','TEMPLATE','CREATE',0),
	(417,'organisation','UPDATE_TEMPLATE','TEMPLATE','UPDATE',0),
	(418,'organisation','READ_TEMPLATE','TEMPLATE','READ',0),
	(419,'accounting','UPDATERUNNINGBALANCE_JOURNALENTRY','JOURNALENTRY','UPDATERUNNINGBALANCE',0),
	(420,'organisation','READ_SMS','SMS','READ',0),
	(421,'organisation','CREATE_SMS','SMS','CREATE',0),
	(422,'organisation','CREATE_SMS_CHECKER','SMS','CREATE_CHECKER',0),
	(423,'organisation','UPDATE_SMS','SMS','UPDATE',0),
	(424,'organisation','UPDATE_SMS_CHECKER','SMS','UPDATE_CHECKER',0),
	(425,'organisation','DELETE_SMS','SMS','DELETE',0),
	(426,'organisation','DELETE_SMS_CHECKER','SMS','DELETE_CHECKER',0),
	(427,'organisation','CREATE_HOLIDAY_CHECKER','HOLIDAY','CREATE_CHECKER',0),
	(428,'organisation','ACTIVATE_HOLIDAY','HOLIDAY','ACTIVATE',0),
	(429,'organisation','ACTIVATE_HOLIDAY_CHECKER','HOLIDAY','ACTIVATE_CHECKER',0),
	(430,'organisation','UPDATE_HOLIDAY','HOLIDAY','UPDATE',0),
	(431,'organisation','UPDATE_HOLIDAY_CHECKER','HOLIDAY','UPDATE_CHECKER',0),
	(432,'organisation','DELETE_HOLIDAY','HOLIDAY','DELETE',0),
	(433,'organisation','DELETE_HOLIDAY_CHECKER','HOLIDAY','DELETE_CHECKER',0),
	(434,'transaction_loan','UNDOWRITEOFF_LOAN','LOAN','UNDOWRITEOFF',0),
	(435,'portfolio','READ_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','READ',0),
	(436,'accounting','CREATE_JOURNALENTRY_CHECKER','JOURNALENTRY','CREATE_CHECKER',0),
	(437,'portfolio','UPDATE_DISBURSEMENTDETAIL','DISBURSEMENTDETAIL','UPDATE',0),
	(438,'portfolio','UPDATESAVINGSACCOUNT_CLIENT','CLIENT','UPDATESAVINGSACCOUNT',0),
	(439,'accounting','READ_ACCOUNTINGRULE','ACCOUNTINGRULE','READ',0),
	(440,'accounting','READ_JOURNALENTRY','JOURNALENTRY','READ',0),
	(441,'accounting','READ_GLACCOUNT','GLACCOUNT','READ',0),
	(442,'accounting','READ_GLCLOSURE','GLCLOSURE','READ',0),
	(443,'organisation','READ_HOLIDAY','HOLIDAY','READ',0),
	(444,'jobs','READ_SCHEDULER','SCHEDULER','READ',0),
	(445,'portfolio','READ_PRODUCTMIX','PRODUCTMIX','READ',0),
	(446,'portfolio','READ_MEETING','MEETING','READ',0),
	(447,'jobs','EXECUTEJOB_SCHEDULER','SCHEDULER','EXECUTEJOB',0),
	(448,'account_transfer','READ_STANDINGINSTRUCTION ','STANDINGINSTRUCTION ','READ',0),
	(449,'account_transfer','CREATE_STANDINGINSTRUCTION ','STANDINGINSTRUCTION ','CREATE',0),
	(450,'account_transfer','UPDATE_STANDINGINSTRUCTION ','STANDINGINSTRUCTION ','UPDATE',0),
	(451,'account_transfer','DELETE_STANDINGINSTRUCTION ','STANDINGINSTRUCTION ','DELETE',0),
	(452,'portfolio','CREATE_INTERESTRATECHART','INTERESTRATECHART','CREATE',0),
	(453,'portfolio','CREATE_INTERESTRATECHART_CHECKER','INTERESTRATECHART','CREATE_CHECKER',0),
	(454,'portfolio','UPDATE_INTERESTRATECHART','INTERESTRATECHART','UPDATE',0),
	(455,'portfolio','DELETE_INTERESTRATECHART','INTERESTRATECHART','DELETE',0),
	(456,'portfolio','UPDATE_INTERESTRATECHART_CHECKER','INTERESTRATECHART','UPDATE_CHECKER',0),
	(457,'portfolio','DELETE_INTERESTRATECHART_CHECKER','INTERESTRATECHART','DELETE_CHECKER',0),
	(458,'portfolio','CREATE_CHARTSLAB','CHARTSLAB','CREATE',0),
	(459,'portfolio','CREATE_CHARTSLAB_CHECKER','CHARTSLAB','CREATE_CHECKER',0),
	(460,'portfolio','UPDATE_CHARTSLAB','CHARTSLAB','UPDATE',0),
	(461,'portfolio','DELETE_CHARTSLAB','CHARTSLAB','DELETE',0),
	(462,'portfolio','UPDATE_CHARTSLAB_CHECKER','CHARTSLAB','UPDATE_CHECKER',0),
	(463,'portfolio','DELETE_CHARTSLAB_CHECKER','CHARTSLAB','DELETE_CHECKER',0),
	(464,'portfolio','CREATE_FIXEDDEPOSITPRODUCT','FIXEDDEPOSITPRODUCT','CREATE',0),
	(465,'portfolio','CREATE_FIXEDDEPOSITPRODUCT_CHECKER','FIXEDDEPOSITPRODUCT','CREATE_CHECKER',0),
	(466,'portfolio','UPDATE_FIXEDDEPOSITPRODUCT','FIXEDDEPOSITPRODUCT','UPDATE',0),
	(467,'portfolio','DELETE_FIXEDDEPOSITPRODUCT','FIXEDDEPOSITPRODUCT','DELETE',0),
	(468,'portfolio','UPDATE_FIXEDDEPOSITPRODUCT_CHECKER','FIXEDDEPOSITPRODUCT','UPDATE_CHECKER',0),
	(469,'portfolio','DELETE_FIXEDDEPOSITPRODUCT_CHECKER','FIXEDDEPOSITPRODUCT','DELETE_CHECKER',0),
	(470,'portfolio','CREATE_RECURRINGDEPOSITPRODUCT','RECURRINGDEPOSITPRODUCT','CREATE',0),
	(471,'portfolio','CREATE_RECURRINGDEPOSITPRODUCT_CHECKER','RECURRINGDEPOSITPRODUCT','CREATE_CHECKER',0),
	(472,'portfolio','UPDATE_RECURRINGDEPOSITPRODUCT','RECURRINGDEPOSITPRODUCT','UPDATE',0),
	(473,'portfolio','DELETE_RECURRINGDEPOSITPRODUCT','RECURRINGDEPOSITPRODUCT','DELETE',0),
	(474,'portfolio','UPDATE_RECURRINGDEPOSITPRODUCT_CHECKER','RECURRINGDEPOSITPRODUCT','UPDATE_CHECKER',0),
	(475,'portfolio','DELETE_RECURRINGDEPOSITPRODUCT_CHECKER','RECURRINGDEPOSITPRODUCT','DELETE_CHECKER',0),
	(476,'portfolio','READ_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','READ',0),
	(477,'portfolio','CREATE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','CREATE',0),
	(478,'portfolio','CREATE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','CREATE_CHECKER',0),
	(479,'portfolio','UPDATE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','UPDATE',0),
	(480,'portfolio','UPDATE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','UPDATE_CHECKER',0),
	(481,'portfolio','DELETE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','DELETE',0),
	(482,'portfolio','DELETE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','DELETE_CHECKER',0),
	(483,'transaction_savings','DEPOSIT_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','DEPOSIT',0),
	(484,'transaction_savings','DEPOSIT_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','DEPOSIT_CHECKER',0),
	(485,'transaction_savings','WITHDRAWAL_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','WITHDRAWAL',0),
	(486,'transaction_savings','WITHDRAWAL_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','WITHDRAWAL_CHECKER',0),
	(487,'transaction_savings','ACTIVATE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','ACTIVATE',0),
	(488,'transaction_savings','ACTIVATE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','ACTIVATE_CHECKER',0),
	(489,'transaction_savings','CALCULATEINTEREST_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','CALCULATEINTEREST',0),
	(490,'transaction_savings','CALCULATEINTEREST_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','CALCULATEINTEREST_CHECKER',0),
	(491,'transaction_savings','POSTINTEREST_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','POSTINTEREST',1),
	(492,'transaction_savings','POSTINTEREST_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','POSTINTEREST_CHECKER',0),
	(493,'transaction_savings','APPROVE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','APPROVE',1),
	(494,'transaction_savings','REJECT_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','REJECT',1),
	(495,'transaction_savings','WITHDRAW_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','WITHDRAW',1),
	(496,'transaction_savings','APPROVALUNDO_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','APPROVALUNDO',1),
	(497,'transaction_savings','CLOSE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','CLOSE',1),
	(498,'transaction_savings','APPROVE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','APPROVE_CHECKER',0),
	(499,'transaction_savings','REJECT_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','REJECT_CHECKER',0),
	(500,'transaction_savings','WITHDRAW_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','WITHDRAW_CHECKER',0),
	(501,'transaction_savings','APPROVALUNDO_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','APPROVALUNDO_CHECKER',0),
	(502,'transaction_savings','CLOSE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','CLOSE_CHECKER',0),
	(503,'transaction_savings','UNDOTRANSACTION_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','UNDOTRANSACTION',1),
	(504,'transaction_savings','UNDOTRANSACTION_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','UNDOTRANSACTION_CHECKER',0),
	(505,'transaction_savings','ADJUSTTRANSACTION_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','ADJUSTTRANSACTION',0),
	(506,'portfolio','READ_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','READ',0),
	(507,'portfolio','CREATE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','CREATE',0),
	(508,'portfolio','CREATE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','CREATE_CHECKER',0),
	(509,'portfolio','UPDATE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','UPDATE',0),
	(510,'portfolio','UPDATE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','UPDATE_CHECKER',0),
	(511,'portfolio','DELETE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','DELETE',0),
	(512,'portfolio','DELETE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','DELETE_CHECKER',0),
	(513,'transaction_savings','DEPOSIT_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','DEPOSIT',0),
	(514,'transaction_savings','DEPOSIT_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','DEPOSIT_CHECKER',0),
	(515,'transaction_savings','WITHDRAWAL_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','WITHDRAWAL',0),
	(516,'transaction_savings','WITHDRAWAL_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','WITHDRAWAL_CHECKER',0),
	(517,'transaction_savings','ACTIVATE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','ACTIVATE',0),
	(518,'transaction_savings','ACTIVATE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','ACTIVATE_CHECKER',0),
	(519,'transaction_savings','CALCULATEINTEREST_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','CALCULATEINTEREST',0),
	(520,'transaction_savings','CALCULATEINTEREST_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','CALCULATEINTEREST_CHECKER',0),
	(521,'transaction_savings','POSTINTEREST_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','POSTINTEREST',1),
	(522,'transaction_savings','POSTINTEREST_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','POSTINTEREST_CHECKER',0),
	(523,'transaction_savings','APPROVE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','APPROVE',1),
	(524,'transaction_savings','REJECT_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','REJECT',1),
	(525,'transaction_savings','WITHDRAW_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','WITHDRAW',1),
	(526,'transaction_savings','APPROVALUNDO_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','APPROVALUNDO',1),
	(527,'transaction_savings','CLOSE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','CLOSE',1),
	(528,'transaction_savings','APPROVE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','APPROVE_CHECKER',0),
	(529,'transaction_savings','REJECT_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','REJECT_CHECKER',0),
	(530,'transaction_savings','WITHDRAW_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','WITHDRAW_CHECKER',0),
	(531,'transaction_savings','APPROVALUNDO_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','APPROVALUNDO_CHECKER',0),
	(532,'transaction_savings','CLOSE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','CLOSE_CHECKER',0),
	(533,'transaction_savings','UNDOTRANSACTION_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','UNDOTRANSACTION',1),
	(534,'transaction_savings','UNDOTRANSACTION_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','UNDOTRANSACTION_CHECKER',0),
	(535,'transaction_savings','ADJUSTTRANSACTION_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','ADJUSTTRANSACTION',0),
	(536,'transaction_savings','PREMATURECLOSE_FIXEDDEPOSITACCOUNT_CHECKER','FIXEDDEPOSITACCOUNT','PREMATURECLOSE_CHECKER',0),
	(537,'transaction_savings','PREMATURECLOSE_FIXEDDEPOSITACCOUNT','FIXEDDEPOSITACCOUNT','PREMATURECLOSE',1),
	(538,'transaction_savings','PREMATURECLOSE_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','PREMATURECLOSE_CHECKER',0),
	(539,'transaction_savings','PREMATURECLOSE_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','PREMATURECLOSE',1),
	(540,'transaction_loan','DISBURSETOSAVINGS_LOAN','LOAN','DISBURSETOSAVINGS',0),
	(541,'transaction_loan','RECOVERYPAYMENT_LOAN','LOAN','RECOVERYPAYMENT',0),
	(542,'organisation','READ_RECURRINGDEPOSITPRODUCT','RECURRINGDEPOSITPRODUCT','READ',0),
	(543,'organisation','READ_FIXEDDEPOSITPRODUCT','FIXEDDEPOSITPRODUCT','READ',0),
	(544,'accounting','READ_FINANCIALACTIVITYACCOUNT','FINANCIALACTIVITYACCOUNT','READ',0),
	(545,'accounting','CREATE_FINANCIALACTIVITYACCOUNT','FINANCIALACTIVITYACCOUNT','CREATE',0),
	(546,'accounting','DELETE_FINANCIALACTIVITYACCOUNT','FINANCIALACTIVITYACCOUNT','DELETE',0),
	(547,'accounting','UPDATE_FINANCIALACTIVITYACCOUNT','FINANCIALACTIVITYACCOUNT','UPDATE',0),
	(548,'datatable','UPDATE_LIKELIHOOD','likelihood','UPDATE',0),
	(549,'survey','REGISTER_SURVEY','survey','CREATE',0),
	(550,'accounting','EXECUTE_PERIODICACCRUALACCOUNTING','PERIODICACCRUALACCOUNTING','EXECUTE',0),
	(551,'portfolio','INACTIVATE_SAVINGSACCOUNTCHARGE','SAVINGSACCOUNTCHARGE','INACTIVATE',0),
	(552,'portfolio','INACTIVATE_SAVINGSACCOUNTCHARGE_CHECKER','SAVINGSACCOUNTCHARGE','INACTIVATE_CHECKER',0),
	(553,'portfolio_center','DISASSOCIATEGROUPS_CENTER','CENTER','DISASSOCIATEGROUPS',0),
	(554,'portfolio_center','ASSOCIATEGROUPS_CENTER','CENTER','ASSOCIATEGROUPS',0),
	(555,'portfolio_center','DISASSOCIATEGROUPS_CENTER_CHECKER','CENTER','DISASSOCIATEGROUPS_CHECKER',0),
	(556,'portfolio_center','ASSOCIATEGROUPS_CENTER_CHECKER','CENTER','ASSOCIATEGROUPS_CHECKER',0),
	(557,'loan_reschedule','READ_RESCHEDULELOAN','RESCHEDULELOAN','READ',0),
	(558,'loan_reschedule','CREATE_RESCHEDULELOAN','RESCHEDULELOAN','CREATE',0),
	(559,'loan_reschedule','REJECT_RESCHEDULELOAN','RESCHEDULELOAN','REJECT',0),
	(560,'loan_reschedule','APPROVE_RESCHEDULELOAN','RESCHEDULELOAN','APPROVE',0),
	(561,'configuration','CREATE_HOOK','HOOK','CREATE',0),
	(562,'configuration','READ_HOOK','HOOK','READ',0),
	(563,'configuration','UPDATE_HOOK','HOOK','UPDATE',0),
	(564,'configuration','DELETE_HOOK','HOOK','DELETE',0),
	(565,'portfolio','REMOVESAVINGSOFFICER_SAVINGSACCOUNT','SAVINGSACCOUNT','REMOVESAVINGSOFFICER',1),
	(566,'portfolio','UPDATESAVINGSOFFICER_SAVINGSACCOUNT','SAVINGSACCOUNT','UPDATESAVINGSOFFICER',1),
	(567,'report','READ_Active Loans - Summary(Pentaho)','Active Loans - Summary(Pentaho)','READ',0),
	(568,'report','READ_Active Loans by Disbursal Period(Pentaho)','Active Loans by Disbursal Period(Pentaho)','READ',0),
	(569,'report','READ_Active Loans in last installment Summary(Pentaho)','Active Loans in last installment Summary(Pentaho)','READ',0),
	(570,'report','READ_Active Loans in last installment(Pentaho)','Active Loans in last installment(Pentaho)','READ',0),
	(571,'report','READ_Active Loans Passed Final Maturity Summary(Pentaho)','Active Loans Passed Final Maturity Summary(Pentaho)','READ',0),
	(572,'report','READ_Active Loans Passed Final Maturity(Pentaho)','Active Loans Passed Final Maturity(Pentaho)','READ',0),
	(573,'report','READ_Aging Detail(Pentaho)','Aging Detail(Pentaho)','READ',0),
	(574,'report','READ_Aging Summary (Arrears in Months)(Pentaho)','Aging Summary (Arrears in Months)(Pentaho)','READ',0),
	(575,'report','READ_Aging Summary (Arrears in Weeks)(Pentaho)','Aging Summary (Arrears in Weeks)(Pentaho)','READ',0),
	(576,'report','READ_Client Listing(Pentaho)','Client Listing(Pentaho)','READ',0),
	(577,'report','READ_Client Loan Account Schedule','Client Loan Account Schedule','READ',0),
	(578,'report','READ_Client Loans Listing(Pentaho)','Client Loans Listing(Pentaho)','READ',0),
	(579,'report','READ_Client Saving Transactions','Client Saving Transactions','READ',0),
	(580,'report','READ_Client Savings Summary','Client Savings Summary','READ',0),
	(581,'report','READ_ClientSummary ','ClientSummary ','READ',0),
	(582,'report','READ_ClientTrendsByDay','ClientTrendsByDay','READ',0),
	(583,'report','READ_ClientTrendsByMonth','ClientTrendsByMonth','READ',0),
	(584,'report','READ_ClientTrendsByWeek','ClientTrendsByWeek','READ',0),
	(585,'report','READ_Demand_Vs_Collection','Demand_Vs_Collection','READ',0),
	(586,'report','READ_Disbursal_Vs_Awaitingdisbursal','Disbursal_Vs_Awaitingdisbursal','READ',0),
	(587,'report','READ_Expected Payments By Date - Basic(Pentaho)','Expected Payments By Date - Basic(Pentaho)','READ',0),
	(588,'report','READ_Funds Disbursed Between Dates Summary by Office(Pentaho)','Funds Disbursed Between Dates Summary by Office(Pentaho)','READ',0),
	(589,'report','READ_Funds Disbursed Between Dates Summary(Pentaho)','Funds Disbursed Between Dates Summary(Pentaho)','READ',0),
	(590,'report','READ_GroupNamesByStaff','GroupNamesByStaff','READ',0),
	(591,'report','READ_GroupSavingSummary','GroupSavingSummary','READ',0),
	(592,'report','READ_LoanCyclePerProduct','LoanCyclePerProduct','READ',0),
	(593,'report','READ_Loans Awaiting Disbursal Summary by Month(Pentaho)','Loans Awaiting Disbursal Summary by Month(Pentaho)','READ',0),
	(594,'report','READ_Loans Awaiting Disbursal Summary(Pentaho)','Loans Awaiting Disbursal Summary(Pentaho)','READ',0),
	(595,'report','READ_Loans Awaiting Disbursal(Pentaho)','Loans Awaiting Disbursal(Pentaho)','READ',0),
	(596,'report','READ_Loans Pending Approval(Pentaho)','Loans Pending Approval(Pentaho)','READ',0),
	(597,'report','READ_LoanTrendsByDay','LoanTrendsByDay','READ',0),
	(598,'report','READ_LoanTrendsByMonth','LoanTrendsByMonth','READ',0),
	(599,'report','READ_LoanTrendsByWeek','LoanTrendsByWeek','READ',0),
	(600,'report','READ_Obligation Met Loans Details(Pentaho)','Obligation Met Loans Details(Pentaho)','READ',0),
	(601,'report','READ_Obligation Met Loans Summary(Pentaho)','Obligation Met Loans Summary(Pentaho)','READ',0),
	(602,'report','READ_Portfolio at Risk by Branch(Pentaho)','Portfolio at Risk by Branch(Pentaho)','READ',0),
	(603,'report','READ_Portfolio at Risk(Pentaho)','Portfolio at Risk(Pentaho)','READ',0),
	(604,'report','READ_Rescheduled Loans(Pentaho)','Rescheduled Loans(Pentaho)','READ',0),
	(605,'report','READ_Savings Transactions','Savings Transactions','READ',0),
	(606,'report','READ_TxnRunningBalances(Pentaho)','TxnRunningBalances(Pentaho)','READ',0),
	(607,'report','READ_Written-Off Loans(Pentaho)','Written-Off Loans(Pentaho)','READ',0),
	(608,'configuration','CREATE_ACCOUNTNUMBERFORMAT','ACCOUNTNUMBERFORMAT','CREATE',0),
	(609,'configuration','READ_ACCOUNTNUMBERFORMAT','ACCOUNTNUMBERFORMAT','READ',0),
	(610,'configuration','UPDATE_ACCOUNTNUMBERFORMAT','ACCOUNTNUMBERFORMAT','UPDATE',0),
	(611,'configuration','DELETE_ACCOUNTNUMBERFORMAT','HOOK','DELETE',0),
	(612,'portfolio','RECOVERGUARANTEES_LOAN','LOAN','RECOVERGUARANTEES',0),
	(613,'portfolio','RECOVERGUARANTEES_LOAN_CHECKER','LOAN','RECOVERGUARANTEES_CHECKER',0),
	(614,'portfolio','REJECT_CLIENT','CLIENT','REJECT',1),
	(615,'portfolio','REJECT_CLIENT_CHECKER','CLIENT','REJECT_CHECKER',0),
	(616,'portfolio','WITHDRAW_CLIENT','CLIENT','WITHDRAW',1),
	(617,'portfolio','WITHDRAW_CLIENT_CHECKER','CLIENT','WITHDRAW_CHECKER',0),
	(618,'portfolio','REACTIVATE_CLIENT','CLIENT','REACTIVATE',1),
	(619,'portfolio','REACTIVATE_CLIENT_CHECKER','CLIENT','REACTIVATE_CHECKER',0),
	(620,'transaction_savings','UPDATEDEPOSITAMOUNT_RECURRINGDEPOSITACCOUNT','RECURRINGDEPOSITACCOUNT','UPDATEDEPOSITAMOUNT',1),
	(621,'transaction_savings','UPDATEDEPOSITAMOUNT_RECURRINGDEPOSITACCOUNT_CHECKER','RECURRINGDEPOSITACCOUNT','UPDATEDEPOSITAMOUNT',1),
	(622,'transaction_savings','REFUNDBYTRANSFER_ACCOUNTTRANSFER_CHECKER','ACCOUNTTRANSFER','REFUNDBYTRANSFER',0),
	(623,'transaction_savings','REFUNDBYTRANSFER_ACCOUNTTRANSFER','ACCOUNTTRANSFER','REFUNDBYTRANSFER',1),
	(624,'transaction_loan','REFUNDBYCASH_LOAN','LOAN','REFUNDBYCASH',1),
	(625,'transaction_loan','REFUNDBYCASH_LOAN_CHECKER','LOAN','REFUNDBYCASH',0),
	(626,'cash_mgmt','CREATE_TELLER','TELLER','CREATE',1),
	(627,'cash_mgmt','UPDATE_TELLER','TELLER','UPDATE',1),
	(628,'cash_mgmt','ALLOCATECASHIER_TELLER','TELLER','ALLOCATE',1),
	(629,'cash_mgmt','UPDATECASHIERALLOCATION_TELLER','TELLER','UPDATECASHIERALLOCATION',1),
	(630,'cash_mgmt','DELETECASHIERALLOCATION_TELLER','TELLER','DELETECASHIERALLOCATION',1),
	(631,'cash_mgmt','ALLOCATECASHTOCASHIER_TELLER','TELLER','ALLOCATECASHTOCASHIER',1),
	(632,'cash_mgmt','SETTLECASHFROMCASHIER_TELLER','TELLER','SETTLECASHFROMCASHIER',1),
	(633,'authorisation','DISABLE_ROLE','ROLE','DISABLE',0),
	(634,'authorisation','DISABLE_ROLE_CHECKER','ROLE','DISABLE_CHECKER',0),
	(635,'authorisation','ENABLE_ROLE','ROLE','ENABLE',0),
	(636,'authorisation','ENABLE_ROLE_CHECKER','ROLE','ENABLE_CHECKER',0),
	(637,'accounting','DEFINEOPENINGBALANCE_JOURNALENTRY','JOURNALENTRY','DEFINEOPENINGBALANCE',1),
	(638,'collection_sheet','READ_COLLECTIONSHEET','COLLECTIONSHEET','READ',0),
	(639,'collection_sheet','SAVE_COLLECTIONSHEET','COLLECTIONSHEET','SAVE',0),
	(640,'infrastructure','CREATE_ENTITYMAPPING','ENTITYMAPPING','CREATE',0),
	(641,'infrastructure','UPDATE_ENTITYMAPPING','ENTITYMAPPING','UPDATE',0),
	(642,'infrastructure','DELETE_ENTITYMAPPING','ENTITYMAPPING','DELETE',0),
	(643,'organisation','READ_WORKINGDAYS','WORKINGDAYS','READ',0),
	(644,'organisation','UPDATE_WORKINGDAYS','WORKINGDAYS','UPDATE',0),
	(645,'organisation','UPDATE_WORKINGDAYS_CHECKER','WORKINGDAYS','UPDATE_CHECKER',0),
	(646,'authorisation','READ_PASSWORD_PREFERENCES','PASSWORD_PREFERENCES','READ',0),
	(647,'authorisation','UPDATE_PASSWORD_PREFERENCES','PASSWORD_PREFERENCES','UPDATE',0),
	(648,'authorisation','UPDATE_PASSWORD_PREFERENCES_CHECKER','PASSWORD_PREFERENCES','UPDATE_CHECKER',0),
	(649,'portfolio','CREATE_PAYMENTTYPE','PAYMENTTYPE','CREATE',0),
	(650,'portfolio','UPDATE_PAYMENTTYPE','PAYMENTTYPE','UPDATE',0),
	(651,'portfolio','DELETE_PAYMENTTYPE','PAYMENTTYPE','DELETE',0),
	(652,'cash_mgmt','DELETE_TELLER','TELLER','DELETE',1),
	(653,'report','READ_General Ledger Report','General Ledger Report','READ',0),
	(654,'portfolio','READ_STAFFIMAGE','STAFFIMAGE','READ',0),
	(655,'portfolio','CREATE_STAFFIMAGE','STAFFIMAGE','CREATE',1),
	(656,'portfolio','CREATE_STAFFIMAGE_CHECKER','STAFFIMAGE','CREATE',0),
	(657,'portfolio','DELETE_STAFFIMAGE','STAFFIMAGE','DELETE',1),
	(658,'portfolio','DELETE_STAFFIMAGE_CHECKER','STAFFIMAGE','DELETE',0),
	(659,'report','READ_Active Loan Summary per Branch','Active Loan Summary per Branch','READ',0),
	(660,'report','READ_Disbursal Report','Disbursal Report','READ',0),
	(661,'report','READ_Balance Outstanding','Balance Outstanding','READ',0),
	(662,'report','READ_Collection Report','Collection Report','READ',0),
	(663,'portfolio','READ_PAYMENTTYPE','PAYMENTTYPE','READ',0),
	(664,'report','READ_Staff Assignment History','Staff Assignment History(Pentaho)','READ',0),
	(665,'externalservices','UPDATE_EXTERNALSERVICES','EXTERNALSERVICES','UPDATE',0),
	(666,'portfolio','READ_CLIENTCHARGE','CLIENTCHARGE','READ',0),
	(667,'portfolio','CREATE_CLIENTCHARGE','CLIENTCHARGE','CREATE',0),
	(668,'portfolio','DELETE_CLIENTCHARGE','CLIENTCHARGE','DELETE',0),
	(669,'portfolio','WAIVE_CLIENTCHARGE','CLIENTCHARGE','WAIVE',0),
	(670,'portfolio','PAY_CLIENTCHARGE','CLIENTCHARGE','PAY',0),
	(671,'portfolio','INACTIVATE_CLIENTCHARGE','CLIENTCHARGE','INACTIVATE',0),
	(672,'portfolio','UPDATE_CLIENTCHARGE','CLIENTCHARGE','UPDATE',0),
	(673,'portfolio','CREATE_CLIENTCHARGE_CHECKER','CLIENTCHARGE','CREATE_CHECKER',0),
	(674,'portfolio','DELETE_CLIENTCHARGE_CHECKER','CLIENTCHARGE','DELETE_CHECKER',0),
	(675,'portfolio','WAIVE_CLIENTCHARGE_CHECKER','CLIENTCHARGE','WAIVE_CHECKER',0),
	(676,'portfolio','PAY_CLIENTCHARGE_CHECKER','CLIENTCHARGE','PAY_CHECKER',0),
	(677,'portfolio','INACTIVATE_CLIENTCHARGE_CHECKER','CLIENTCHARGE','INACTIVATE_CHECKER',0),
	(678,'portfolio','UPDATE_CLIENTCHARGE_CHECKER','CLIENTCHARGE','UPDATE_CHECKER',0),
	(679,'transaction_client','READTRANSACTION_CLIENT','CLIENT','READTRANSACTION',0),
	(680,'transaction_client','UNDOTRANSACTION_CLIENT','CLIENT','UNDOTRANSACTION',0),
	(681,'transaction_client','UNDOTRANSACTION_CLIENT_CHECKER','CLIENT','UNDOTRANSACTION_CHECKER',0),
	(682,'LOAN_PROVISIONING','CREATE_PROVISIONCATEGORY','PROVISIONCATEGORY','CREATE',0),
	(683,'LOAN_PROVISIONING','DELETE_PROVISIONCATEGORY','PROVISIONCATEGORY','DELETE',0),
	(684,'LOAN_PROVISIONING','CREATE_PROVISIONCRITERIA','PROVISIONINGCRITERIA','CREATE',0),
	(685,'LOAN_PROVISIONING','UPDATE_PROVISIONCRITERIA','PROVISIONINGCRITERIA','UPDATE',0),
	(686,'LOAN_PROVISIONING','DELETE_PROVISIONCRITERIA','PROVISIONINGCRITERIA','DELETE',0),
	(687,'LOAN_PROVISIONING','CREATE_PROVISIONENTRIES','PROVISIONINGENTRIES','CREATE',0),
	(688,'LOAN_PROVISIONING','CREATE_PROVISIONJOURNALENTRIES','PROVISIONINGENTRIES','CREATE',0),
	(689,'LOAN_PROVISIONING','RECREATE_PROVISIONENTRIES','PROVISIONINGENTRIES','RECREATE',0),
	(690,'portfolio','READ_FLOATINGRATE','FLOATINGRATE','READ',0),
	(691,'portfolio','CREATE_FLOATINGRATE','FLOATINGRATE','CREATE',1),
	(692,'portfolio','CREATE_FLOATINGRATE_CHECKER','FLOATINGRATE','CREATE_CHECKER',0),
	(693,'portfolio','UPDATE_FLOATINGRATE','FLOATINGRATE','UPDATE',1),
	(694,'portfolio','UPDATE_FLOATINGRATE_CHECKER','FLOATINGRATE','UPDATE_CHECKER',0),
	(695,'portfolio','CREATESCHEDULEEXCEPTIONS_LOAN','LOAN','CREATESCHEDULEEXCEPTIONS',0),
	(696,'portfolio','CREATESCHEDULEEXCEPTIONS_LOAN_CHECKER','LOAN','CREATESCHEDULEEXCEPTIONS_CHECKER',0),
	(697,'portfolio','DELETESCHEDULEEXCEPTIONS_LOAN','LOAN','DELETESCHEDULEEXCEPTIONS',0),
	(698,'portfolio','DELETESCHEDULEEXCEPTIONS_LOAN_CHECKER','LOAN','DELETESCHEDULEEXCEPTIONS_CHECKER',0),
	(699,'transaction_loan','DISBURSALLASTUNDO_LOAN','LOAN','DISBURSALLASTUNDO',0),
	(700,'transaction_loan','DISBURSALLASTUNDO_LOAN_CHECKER','LOAN','DISBURSALLASTUNDO_CHECKER',0),
	(701,'SHAREPRODUCT','CREATE_SHAREPRODUCT','SHAREPRODUCT','CREATE',0),
	(702,'SHAREPRODUCT','UPDATE_SHAREPRODUCT','SHAREPRODUCT','CREATE',0),
	(703,'SHAREACCOUNT','CREATE_SHAREACCOUNT','SHAREACCOUNT','CREATE',0),
	(704,'SHAREACCOUNT','UPDATE_SHAREACCOUNT','SHAREACCOUNT','CREATE',0),
	(705,'organisation','READ_TAXCOMPONENT','TAXCOMPONENT','READ',0),
	(706,'organisation','CREATE_TAXCOMPONENT','TAXCOMPONENT','CREATE',0),
	(707,'organisation','CREATE_TAXCOMPONENT_CHECKER','TAXCOMPONENT','CREATE_CHECKER',0),
	(708,'organisation','UPDATE_TAXCOMPONENT','TAXCOMPONENT','UPDATE',0),
	(709,'organisation','UPDATE_TAXCOMPONENT_CHECKER','TAXCOMPONENT','UPDATE_CHECKER',0),
	(710,'organisation','READ_TAXGROUP','TAXGROUP','READ',0),
	(711,'organisation','CREATE_TAXGROUP','TAXGROUP','CREATE',0),
	(712,'organisation','CREATE_TAXGROUP_CHECKER','TAXGROUP','CREATE_CHECKER',0),
	(713,'organisation','UPDATE_TAXGROUP','TAXGROUP','UPDATE',0),
	(714,'organisation','UPDATE_TAXGROUP_CHECKER','TAXGROUP','UPDATE_CHECKER',0),
	(715,'portfolio','UPDATEWITHHOLDTAX_SAVINGSACCOUNT','SAVINGSACCOUNT','UPDATEWITHHOLDTAX',0),
	(716,'portfolio','UPDATEWITHHOLDTAX_SAVINGSACCOUNT_CHECKER','SAVINGSACCOUNT','UPDATEWITHHOLDTAX_CHECKER',0),
	(717,'SHAREPRODUCT','CREATE_DIVIDEND_SHAREPRODUCT','SHAREPRODUCT','CREATE_DIVIDEND',0),
	(718,'SHAREPRODUCT','CREATE_DIVIDEND_SHAREPRODUCT_CHECKER','SHAREPRODUCT','CREATE_DIVIDEND_CHECKER',0),
	(719,'SHAREPRODUCT','APPROVE_DIVIDEND_SHAREPRODUCT','SHAREPRODUCT','APPROVE_DIVIDEND',0),
	(720,'SHAREPRODUCT','APPROVE_DIVIDEND_SHAREPRODUCT_CHECKER','SHAREPRODUCT','APPROVE_DIVIDEND_CHECKER',0),
	(721,'SHAREPRODUCT','DELETE_DIVIDEND_SHAREPRODUCT','SHAREPRODUCT','DELETE_DIVIDEND',0),
	(722,'SHAREPRODUCT','DELETE_DIVIDEND_SHAREPRODUCT_CHECKER','SHAREPRODUCT','DELETE_DIVIDEND_CHECKER',0),
	(723,'SHAREPRODUCT','READ_DIVIDEND_SHAREPRODUCT','SHAREPRODUCT','READ_DIVIDEND',0),
	(724,'SHAREACCOUNT','APPROVE_SHAREACCOUNT','SHAREACCOUNT','APPROVE',0),
	(725,'SHAREACCOUNT','ACTIVATE_SHAREACCOUNT','SHAREACCOUNT','ACTIVATE',0),
	(726,'SHAREACCOUNT','UNDOAPPROVAL_SHAREACCOUNT','SHAREACCOUNT','UNDOAPPROVAL',0),
	(727,'SHAREACCOUNT','REJECT_SHAREACCOUNT','SHAREACCOUNT','REJECT',0),
	(728,'SHAREACCOUNT','APPLYADDITIONALSHARES_SHAREACCOUNT','SHAREACCOUNT','APPLYADDITIONALSHARES',0),
	(729,'SHAREACCOUNT','APPROVEADDITIONALSHARES_SHAREACCOUNT','SHAREACCOUNT','APPROVEADDITIONALSHARES',0),
	(730,'SHAREACCOUNT','REJECTADDITIONALSHARES_SHAREACCOUNT','SHAREACCOUNT','REJECTADDITIONALSHARES',0),
	(731,'SHAREACCOUNT','REDEEMSHARES_SHAREACCOUNT','SHAREACCOUNT','REDEEMSHARES',0),
	(732,'SHAREACCOUNT','CLOSE_SHAREACCOUNT','SHAREACCOUNT','CLOSE',0),
	(733,'SSBENEFICIARYTPT','READ_SSBENEFICIARYTPT','SSBENEFICIARYTPT','READ',0),
	(734,'SSBENEFICIARYTPT','CREATE_SSBENEFICIARYTPT','SSBENEFICIARYTPT','CREATE',0),
	(735,'SSBENEFICIARYTPT','UPDATE_SSBENEFICIARYTPT','SSBENEFICIARYTPT','UPDATE',0),
	(736,'SSBENEFICIARYTPT','DELETE_SSBENEFICIARYTPT','SSBENEFICIARYTPT','DELETE',0),
	(737,'portfolio','FORECLOSURE_LOAN','LOAN','FORECLOSURE',0),
	(738,'portfolio','FORECLOSURE_LOAN_CHECKER','LOAN','FORECLOSURE_CHECKER',0),
	(739,'portfolio','CREATE_ADDRESS','ADDRESS','CREATE',0),
	(740,'portfolio','CREATE_ADDRESS_CHECKER','ADDRESS','CREATE_CHECKER',1),
	(741,'portfolio','UPDATE_ADDRESS','ADDRESS','UPDATE',0),
	(742,'portfolio','UPDATE_ADDRESS_CHECKER','ADDRESS','UPDATE_CHECKER',1),
	(743,'portfolio','READ_ADDRESS','ADDRESS','READ',0),
	(744,'portfolio','DELETE_ADDRESS','ADDRESS','DELETE',0),
	(745,'portfolio','DELETE_ADDRESS_CHECKER','ADDRESS','DELETE_CHECKER',1),
	(746,'jobs','CREATE_REPORTMAILINGJOB','REPORTMAILINGJOB','CREATE',0),
	(747,'jobs','UPDATE_REPORTMAILINGJOB','REPORTMAILINGJOB','UPDATE',0),
	(748,'jobs','DELETE_REPORTMAILINGJOB','REPORTMAILINGJOB','DELETE',0),
	(749,'jobs','READ_REPORTMAILINGJOB','REPORTMAILINGJOB','READ',0),
	(750,'portfolio','UNDOREJECT_CLIENT','CLIENT','UNDOREJECT',1),
	(751,'portfolio','UNDOREJECT_CLIENT_CHECKER','CLIENT','UNDOREJECT_CHECKER',1),
	(752,'portfolio','UNDOWITHDRAWAL_CLIENT','CLIENT','UNDOWITHDRAWAL',1),
	(753,'portfolio','UNDOWITHDRAWAL_CLIENT_CHECKER','CLIENT','UNDOWITHDRAWAL_CHECKER',1),
	(754,'report','READ_Daily Teller Cash Report (Pentaho)','Daily Teller Cash Report (Pentaho)','READ',0);

/*!40000 ALTER TABLE `m_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_portfolio_account_associations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_portfolio_account_associations`;

CREATE TABLE `m_portfolio_account_associations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_account_id` bigint(20) DEFAULT NULL,
  `savings_account_id` bigint(20) DEFAULT NULL,
  `linked_loan_account_id` bigint(20) DEFAULT NULL,
  `linked_savings_account_id` bigint(20) DEFAULT NULL,
  `association_type_enum` smallint(1) NOT NULL DEFAULT '1',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `account_association_loan_fk` (`loan_account_id`),
  KEY `account_association_savings_fk` (`savings_account_id`),
  KEY `linked_loan_fk` (`linked_loan_account_id`),
  KEY `linked_savings_fk` (`linked_savings_account_id`),
  CONSTRAINT `account_association_loan_fk` FOREIGN KEY (`loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `account_association_savings_fk` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `linked_loan_fk` FOREIGN KEY (`linked_loan_account_id`) REFERENCES `m_loan` (`id`),
  CONSTRAINT `linked_savings_fk` FOREIGN KEY (`linked_savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_portfolio_command_source
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_portfolio_command_source`;

CREATE TABLE `m_portfolio_command_source` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `action_name` varchar(50) NOT NULL,
  `entity_name` varchar(50) NOT NULL,
  `office_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `loan_id` bigint(20) DEFAULT NULL,
  `savings_account_id` bigint(20) DEFAULT NULL,
  `api_get_url` varchar(100) NOT NULL,
  `resource_id` bigint(20) DEFAULT NULL,
  `subresource_id` bigint(20) DEFAULT NULL,
  `command_as_json` text NOT NULL,
  `maker_id` bigint(20) NOT NULL,
  `made_on_date` datetime NOT NULL,
  `checker_id` bigint(20) DEFAULT NULL,
  `checked_on_date` datetime DEFAULT NULL,
  `processing_result_enum` smallint(5) NOT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_maker_m_appuser` (`maker_id`),
  KEY `FK_m_checker_m_appuser` (`checker_id`),
  KEY `action_name` (`action_name`),
  KEY `entity_name` (`entity_name`,`resource_id`),
  KEY `made_on_date` (`made_on_date`),
  KEY `checked_on_date` (`checked_on_date`),
  KEY `processing_result_enum` (`processing_result_enum`),
  KEY `office_id` (`office_id`),
  KEY `group_id` (`office_id`),
  KEY `client_id` (`office_id`),
  KEY `loan_id` (`office_id`),
  CONSTRAINT `FK_m_checker_m_appuser` FOREIGN KEY (`checker_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_maker_m_appuser` FOREIGN KEY (`maker_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_product_loan
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan`;

CREATE TABLE `m_product_loan` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `short_name` varchar(4) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `principal_amount` decimal(19,6) DEFAULT NULL,
  `min_principal_amount` decimal(19,6) DEFAULT NULL,
  `max_principal_amount` decimal(19,6) DEFAULT NULL,
  `arrearstolerance_amount` decimal(19,6) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `fund_id` bigint(20) DEFAULT NULL,
  `is_linked_to_floating_interest_rates` bit(1) NOT NULL DEFAULT b'0',
  `allow_variabe_installments` bit(1) NOT NULL DEFAULT b'0',
  `nominal_interest_rate_per_period` decimal(19,6) DEFAULT NULL,
  `min_nominal_interest_rate_per_period` decimal(19,6) DEFAULT NULL,
  `max_nominal_interest_rate_per_period` decimal(19,6) DEFAULT NULL,
  `interest_period_frequency_enum` smallint(5) DEFAULT NULL,
  `annual_nominal_interest_rate` decimal(19,6) DEFAULT NULL,
  `interest_method_enum` smallint(5) NOT NULL,
  `interest_calculated_in_period_enum` smallint(5) NOT NULL DEFAULT '1',
  `allow_partial_period_interest_calcualtion` tinyint(1) NOT NULL DEFAULT '0',
  `repay_every` smallint(5) NOT NULL,
  `repayment_period_frequency_enum` smallint(5) NOT NULL,
  `number_of_repayments` smallint(5) NOT NULL,
  `min_number_of_repayments` smallint(5) DEFAULT NULL,
  `max_number_of_repayments` smallint(5) DEFAULT NULL,
  `grace_on_principal_periods` smallint(5) DEFAULT NULL,
  `recurring_moratorium_principal_periods` smallint(5) DEFAULT NULL,
  `grace_on_interest_periods` smallint(5) DEFAULT NULL,
  `grace_interest_free_periods` smallint(5) DEFAULT NULL,
  `amortization_method_enum` smallint(5) NOT NULL,
  `accounting_type` smallint(5) NOT NULL,
  `loan_transaction_strategy_id` bigint(20) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `include_in_borrower_cycle` tinyint(1) NOT NULL DEFAULT '0',
  `use_borrower_cycle` tinyint(1) NOT NULL DEFAULT '0',
  `start_date` date DEFAULT NULL,
  `close_date` date DEFAULT NULL,
  `allow_multiple_disbursals` tinyint(1) NOT NULL DEFAULT '0',
  `max_disbursals` int(2) DEFAULT NULL,
  `max_outstanding_loan_balance` decimal(19,6) DEFAULT NULL,
  `grace_on_arrears_ageing` smallint(5) DEFAULT NULL,
  `overdue_days_for_npa` smallint(5) DEFAULT NULL,
  `days_in_month_enum` smallint(5) NOT NULL DEFAULT '1',
  `days_in_year_enum` smallint(5) NOT NULL DEFAULT '1',
  `interest_recalculation_enabled` tinyint(4) NOT NULL DEFAULT '0',
  `min_days_between_disbursal_and_first_repayment` int(3) DEFAULT NULL,
  `hold_guarantee_funds` tinyint(1) NOT NULL DEFAULT '0',
  `principal_threshold_for_last_installment` decimal(5,2) NOT NULL DEFAULT '50.00',
  `account_moves_out_of_npa_only_on_arrears_completion` tinyint(1) NOT NULL DEFAULT '0',
  `can_define_fixed_emi_amount` tinyint(1) NOT NULL DEFAULT '0',
  `instalment_amount_in_multiples_of` decimal(19,6) DEFAULT NULL,
  `can_use_for_topup` tinyint(1) NOT NULL DEFAULT '0',
  `sync_expected_with_disbursement_date` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`),
  UNIQUE KEY `unq_short_name` (`short_name`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  KEY `FKA6A8A7D77240145` (`fund_id`),
  KEY `FK_ltp_strategy` (`loan_transaction_strategy_id`),
  CONSTRAINT `FKA6A8A7D77240145` FOREIGN KEY (`fund_id`) REFERENCES `m_fund` (`id`),
  CONSTRAINT `FK_ltp_strategy` FOREIGN KEY (`loan_transaction_strategy_id`) REFERENCES `ref_loan_transaction_processing_strategy` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_product_loan_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_charge`;

CREATE TABLE `m_product_loan_charge` (
  `product_loan_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  PRIMARY KEY (`product_loan_id`,`charge_id`),
  KEY `charge_id` (`charge_id`),
  CONSTRAINT `m_product_loan_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_product_loan_charge_ibfk_2` FOREIGN KEY (`product_loan_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_product_loan_configurable_attributes
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_configurable_attributes`;

CREATE TABLE `m_product_loan_configurable_attributes` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_product_id` bigint(20) NOT NULL,
  `amortization_method_enum` tinyint(4) NOT NULL DEFAULT '1',
  `interest_method_enum` tinyint(4) NOT NULL DEFAULT '1',
  `loan_transaction_strategy_id` tinyint(4) NOT NULL DEFAULT '1',
  `interest_calculated_in_period_enum` tinyint(4) NOT NULL DEFAULT '1',
  `arrearstolerance_amount` tinyint(4) NOT NULL DEFAULT '1',
  `repay_every` tinyint(4) NOT NULL DEFAULT '1',
  `moratorium` tinyint(4) NOT NULL DEFAULT '1',
  `grace_on_arrears_ageing` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `fk_m_product_loan_configurable_attributes_0001` (`loan_product_id`),
  CONSTRAINT `fk_m_product_loan_configurable_attributes_0001` FOREIGN KEY (`loan_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_product_loan_floating_rates
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_floating_rates`;

CREATE TABLE `m_product_loan_floating_rates` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_product_id` bigint(20) NOT NULL,
  `floating_rates_id` bigint(20) NOT NULL,
  `interest_rate_differential` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `min_differential_lending_rate` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `default_differential_lending_rate` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `max_differential_lending_rate` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_floating_interest_rate_calculation_allowed` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  KEY `FK_mappings_m_product_loan_id` (`loan_product_id`),
  KEY `FK_mappings_m_floating_rates_id` (`floating_rates_id`),
  CONSTRAINT `FK_mappings_m_floating_rates_id` FOREIGN KEY (`floating_rates_id`) REFERENCES `m_floating_rates` (`id`),
  CONSTRAINT `FK_mappings_m_product_loan_id` FOREIGN KEY (`loan_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_product_loan_guarantee_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_guarantee_details`;

CREATE TABLE `m_product_loan_guarantee_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_product_id` bigint(20) NOT NULL,
  `mandatory_guarantee` decimal(19,5) NOT NULL,
  `minimum_guarantee_from_own_funds` decimal(19,5) DEFAULT NULL,
  `minimum_guarantee_from_guarantor_funds` decimal(19,5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_guarantee_details_loan_product` (`loan_product_id`),
  CONSTRAINT `FK_guarantee_details_loan_product` FOREIGN KEY (`loan_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_product_loan_recalculation_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_recalculation_details`;

CREATE TABLE `m_product_loan_recalculation_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `compound_type_enum` smallint(5) NOT NULL,
  `reschedule_strategy_enum` smallint(5) NOT NULL,
  `rest_frequency_type_enum` smallint(1) NOT NULL,
  `rest_frequency_interval` smallint(3) NOT NULL DEFAULT '0',
  `arrears_based_on_original_schedule` tinyint(1) NOT NULL DEFAULT '0',
  `pre_close_interest_calculation_strategy` smallint(3) NOT NULL DEFAULT '1',
  `compounding_frequency_type_enum` smallint(1) DEFAULT NULL,
  `compounding_frequency_interval` smallint(3) DEFAULT NULL,
  `rest_frequency_nth_day_enum` int(5) DEFAULT NULL,
  `rest_frequency_on_day` int(5) DEFAULT NULL,
  `rest_frequency_weekday_enum` int(5) DEFAULT NULL,
  `compounding_frequency_nth_day_enum` int(5) DEFAULT NULL,
  `compounding_frequency_on_day` int(5) DEFAULT NULL,
  `compounding_frequency_weekday_enum` int(5) DEFAULT NULL,
  `is_compounding_to_be_posted_as_transaction` tinyint(1) NOT NULL DEFAULT '0',
  `allow_compounding_on_eod` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_m_product_loan_m_product_loan_recalculation_details` (`product_id`),
  CONSTRAINT `FK_m_product_loan_m_product_loan_recalculation_details` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_product_loan_variable_installment_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_variable_installment_config`;

CREATE TABLE `m_product_loan_variable_installment_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_product_id` bigint(20) NOT NULL,
  `minimum_gap` int(4) NOT NULL,
  `maximum_gap` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_mappings_m_variable_product_loan_id` (`loan_product_id`),
  CONSTRAINT `FK_mappings_m_variable_product_loan_id` FOREIGN KEY (`loan_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_product_loan_variations_borrower_cycle
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_loan_variations_borrower_cycle`;

CREATE TABLE `m_product_loan_variations_borrower_cycle` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `loan_product_id` bigint(20) NOT NULL DEFAULT '0',
  `borrower_cycle_number` int(3) NOT NULL DEFAULT '0',
  `value_condition` int(1) NOT NULL DEFAULT '0',
  `param_type` int(1) NOT NULL DEFAULT '0',
  `default_value` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `max_value` decimal(19,6) DEFAULT NULL,
  `min_value` decimal(19,6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `borrower_cycle_loan_product_FK` (`loan_product_id`),
  CONSTRAINT `borrower_cycle_loan_product_FK` FOREIGN KEY (`loan_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_product_mix
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_product_mix`;

CREATE TABLE `m_product_mix` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `restricted_product_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_product_mix_product_id_to_m_product_loan` (`product_id`),
  KEY `FK_m_product_mix_restricted_product_id_to_m_product_loan` (`restricted_product_id`),
  CONSTRAINT `FK_m_product_mix_product_id_to_m_product_loan` FOREIGN KEY (`product_id`) REFERENCES `m_product_loan` (`id`),
  CONSTRAINT `FK_m_product_mix_restricted_product_id_to_m_product_loan` FOREIGN KEY (`restricted_product_id`) REFERENCES `m_product_loan` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_provision_category
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_provision_category`;

CREATE TABLE `m_provision_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `description` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_provision_category` WRITE;
/*!40000 ALTER TABLE `m_provision_category` DISABLE KEYS */;

INSERT INTO `m_provision_category` (`id`, `category_name`, `description`)
VALUES
	(1,'STANDARD','Punctual Payment without any dues'),
	(2,'SUB-STANDARD','Principal and/or Interest overdue by x days'),
	(3,'DOUBTFUL','Principal and/or Interest overdue by x days and less than y'),
	(4,'LOSS','Principal and/or Interest overdue by y days');

/*!40000 ALTER TABLE `m_provision_category` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_provisioning_criteria
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_provisioning_criteria`;

CREATE TABLE `m_provisioning_criteria` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `criteria_name` varchar(200) NOT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `criteria_name` (`criteria_name`),
  KEY `createdby_id` (`createdby_id`),
  KEY `lastmodifiedby_id` (`lastmodifiedby_id`),
  CONSTRAINT `m_provisioning_criteria_ibfk_1` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_provisioning_criteria_ibfk_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_provisioning_criteria_definition
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_provisioning_criteria_definition`;

CREATE TABLE `m_provisioning_criteria_definition` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `criteria_id` bigint(20) NOT NULL,
  `category_id` bigint(20) NOT NULL,
  `min_age` bigint(20) NOT NULL,
  `max_age` bigint(20) NOT NULL,
  `provision_percentage` decimal(5,2) NOT NULL,
  `liability_account` bigint(20) DEFAULT NULL,
  `expense_account` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `criteria_id` (`criteria_id`),
  KEY `category_id` (`category_id`),
  KEY `liability_account` (`liability_account`),
  KEY `expense_account` (`expense_account`),
  CONSTRAINT `m_provisioning_criteria_definition_ibfk_1` FOREIGN KEY (`criteria_id`) REFERENCES `m_provisioning_criteria` (`id`),
  CONSTRAINT `m_provisioning_criteria_definition_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `m_provision_category` (`id`),
  CONSTRAINT `m_provisioning_criteria_definition_ibfk_3` FOREIGN KEY (`liability_account`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `m_provisioning_criteria_definition_ibfk_4` FOREIGN KEY (`expense_account`) REFERENCES `acc_gl_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_provisioning_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_provisioning_history`;

CREATE TABLE `m_provisioning_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `journal_entry_created` bit(1) DEFAULT b'0',
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `createdby_id` (`createdby_id`),
  KEY `lastmodifiedby_id` (`lastmodifiedby_id`),
  CONSTRAINT `m_provisioning_history_ibfk_1` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_provisioning_history_ibfk_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_report_mailing_job
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_report_mailing_job`;

CREATE TABLE `m_report_mailing_job` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` text,
  `start_datetime` datetime NOT NULL,
  `recurrence` varchar(100) DEFAULT NULL,
  `created_date` date NOT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `lastmodified_date` date DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `email_recipients` text NOT NULL,
  `email_subject` varchar(100) NOT NULL,
  `email_message` text NOT NULL,
  `email_attachment_file_format` varchar(10) NOT NULL,
  `stretchy_report_id` int(11) NOT NULL,
  `stretchy_report_param_map` text,
  `previous_run_datetime` datetime DEFAULT NULL,
  `next_run_datetime` datetime DEFAULT NULL,
  `previous_run_status` varchar(10) DEFAULT NULL,
  `previous_run_error_log` text,
  `previous_run_error_message` text,
  `number_of_runs` int(11) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `run_as_userid` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name` (`name`),
  KEY `createdby_id` (`createdby_id`),
  KEY `lastmodifiedby_id` (`lastmodifiedby_id`),
  KEY `stretchy_report_id` (`stretchy_report_id`),
  KEY `run_as_userid` (`run_as_userid`),
  CONSTRAINT `m_report_mailing_job_ibfk_1` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_report_mailing_job_ibfk_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_report_mailing_job_ibfk_3` FOREIGN KEY (`stretchy_report_id`) REFERENCES `stretchy_report` (`id`),
  CONSTRAINT `m_report_mailing_job_ibfk_4` FOREIGN KEY (`run_as_userid`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_report_mailing_job_configuration
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_report_mailing_job_configuration`;

CREATE TABLE `m_report_mailing_job_configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `value` varchar(200) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `m_report_mailing_job_configuration` WRITE;
/*!40000 ALTER TABLE `m_report_mailing_job_configuration` DISABLE KEYS */;

INSERT INTO `m_report_mailing_job_configuration` (`id`, `name`, `value`)
VALUES
	(1,'GMAIL_SMTP_SERVER','smtp.gmail.com'),
	(2,'GMAIL_SMTP_PORT','587'),
	(3,'GMAIL_SMTP_USERNAME',''),
	(4,'GMAIL_SMTP_PASSWORD','');

/*!40000 ALTER TABLE `m_report_mailing_job_configuration` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_report_mailing_job_run_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_report_mailing_job_run_history`;

CREATE TABLE `m_report_mailing_job_run_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `job_id` bigint(20) NOT NULL,
  `start_datetime` datetime NOT NULL,
  `end_datetime` datetime NOT NULL,
  `status` varchar(10) NOT NULL,
  `error_message` text,
  `error_log` text,
  PRIMARY KEY (`id`),
  KEY `job_id` (`job_id`),
  CONSTRAINT `m_report_mailing_job_run_history_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `m_report_mailing_job` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_role
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_role`;

CREATE TABLE `m_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(500) NOT NULL,
  `is_disabled` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_role` WRITE;
/*!40000 ALTER TABLE `m_role` DISABLE KEYS */;

INSERT INTO `m_role` (`id`, `name`, `description`, `is_disabled`)
VALUES
	(1,'Super user','This role provides all application permissions.',0);

/*!40000 ALTER TABLE `m_role` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_role_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_role_permission`;

CREATE TABLE `m_role_permission` (
  `role_id` bigint(20) NOT NULL,
  `permission_id` bigint(20) NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `FK8DEDB04815CEC7AB` (`role_id`),
  KEY `FK8DEDB048103B544B` (`permission_id`),
  CONSTRAINT `FK8DEDB048103B544B` FOREIGN KEY (`permission_id`) REFERENCES `m_permission` (`id`),
  CONSTRAINT `FK8DEDB04815CEC7AB` FOREIGN KEY (`role_id`) REFERENCES `m_role` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_role_permission` WRITE;
/*!40000 ALTER TABLE `m_role_permission` DISABLE KEYS */;

INSERT INTO `m_role_permission` (`role_id`, `permission_id`)
VALUES
	(1,1);

/*!40000 ALTER TABLE `m_role_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table m_savings_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account`;

CREATE TABLE `m_savings_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `group_id` bigint(20) DEFAULT NULL,
  `product_id` bigint(20) DEFAULT NULL,
  `field_officer_id` bigint(20) DEFAULT NULL,
  `status_enum` smallint(5) NOT NULL DEFAULT '300',
  `sub_status_enum` smallint(5) NOT NULL DEFAULT '0',
  `account_type_enum` smallint(5) NOT NULL DEFAULT '1',
  `deposit_type_enum` smallint(5) NOT NULL DEFAULT '100',
  `submittedon_date` date NOT NULL,
  `submittedon_userid` bigint(20) DEFAULT NULL,
  `approvedon_date` date DEFAULT NULL,
  `approvedon_userid` bigint(20) DEFAULT NULL,
  `rejectedon_date` date DEFAULT NULL,
  `rejectedon_userid` bigint(20) DEFAULT NULL,
  `withdrawnon_date` date DEFAULT NULL,
  `withdrawnon_userid` bigint(20) DEFAULT NULL,
  `activatedon_date` date DEFAULT NULL,
  `activatedon_userid` bigint(20) DEFAULT NULL,
  `closedon_date` date DEFAULT NULL,
  `closedon_userid` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `nominal_annual_interest_rate` decimal(19,6) NOT NULL,
  `interest_compounding_period_enum` smallint(5) NOT NULL,
  `interest_posting_period_enum` smallint(5) NOT NULL DEFAULT '4',
  `interest_calculation_type_enum` smallint(5) NOT NULL,
  `interest_calculation_days_in_year_type_enum` smallint(5) NOT NULL,
  `min_required_opening_balance` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency_enum` smallint(5) DEFAULT NULL,
  `withdrawal_fee_for_transfer` tinyint(4) DEFAULT '1',
  `allow_overdraft` tinyint(1) NOT NULL DEFAULT '0',
  `overdraft_limit` decimal(19,6) DEFAULT NULL,
  `nominal_annual_interest_rate_overdraft` decimal(19,6) DEFAULT '0.000000',
  `min_overdraft_for_interest_calculation` decimal(19,6) DEFAULT '0.000000',
  `lockedin_until_date_derived` date DEFAULT NULL,
  `total_deposits_derived` decimal(19,6) DEFAULT NULL,
  `total_withdrawals_derived` decimal(19,6) DEFAULT NULL,
  `total_withdrawal_fees_derived` decimal(19,6) DEFAULT NULL,
  `total_fees_charge_derived` decimal(19,6) DEFAULT NULL,
  `total_penalty_charge_derived` decimal(19,6) DEFAULT NULL,
  `total_annual_fees_derived` decimal(19,6) DEFAULT NULL,
  `total_interest_earned_derived` decimal(19,6) DEFAULT NULL,
  `total_interest_posted_derived` decimal(19,6) DEFAULT NULL,
  `total_overdraft_interest_derived` decimal(19,6) DEFAULT '0.000000',
  `total_withhold_tax_derived` decimal(19,6) DEFAULT NULL,
  `account_balance_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `min_required_balance` decimal(19,6) DEFAULT NULL,
  `enforce_min_required_balance` tinyint(1) NOT NULL DEFAULT '0',
  `min_balance_for_interest_calculation` decimal(19,6) DEFAULT NULL,
  `start_interest_calculation_date` date DEFAULT NULL,
  `on_hold_funds_derived` decimal(19,6) DEFAULT NULL,
  `version` int(15) NOT NULL DEFAULT '1',
  `withhold_tax` tinyint(4) NOT NULL DEFAULT '0',
  `tax_group_id` bigint(20) DEFAULT NULL,
  `last_interest_calculation_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sa_account_no_UNIQUE` (`account_no`),
  UNIQUE KEY `sa_externalid_UNIQUE` (`external_id`),
  KEY `FKSA00000000000001` (`client_id`),
  KEY `FKSA00000000000002` (`group_id`),
  KEY `FKSA00000000000003` (`product_id`),
  KEY `FK_savings_account_tax_group` (`tax_group_id`),
  CONSTRAINT `FKSA00000000000001` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKSA00000000000002` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FKSA00000000000003` FOREIGN KEY (`product_id`) REFERENCES `m_savings_product` (`id`),
  CONSTRAINT `FK_savings_account_tax_group` FOREIGN KEY (`tax_group_id`) REFERENCES `m_tax_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_account_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account_charge`;

CREATE TABLE `m_savings_account_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  `is_penalty` tinyint(1) NOT NULL DEFAULT '0',
  `charge_time_enum` smallint(5) NOT NULL,
  `charge_due_date` date DEFAULT NULL,
  `fee_on_month` smallint(5) DEFAULT NULL,
  `fee_on_day` smallint(5) DEFAULT NULL,
  `fee_interval` smallint(5) DEFAULT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `calculation_percentage` decimal(19,6) DEFAULT NULL,
  `calculation_on_amount` decimal(19,6) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `inactivated_on_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `charge_id` (`charge_id`),
  KEY `m_savings_account_charge_ibfk_2` (`savings_account_id`),
  CONSTRAINT `m_savings_account_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_savings_account_charge_ibfk_2` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_account_charge_paid_by
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account_charge_paid_by`;

CREATE TABLE `m_savings_account_charge_paid_by` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_transaction_id` bigint(20) NOT NULL,
  `savings_account_charge_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK__m_savings_account_transaction` (`savings_account_transaction_id`),
  KEY `FK__m_savings_account_charge` (`savings_account_charge_id`),
  CONSTRAINT `FK__m_savings_account_charge` FOREIGN KEY (`savings_account_charge_id`) REFERENCES `m_savings_account_charge` (`id`),
  CONSTRAINT `FK__m_savings_account_transaction` FOREIGN KEY (`savings_account_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_account_interest_rate_chart
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account_interest_rate_chart`;

CREATE TABLE `m_savings_account_interest_rate_chart` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `from_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_primary_grouping_by_amount` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FKSAIRC00000000000001` (`savings_account_id`),
  CONSTRAINT `FKSAIRC00000000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_account_interest_rate_slab
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account_interest_rate_slab`;

CREATE TABLE `m_savings_account_interest_rate_slab` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_interest_rate_chart_id` bigint(20) NOT NULL,
  `description` varchar(200) DEFAULT NULL,
  `period_type_enum` smallint(5) DEFAULT NULL,
  `from_period` int(11) DEFAULT NULL,
  `to_period` int(11) DEFAULT NULL,
  `amount_range_from` decimal(19,6) DEFAULT NULL,
  `amount_range_to` decimal(19,6) DEFAULT NULL,
  `annual_interest_rate` decimal(19,6) NOT NULL,
  `currency_code` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKSAIRS00000000000001` (`savings_account_interest_rate_chart_id`),
  CONSTRAINT `FKSAIRS00000000000001` FOREIGN KEY (`savings_account_interest_rate_chart_id`) REFERENCES `m_savings_account_interest_rate_chart` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_account_transaction
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account_transaction`;

CREATE TABLE `m_savings_account_transaction` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_account_id` bigint(20) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `payment_detail_id` bigint(20) DEFAULT NULL,
  `transaction_type_enum` smallint(5) NOT NULL,
  `is_reversed` tinyint(1) NOT NULL,
  `transaction_date` date NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `overdraft_amount_derived` decimal(19,6) DEFAULT NULL,
  `balance_end_date_derived` date DEFAULT NULL,
  `balance_number_of_days_derived` int(11) DEFAULT NULL,
  `running_balance_derived` decimal(19,6) DEFAULT NULL,
  `cumulative_balance_derived` decimal(19,6) DEFAULT NULL,
  `created_date` datetime NOT NULL,
  `appuser_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKSAT0000000001` (`savings_account_id`),
  KEY `FK_m_savings_account_transaction_m_payment_detail` (`payment_detail_id`),
  KEY `FK_m_savings_account_transaction_m_office` (`office_id`),
  CONSTRAINT `FKSAT0000000001` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `FK_m_savings_account_transaction_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`),
  CONSTRAINT `FK_m_savings_account_transaction_m_payment_detail` FOREIGN KEY (`payment_detail_id`) REFERENCES `m_payment_detail` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_account_transaction_tax_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_account_transaction_tax_details`;

CREATE TABLE `m_savings_account_transaction_tax_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `savings_transaction_id` bigint(20) NOT NULL,
  `tax_component_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_savings_account_transaction_tax_details_savings_transaction` (`savings_transaction_id`),
  KEY `FK_savings_account_transaction_tax_details_tax_component` (`tax_component_id`),
  CONSTRAINT `FK_savings_account_transaction_tax_details_savings_transaction` FOREIGN KEY (`savings_transaction_id`) REFERENCES `m_savings_account_transaction` (`id`),
  CONSTRAINT `FK_savings_account_transaction_tax_details_tax_component` FOREIGN KEY (`tax_component_id`) REFERENCES `m_tax_component` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_savings_interest_incentives
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_interest_incentives`;

CREATE TABLE `m_savings_interest_incentives` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `deposit_account_interest_rate_slab_id` bigint(20) NOT NULL,
  `entiry_type` smallint(2) NOT NULL,
  `attribute_name` smallint(2) NOT NULL,
  `condition_type` smallint(2) NOT NULL,
  `attribute_value` varchar(50) NOT NULL,
  `incentive_type` smallint(2) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_savings_interest_incentives_m_savings_interest_rate_slab` (`deposit_account_interest_rate_slab_id`),
  CONSTRAINT `FK_m_savings_interest_incentives_m_savings_interest_rate_slab` FOREIGN KEY (`deposit_account_interest_rate_slab_id`) REFERENCES `m_savings_account_interest_rate_slab` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_savings_officer_assignment_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_officer_assignment_history`;

CREATE TABLE `m_savings_officer_assignment_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `savings_officer_id` bigint(20) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_m_savings_officer_assignment_history_0001` (`account_id`),
  KEY `fk_m_savings_officer_assignment_history_0002` (`savings_officer_id`),
  CONSTRAINT `fk_m_savings_officer_assignment_history_0001` FOREIGN KEY (`account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `fk_m_savings_officer_assignment_history_0002` FOREIGN KEY (`savings_officer_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_product
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_product`;

CREATE TABLE `m_savings_product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `short_name` varchar(4) NOT NULL,
  `description` varchar(500) NOT NULL,
  `deposit_type_enum` smallint(5) NOT NULL DEFAULT '100',
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `nominal_annual_interest_rate` decimal(19,6) NOT NULL,
  `interest_compounding_period_enum` smallint(5) NOT NULL,
  `interest_posting_period_enum` smallint(5) NOT NULL DEFAULT '4',
  `interest_calculation_type_enum` smallint(5) NOT NULL,
  `interest_calculation_days_in_year_type_enum` smallint(5) NOT NULL,
  `min_required_opening_balance` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency_enum` smallint(5) DEFAULT NULL,
  `accounting_type` smallint(5) NOT NULL,
  `withdrawal_fee_amount` decimal(19,6) DEFAULT NULL,
  `withdrawal_fee_type_enum` smallint(5) DEFAULT NULL,
  `withdrawal_fee_for_transfer` tinyint(4) DEFAULT '1',
  `allow_overdraft` tinyint(1) NOT NULL DEFAULT '0',
  `overdraft_limit` decimal(19,6) DEFAULT NULL,
  `nominal_annual_interest_rate_overdraft` decimal(19,6) DEFAULT '0.000000',
  `min_overdraft_for_interest_calculation` decimal(19,6) DEFAULT '0.000000',
  `min_required_balance` decimal(19,6) DEFAULT NULL,
  `enforce_min_required_balance` tinyint(1) NOT NULL DEFAULT '0',
  `min_balance_for_interest_calculation` decimal(19,6) DEFAULT NULL,
  `withhold_tax` tinyint(4) NOT NULL DEFAULT '0',
  `tax_group_id` bigint(20) DEFAULT NULL,
  `is_dormancy_tracking_active` smallint(1) DEFAULT NULL,
  `days_to_inactive` int(11) DEFAULT NULL,
  `days_to_dormancy` int(11) DEFAULT NULL,
  `days_to_escheat` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sp_unq_name` (`name`),
  UNIQUE KEY `sp_unq_short_name` (`short_name`),
  KEY `FK_savings_product_tax_group` (`tax_group_id`),
  CONSTRAINT `FK_savings_product_tax_group` FOREIGN KEY (`tax_group_id`) REFERENCES `m_tax_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_savings_product_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_savings_product_charge`;

CREATE TABLE `m_savings_product_charge` (
  `savings_product_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  PRIMARY KEY (`savings_product_id`,`charge_id`),
  KEY `charge_id` (`charge_id`),
  CONSTRAINT `m_savings_product_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_savings_product_charge_ibfk_2` FOREIGN KEY (`savings_product_id`) REFERENCES `m_savings_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_selfservice_beneficiaries_tpt
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_selfservice_beneficiaries_tpt`;

CREATE TABLE `m_selfservice_beneficiaries_tpt` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `app_user_id` bigint(20) NOT NULL,
  `name` varchar(50) NOT NULL,
  `office_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `account_type` smallint(4) NOT NULL,
  `transfer_limit` bigint(20) DEFAULT '0',
  `is_active` bit(1) NOT NULL DEFAULT b'0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`,`app_user_id`,`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_selfservice_user_client_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_selfservice_user_client_mapping`;

CREATE TABLE `m_selfservice_user_client_mapping` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `appuser_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `appuser_id_client_id` (`appuser_id`,`client_id`),
  KEY `m_selfservice_client_id` (`client_id`),
  CONSTRAINT `m_selfservice_appuser_id` FOREIGN KEY (`appuser_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_selfservice_client_id` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_share_account
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_account`;

CREATE TABLE `m_share_account` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_no` varchar(50) NOT NULL,
  `product_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `status_enum` smallint(5) NOT NULL DEFAULT '300',
  `total_approved_shares` bigint(20) DEFAULT NULL,
  `total_pending_shares` bigint(20) DEFAULT NULL,
  `submitted_date` date NOT NULL,
  `submitted_userid` bigint(20) DEFAULT NULL,
  `approved_date` date DEFAULT NULL,
  `approved_userid` bigint(20) DEFAULT NULL,
  `rejected_date` date DEFAULT NULL,
  `rejected_userid` bigint(20) DEFAULT NULL,
  `activated_date` date DEFAULT NULL,
  `activated_userid` bigint(20) DEFAULT NULL,
  `closed_date` date DEFAULT NULL,
  `closed_userid` bigint(20) DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `savings_account_id` bigint(20) NOT NULL,
  `minimum_active_period_frequency` decimal(19,6) DEFAULT NULL,
  `minimum_active_period_frequency_enum` smallint(5) DEFAULT NULL,
  `lockin_period_frequency` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency_enum` smallint(5) DEFAULT NULL,
  `allow_dividends_inactive_clients` smallint(1) DEFAULT '0',
  `created_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `m_share_account_ibfk_1` (`product_id`),
  KEY `m_share_account_ibfk_2` (`savings_account_id`),
  KEY `m_share_account_ibfk_3` (`submitted_userid`),
  KEY `m_share_account_ibfk_4` (`approved_userid`),
  KEY `m_share_account_ibfk_5` (`rejected_userid`),
  KEY `m_share_account_ibfk_6` (`activated_userid`),
  KEY `m_share_account_ibfk_7` (`closed_userid`),
  KEY `m_share_account_ibfk_8` (`lastmodifiedby_id`),
  KEY `m_share_account_ibfk_9` (`client_id`),
  CONSTRAINT `m_share_account_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `m_share_product` (`id`),
  CONSTRAINT `m_share_account_ibfk_2` FOREIGN KEY (`savings_account_id`) REFERENCES `m_savings_account` (`id`),
  CONSTRAINT `m_share_account_ibfk_3` FOREIGN KEY (`submitted_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_account_ibfk_4` FOREIGN KEY (`approved_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_account_ibfk_5` FOREIGN KEY (`rejected_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_account_ibfk_6` FOREIGN KEY (`activated_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_account_ibfk_7` FOREIGN KEY (`closed_userid`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_account_ibfk_8` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_account_ibfk_9` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_account_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_account_charge`;

CREATE TABLE `m_share_account_charge` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  `charge_time_enum` smallint(5) NOT NULL,
  `charge_calculation_enum` smallint(5) NOT NULL,
  `charge_payment_mode_enum` smallint(5) NOT NULL DEFAULT '0',
  `calculation_percentage` decimal(19,6) DEFAULT NULL,
  `calculation_on_amount` decimal(19,6) DEFAULT NULL,
  `charge_amount_or_percentage` decimal(19,6) DEFAULT NULL,
  `amount` decimal(19,6) NOT NULL,
  `amount_paid_derived` decimal(19,6) DEFAULT NULL,
  `amount_waived_derived` decimal(19,6) DEFAULT NULL,
  `amount_writtenoff_derived` decimal(19,6) DEFAULT NULL,
  `amount_outstanding_derived` decimal(19,6) NOT NULL DEFAULT '0.000000',
  `is_paid_derived` tinyint(1) NOT NULL DEFAULT '0',
  `waived` tinyint(1) NOT NULL DEFAULT '0',
  `min_cap` decimal(19,6) DEFAULT NULL,
  `max_cap` decimal(19,6) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `charge_id` (`charge_id`),
  KEY `m_share_account_charge_ibfk_2` (`account_id`),
  CONSTRAINT `m_share_account_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_share_account_charge_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `m_share_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_account_charge_paid_by
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_account_charge_paid_by`;

CREATE TABLE `m_share_account_charge_paid_by` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `share_transaction_id` bigint(20) DEFAULT NULL,
  `charge_transaction_id` bigint(20) DEFAULT NULL,
  `amount` decimal(20,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `m_share_account_transactions_charge_mapping_ibfk1` (`share_transaction_id`),
  KEY `m_share_account_transactions_charge_mapping_ibfk2` (`charge_transaction_id`),
  CONSTRAINT `m_share_account_transactions_charge_mapping_ibfk1` FOREIGN KEY (`share_transaction_id`) REFERENCES `m_share_account_transactions` (`id`),
  CONSTRAINT `m_share_account_transactions_charge_mapping_ibfk2` FOREIGN KEY (`charge_transaction_id`) REFERENCES `m_share_account_charge` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_account_dividend_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_account_dividend_details`;

CREATE TABLE `m_share_account_dividend_details` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dividend_pay_out_id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `status` smallint(3) NOT NULL,
  `savings_transaction_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_share_account_dividend_details_dividend_pay_out_id` (`dividend_pay_out_id`),
  KEY `FK_m_share_account_dividend_details_account_id` (`account_id`),
  CONSTRAINT `FK_m_share_account_dividend_details_account_id` FOREIGN KEY (`account_id`) REFERENCES `m_share_account` (`id`),
  CONSTRAINT `FK_m_share_account_dividend_details_dividend_pay_out_id` FOREIGN KEY (`dividend_pay_out_id`) REFERENCES `m_share_product_dividend_pay_out` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_account_transactions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_account_transactions`;

CREATE TABLE `m_share_account_transactions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` bigint(20) NOT NULL,
  `transaction_date` date DEFAULT NULL,
  `total_shares` bigint(20) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `amount` decimal(20,2) DEFAULT NULL,
  `charge_amount` decimal(20,2) DEFAULT NULL,
  `amount_paid` decimal(20,2) DEFAULT NULL,
  `status_enum` smallint(5) NOT NULL DEFAULT '300',
  `type_enum` smallint(5) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `m_share_account_purchased_shares_ibfk_1` (`account_id`),
  CONSTRAINT `m_share_account_purchased_shares_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `m_share_account` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_product
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_product`;

CREATE TABLE `m_share_product` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `short_name` varchar(4) NOT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `description` varchar(500) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `currency_code` varchar(3) NOT NULL,
  `currency_digits` smallint(5) NOT NULL,
  `currency_multiplesof` smallint(5) DEFAULT NULL,
  `total_shares` bigint(20) NOT NULL,
  `issued_shares` bigint(20) DEFAULT NULL,
  `totalsubscribed_shares` bigint(20) DEFAULT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `capital_amount` decimal(20,2) NOT NULL,
  `minimum_client_shares` bigint(20) DEFAULT NULL,
  `nominal_client_shares` bigint(20) NOT NULL,
  `maximum_client_shares` bigint(20) DEFAULT NULL,
  `minimum_active_period_frequency` decimal(19,6) DEFAULT NULL,
  `minimum_active_period_frequency_enum` smallint(5) DEFAULT NULL,
  `lockin_period_frequency` decimal(19,6) DEFAULT NULL,
  `lockin_period_frequency_enum` smallint(5) DEFAULT NULL,
  `allow_dividends_inactive_clients` smallint(1) DEFAULT '0',
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `accounting_type` smallint(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `m_share_product_ibfk_1` (`createdby_id`),
  KEY `m_share_product_ibfk_2` (`lastmodifiedby_id`),
  CONSTRAINT `m_share_product_ibfk_1` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `m_share_product_ibfk_2` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_product_charge
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_product_charge`;

CREATE TABLE `m_share_product_charge` (
  `product_id` bigint(20) NOT NULL,
  `charge_id` bigint(20) NOT NULL,
  PRIMARY KEY (`product_id`,`charge_id`),
  KEY `m_share_product_charge_ibfk_1` (`charge_id`),
  CONSTRAINT `m_share_product_charge_ibfk_1` FOREIGN KEY (`charge_id`) REFERENCES `m_charge` (`id`),
  CONSTRAINT `m_share_product_charge_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `m_share_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_product_dividend_pay_out
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_product_dividend_pay_out`;

CREATE TABLE `m_share_product_dividend_pay_out` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `amount` decimal(19,6) NOT NULL,
  `dividend_period_start_date` date NOT NULL,
  `dividend_period_end_date` date NOT NULL,
  `status` smallint(3) NOT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_share_product_dividend_pay_out_product_id` (`product_id`),
  KEY `FK_m_share_product_dividend_pay_out_createdby_id` (`createdby_id`),
  KEY `FK_m_share_product_dividend_pay_out_lastmodifiedby_id` (`lastmodifiedby_id`),
  CONSTRAINT `FK_m_share_product_dividend_pay_out_createdby_id` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_share_product_dividend_pay_out_lastmodifiedby_id` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_m_share_product_dividend_pay_out_product_id` FOREIGN KEY (`product_id`) REFERENCES `m_share_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_share_product_market_price
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_share_product_market_price`;

CREATE TABLE `m_share_product_market_price` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) NOT NULL,
  `from_date` date DEFAULT NULL,
  `share_value` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `m_share_product_market_price_ibfk_1` (`product_id`),
  CONSTRAINT `m_share_product_market_price_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `m_share_product` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_staff
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_staff`;

CREATE TABLE `m_staff` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `is_loan_officer` tinyint(1) NOT NULL DEFAULT '0',
  `office_id` bigint(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `display_name` varchar(102) NOT NULL,
  `mobile_no` varchar(50) DEFAULT NULL,
  `external_id` varchar(100) DEFAULT NULL,
  `organisational_role_enum` smallint(6) DEFAULT NULL,
  `organisational_role_parent_staff_id` bigint(20) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `joining_date` date DEFAULT NULL,
  `image_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `display_name` (`display_name`),
  UNIQUE KEY `external_id_UNIQUE` (`external_id`),
  UNIQUE KEY `mobile_no_UNIQUE` (`mobile_no`),
  KEY `FK_m_staff_m_office` (`office_id`),
  KEY `FK_m_staff_m_image` (`image_id`),
  CONSTRAINT `FK_m_staff_m_image` FOREIGN KEY (`image_id`) REFERENCES `m_image` (`id`),
  CONSTRAINT `FK_m_staff_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_staff_assignment_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_staff_assignment_history`;

CREATE TABLE `m_staff_assignment_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `centre_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `createdby_id` bigint(20) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `lastmodified_date` datetime DEFAULT NULL,
  `lastmodifiedby_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_m_staff_assignment_history_centre_id_m_group` (`centre_id`),
  KEY `FK_m_staff_assignment_history_m_staff` (`staff_id`),
  CONSTRAINT `FK_m_staff_assignment_history_centre_id_m_group` FOREIGN KEY (`centre_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FK_m_staff_assignment_history_m_staff` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_survey_components
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_survey_components`;

CREATE TABLE `m_survey_components` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(20) NOT NULL,
  `a_key` varchar(32) NOT NULL,
  `a_text` varchar(255) NOT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `sequence_no` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_id` (`survey_id`),
  CONSTRAINT `m_survey_components_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `m_surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_survey_lookup_tables
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_survey_lookup_tables`;

CREATE TABLE `m_survey_lookup_tables` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(20) NOT NULL,
  `a_key` varchar(255) NOT NULL,
  `description` int(4) DEFAULT NULL,
  `value_from` int(4) NOT NULL,
  `value_to` int(4) NOT NULL,
  `score` decimal(5,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_id` (`survey_id`),
  CONSTRAINT `m_survey_lookup_tables_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `m_surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_survey_questions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_survey_questions`;

CREATE TABLE `m_survey_questions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(20) NOT NULL,
  `component_key` varchar(32) DEFAULT NULL,
  `a_key` varchar(32) NOT NULL,
  `a_text` varchar(255) NOT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `sequence_no` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_id` (`survey_id`),
  CONSTRAINT `m_survey_questions_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `m_surveys` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_survey_responses
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_survey_responses`;

CREATE TABLE `m_survey_responses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL,
  `a_text` varchar(255) NOT NULL,
  `a_value` int(4) NOT NULL,
  `sequence_no` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `question_id` (`question_id`),
  CONSTRAINT `m_survey_responses_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `m_survey_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_survey_scorecards
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_survey_scorecards`;

CREATE TABLE `m_survey_scorecards` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `survey_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `response_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `client_id` bigint(20) NOT NULL,
  `created_on` datetime DEFAULT NULL,
  `a_value` int(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `survey_id` (`survey_id`),
  KEY `question_id` (`question_id`),
  KEY `response_id` (`response_id`),
  KEY `user_id` (`user_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `m_survey_scorecards_ibfk_1` FOREIGN KEY (`survey_id`) REFERENCES `m_surveys` (`id`),
  CONSTRAINT `m_survey_scorecards_ibfk_2` FOREIGN KEY (`question_id`) REFERENCES `m_survey_questions` (`id`),
  CONSTRAINT `m_survey_scorecards_ibfk_3` FOREIGN KEY (`response_id`) REFERENCES `m_survey_responses` (`id`),
  CONSTRAINT `m_survey_scorecards_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `m_appusers` (`id`),
  CONSTRAINT `m_survey_scorecards_ibfk_5` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_surveys
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_surveys`;

CREATE TABLE `m_surveys` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `a_key` varchar(32) NOT NULL,
  `a_name` varchar(255) NOT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `country_code` varchar(2) NOT NULL,
  `valid_from` datetime DEFAULT NULL,
  `valid_to` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_tax_component
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_tax_component`;

CREATE TABLE `m_tax_component` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `percentage` decimal(19,6) NOT NULL,
  `debit_account_type_enum` smallint(2) DEFAULT NULL,
  `debit_account_id` bigint(20) DEFAULT NULL,
  `credit_account_type_enum` smallint(2) DEFAULT NULL,
  `credit_account_id` bigint(20) DEFAULT NULL,
  `start_date` date NOT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tax_component_debit_gl_account` (`debit_account_id`),
  KEY `FK_tax_component_credit_gl_account` (`credit_account_id`),
  KEY `FK_tax_component_createdby` (`createdby_id`),
  KEY `FK_tax_component_lastmodifiedby` (`lastmodifiedby_id`),
  CONSTRAINT `FK_tax_component_createdby` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_tax_component_credit_gl_account` FOREIGN KEY (`credit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_tax_component_debit_gl_account` FOREIGN KEY (`debit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_tax_component_lastmodifiedby` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_tax_component_history
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_tax_component_history`;

CREATE TABLE `m_tax_component_history` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tax_component_id` bigint(20) NOT NULL,
  `percentage` decimal(19,6) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tax_component_history_tax_component_id` (`tax_component_id`),
  KEY `FK_tax_component_history_createdby` (`createdby_id`),
  KEY `FK_tax_component_history_lastmodifiedby` (`lastmodifiedby_id`),
  CONSTRAINT `FK_tax_component_history_createdby` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_tax_component_history_lastmodifiedby` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_tax_component_history_tax_component_id` FOREIGN KEY (`tax_component_id`) REFERENCES `m_tax_component` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_tax_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_tax_group`;

CREATE TABLE `m_tax_group` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tax_group_createdby` (`createdby_id`),
  KEY `FK_tax_group_lastmodifiedby` (`lastmodifiedby_id`),
  CONSTRAINT `FK_tax_group_createdby` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_tax_group_lastmodifiedby` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_tax_group_mappings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_tax_group_mappings`;

CREATE TABLE `m_tax_group_mappings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tax_group_id` bigint(20) NOT NULL,
  `tax_component_id` bigint(20) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `createdby_id` bigint(20) NOT NULL,
  `created_date` datetime NOT NULL,
  `lastmodifiedby_id` bigint(20) NOT NULL,
  `lastmodified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_tax_group_mappings_tax_group` (`tax_group_id`),
  KEY `FK_tax_group_mappings_tax_component` (`tax_component_id`),
  KEY `FK_tax_group_mappings_createdby` (`createdby_id`),
  KEY `FK_tax_group_mappings_lastmodifiedby` (`lastmodifiedby_id`),
  CONSTRAINT `FK_tax_group_mappings_createdby` FOREIGN KEY (`createdby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_tax_group_mappings_lastmodifiedby` FOREIGN KEY (`lastmodifiedby_id`) REFERENCES `m_appuser` (`id`),
  CONSTRAINT `FK_tax_group_mappings_tax_component` FOREIGN KEY (`tax_component_id`) REFERENCES `m_tax_component` (`id`),
  CONSTRAINT `FK_tax_group_mappings_tax_group` FOREIGN KEY (`tax_group_id`) REFERENCES `m_tax_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_tellers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_tellers`;

CREATE TABLE `m_tellers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `office_id` bigint(20) NOT NULL,
  `debit_account_id` bigint(20) DEFAULT NULL,
  `credit_account_id` bigint(20) DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `state` smallint(5) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `m_tellers_name_unq` (`name`),
  KEY `IK_m_tellers_m_office` (`office_id`),
  KEY `FK_m_tellers_gl_account_debit_account_id` (`debit_account_id`),
  KEY `FK_m_tellers_gl_account_credit_account_id` (`credit_account_id`),
  CONSTRAINT `FK_m_tellers_gl_account_credit_account_id` FOREIGN KEY (`credit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_m_tellers_gl_account_debit_account_id` FOREIGN KEY (`debit_account_id`) REFERENCES `acc_gl_account` (`id`),
  CONSTRAINT `FK_m_tellers_m_office` FOREIGN KEY (`office_id`) REFERENCES `m_office` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;



# Dump of table m_template
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_template`;

CREATE TABLE `m_template` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `text` longtext CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `entity` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_template_m_templatemappers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_template_m_templatemappers`;

CREATE TABLE `m_template_m_templatemappers` (
  `m_template_id` bigint(20) NOT NULL,
  `mappers_id` bigint(20) NOT NULL,
  UNIQUE KEY `mappers_id` (`mappers_id`),
  KEY `mappers_id_2` (`mappers_id`),
  KEY `m_template_id` (`m_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_templatemappers
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_templatemappers`;

CREATE TABLE `m_templatemappers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `mapperkey` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `mapperorder` int(11) DEFAULT NULL,
  `mappervalue` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table m_working_days
# ------------------------------------------------------------

DROP TABLE IF EXISTS `m_working_days`;

CREATE TABLE `m_working_days` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `recurrence` varchar(100) DEFAULT NULL,
  `repayment_rescheduling_enum` smallint(5) DEFAULT NULL,
  `extend_term_daily_repayments` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `m_working_days` WRITE;
/*!40000 ALTER TABLE `m_working_days` DISABLE KEYS */;

INSERT INTO `m_working_days` (`id`, `recurrence`, `repayment_rescheduling_enum`, `extend_term_daily_repayments`)
VALUES
	(1,'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR,SA,SU',2,0);

/*!40000 ALTER TABLE `m_working_days` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table mix_taxonomy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mix_taxonomy`;

CREATE TABLE `mix_taxonomy` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `namespace_id` int(11) DEFAULT NULL,
  `dimension` varchar(100) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `need_mapping` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `mix_taxonomy` WRITE;
/*!40000 ALTER TABLE `mix_taxonomy` DISABLE KEYS */;

INSERT INTO `mix_taxonomy` (`id`, `name`, `namespace_id`, `dimension`, `type`, `description`, `need_mapping`)
VALUES
	(1,'AdministrativeExpense',1,NULL,3,NULL,1),
	(2,'Assets',3,NULL,1,'All outstanding principals due for all outstanding client loans. This includes current, delinquent, and renegotiated loans, but not loans that have been written off. It does not include interest receivable.',1),
	(3,'Assets',3,'MaturityDimension:LessThanOneYearMember',1,'Segmentation based on the life of an asset or liability.',1),
	(4,'Assets',3,'MaturityDimension:MoreThanOneYearMember',1,'Segmentation based on the life of an asset or liability.',1),
	(5,'CashAndCashEquivalents',1,NULL,1,NULL,1),
	(6,'Deposits',3,NULL,1,'The total value of funds placed in an account with an MFI that are payable to a depositor. This item includes any current, checking, or savings accounts that are payable on demand. It also includes time deposits which have a fixed maturity date and compulsory deposits.',1),
	(7,'Deposits',3,'DepositProductsDimension:CompulsoryMember',1,'The value of deposits that an MFI\'s clients are required to  maintain as a condition of an existing or future loan.',NULL),
	(8,'Deposits',3,'DepositProductsDimension:VoluntaryMember',1,'The value of deposits that an MFI\'s clients are not required to  maintain as a condition of an existing or future loan.',NULL),
	(9,'Deposits',3,'LocationDimension:RuralMember',1,'Located in rural areas. Segmentation based on location.',NULL),
	(10,'Deposits',3,'LocationDimension:UrbanMember',1,'Located in urban areas. Segmentation based on location.',NULL),
	(11,'Deposits',3,'MaturityDimension:LessThanOneYearMember',1,'Segmentation based on the life of an asset or liability.',NULL),
	(12,'Deposits',3,'MaturityDimension:MoreThanOneYearMember',1,'Segmentation based on the life of an asset or liability.',NULL),
	(13,'EmployeeBenefitsExpense',1,NULL,3,NULL,NULL),
	(14,'Equity',1,NULL,1,NULL,NULL),
	(15,'Expense',1,NULL,3,NULL,NULL),
	(16,'FinancialExpense',3,NULL,3,'All costs All costs incurred in raising funds from third parties, fee expenses from non-financial services, net gains (losses) due to changes in fair value of financial liabilities, impairment losses net of reversals of financial assets other than loan portfolio and net gains (losses) from restatement of financial statements in terms of the measuring unit current at the end of the reporting period.',NULL),
	(17,'FinancialRevenueOnLoans',3,NULL,2,'Interest and non-interest income generated by the provision of credit services to the clients. Fees and commissions for late payment are also included.',NULL),
	(18,'ImpairmentLossAllowanceGrossLoanPortfolio',3,NULL,2,'An allowance for the risk of losses in the gross loan portfolio due to default .',NULL),
	(19,'Liabilities',1,NULL,1,NULL,NULL),
	(20,'Liabilities',3,'MaturityDimension:LessThanOneYearMember',1,'Segmentation based on the life of an asset or liability.',NULL),
	(21,'Liabilities',3,'MaturityDimension:MoreThanOneYearMember',1,'Segmentation based on the life of an asset or liability.',NULL),
	(22,'LoanPortfolioGross',3,NULL,2,'All outstanding principals due for all outstanding client loans. This includes current, delinquent, and renegotiated loans, but not loans that have been written off. It does not include interest receivable.',NULL),
	(23,'LoanPortfolioGross',3,'CreditProductsDimension:MicroenterpriseMember',2,'Loans that finance the production or trade of goods and  services for an individual\'s microenterprise, whether or not the microenterprise is legally registered. Segmentation based on loan product.',NULL),
	(24,'LoanPortfolioGross',3,'DelinquencyDimension:OneMonthOrMoreMember',2,'Segmentation based on the principal balance of all loans outstanding that have one or more installments of principal  past due or renegotiated. Segmentation based on the  principal balance of all loans outstanding that have one or  more installments of principal past due or renegotiated.',NULL),
	(25,'LoanPortfolioGross',3,'DelinquencyDimension:ThreeMonthsOrMoreMember',2,'Segmentation based on the principal balance of all loans outstanding that have one or more installments of principal  past due or renegotiated.? Segmentation based on the  principal balance of all loans outstanding that have one or  more installments of principal past due or renegotiated.',NULL),
	(26,'LoanPortfolioGross',3,'LocationDimension:RuralMember',2,'Located in rural areas. Segmentation based on geographic location.',NULL),
	(27,'LoanPortfolioGross',3,'LocationDimension:UrbanMember',2,'Located in urbal areas. Segmentation based on geographic location.',NULL),
	(28,'LoanPortfolioGross',3,'MaturityDimension:LessThanOneYearMember',2,'Segmentation based on the life of an asset or liability.',NULL),
	(29,'LoanPortfolioGross',3,'MaturityDimension:MoreThanOneYearMember',2,'Segmentation based on the life of an asset or liability.',NULL),
	(30,'NetLoanLoss',3,'',3,'Referred to the value of delinquency loans written off net of any principal recovery.',NULL),
	(31,'NetLoanLossProvisionExpense',3,NULL,3,'Represent the net value of loan portfolio impairment loss considering any reversal on impairment loss and any recovery on loans written off recognized as a income during the accounting period.',NULL),
	(32,'NetOperatingIncome',3,NULL,2,'Total operating revenue less all expenses related to the MFI\'s core financial service operation including total financial expense, impairment loss and operating expense. Donations are excluded.',NULL),
	(33,'NetOperatingIncomeNetOfTaxExpense',3,NULL,3,'Net operating income reported incorporating the effect of taxes. Taxes include all domestic and foreign taxes which are based on taxable profits, other taxes related to personnel, financial transactions or value-added taxes are not considered in calculation of this value.',NULL),
	(34,'NumberOfActiveBorrowers',3,NULL,0,'The number of individuals who currently have an outstanding loan balance with the MFI or are primarily responsible for repaying any portion of the gross loan portfolio. Individuals who have multiple loans with an MFI should be counted as a single borrower.',NULL),
	(35,'NumberOfActiveBorrowers',3,'GenderDimension:FemaleMember',0,'The number of individuals who currently have an outstanding loan balance with the MFI or are primarily responsible for repaying any portion of the gross loan portfolio. Individuals who have multiple loans with an MFI should be counted as a single borrower.',NULL),
	(36,'NumberOfBoardMembers',3,'GenderDimension:FemaleMember',0,'The number of members that comprise the board of directors at the end of the reporting period who are female.',NULL),
	(37,'NumberOfDepositAccounts',3,NULL,0,'The number of individuals who currently have funds on deposit with the MFI on a voluntary basis; i.e., they are not required to maintain the deposit account to access a loan. This number applies only to deposits held by an MFI, not to those deposits held in other institutions by the MFI\'s clients. The number should be based on the number of individuals rather than the number of groups. A single deposit account may represent multiple depositors.',NULL),
	(38,'NumberOfDepositors',3,'',0,'The number of deposit accounts, both voluntary and compulsory, opened at the MFI whose balances the institution is liable to repay. The number should be based on the number of individual accounts rather than on the number of groups.',NULL),
	(39,'NumberOfEmployees',3,NULL,0,'The number of individuals who are actively employed by an entity. This number includes contract employees or advisors who dedicate a substantial portion of their time to the entity, even if they are not on the entity\'s employees roster.',NULL),
	(40,'NumberOfEmployees',3,'GenderDimension:FemaleMember',0,'The number of individuals who are actively employed by an entity. This number includes contract employees or advisors who dedicate a substantial portion of their time to the entity, even if they are not on the entity\'s employees roster.',NULL),
	(41,'NumberOfLoanOfficers',3,NULL,0,'The number of employees whose main activity is to manage a portion of the gross loan portfolio. A loan officer is a staff member of record who is directly responsible for arranging and monitoring client loans.',NULL),
	(42,'NumberOfLoanOfficers',3,'GenderDimension:FemaleMember',0,'The number of employees whose main activity is to manage a portion of the gross loan portfolio. A loan officer is a staff member of record who is directly responsible for arranging and monitoring client loans.',NULL),
	(43,'NumberOfManagers',3,'GenderDimension:FemaleMember',0,'The number of members that comprise the management of the institution who are female.',NULL),
	(44,'NumberOfOffices',3,NULL,0,'The number of staffed points of service and administrative sites used to deliver or support the delivery of financial services to microfinance clients.',NULL),
	(45,'NumberOfOutstandingLoans',3,NULL,0,'The number of loans in the gross loan portfolio. For MFIs using a group lending methodology, the number of loans should refer to the number of individuals receiving loans as part of a group or as part of a group loan.',NULL),
	(46,'OperatingExpense',3,NULL,3,'Includes expenses not related to financial and credit loss impairment, such as personnel expenses, depreciation, amortization and administrative expenses.',NULL),
	(47,'OperatingIncome',3,NULL,2,'Includes all financial income and other operating revenue which is generated from non-financial services. Operating income also includes net gains (losses) from holding financial assets (changes on their values during the period and foreign exchange differences). Donations or any revenue not related with an MFI\'s core business of making loans and providing financial services are not considered under this category.',NULL),
	(48,'WriteOffsOnGrossLoanPortfolio',3,NULL,2,'The value of loans that have been recognized as uncollectible for accounting purposes. A write-off is an accounting procedure that removes the outstanding balance of the loan from the gross loan portfolio and impairment loss allowance. Thus, the write-off does not affect the net loan portfolio, total assets, or any equity account. If the impairment loss allowance is insufficient to cover the amount written off, the excess amount will result in an additional impairment loss on loans recognised in profit or loss of the period.',NULL);

/*!40000 ALTER TABLE `mix_taxonomy` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table mix_taxonomy_mapping
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mix_taxonomy_mapping`;

CREATE TABLE `mix_taxonomy_mapping` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL DEFAULT '',
  `config` varchar(200) DEFAULT NULL,
  `last_update_date` datetime DEFAULT NULL,
  `currency` varchar(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `mix_taxonomy_mapping` WRITE;
/*!40000 ALTER TABLE `mix_taxonomy_mapping` DISABLE KEYS */;

INSERT INTO `mix_taxonomy_mapping` (`id`, `identifier`, `config`, `last_update_date`, `currency`)
VALUES
	(1,'default',NULL,NULL,'');

/*!40000 ALTER TABLE `mix_taxonomy_mapping` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table mix_xbrl_namespace
# ------------------------------------------------------------

DROP TABLE IF EXISTS `mix_xbrl_namespace`;

CREATE TABLE `mix_xbrl_namespace` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `prefix` varchar(20) NOT NULL DEFAULT '',
  `url` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNQUE` (`prefix`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `mix_xbrl_namespace` WRITE;
/*!40000 ALTER TABLE `mix_xbrl_namespace` DISABLE KEYS */;

INSERT INTO `mix_xbrl_namespace` (`id`, `prefix`, `url`)
VALUES
	(1,'ifrs','http://xbrl.iasb.org/taxonomy/2009-04-01/ifrs'),
	(2,'iso4217','http://www.xbrl.org/2003/iso4217'),
	(3,'mix','http://www.themix.org/int/fr/ifrs/basi/YYYY-MM-DD/mx-cor'),
	(4,'xbrldi','http://xbrl.org/2006/xbrldi'),
	(5,'xbrli','http://www.xbrl.org/2003/instance'),
	(6,'link','http://www.xbrl.org/2003/linkbase'),
	(7,'dc-all','http://www.themix.org/int/fr/ifrs/basi/2010-08-31/dc-all');

/*!40000 ALTER TABLE `mix_xbrl_namespace` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauth_access_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_access_token`;

CREATE TABLE `oauth_access_token` (
  `token_id` varchar(256) DEFAULT NULL,
  `token` blob,
  `authentication_id` varchar(256) DEFAULT NULL,
  `user_name` varchar(256) DEFAULT NULL,
  `client_id` varchar(256) DEFAULT NULL,
  `authentication` blob,
  `refresh_token` varchar(256) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table oauth_client_details
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_client_details`;

CREATE TABLE `oauth_client_details` (
  `client_id` varchar(128) NOT NULL,
  `resource_ids` varchar(256) DEFAULT NULL,
  `client_secret` varchar(256) DEFAULT NULL,
  `scope` varchar(256) DEFAULT NULL,
  `authorized_grant_types` varchar(256) DEFAULT NULL,
  `web_server_redirect_uri` varchar(256) DEFAULT NULL,
  `authorities` varchar(256) DEFAULT NULL,
  `access_token_validity` int(11) DEFAULT NULL,
  `refresh_token_validity` int(11) DEFAULT NULL,
  `additional_information` varchar(4096) DEFAULT NULL,
  `autoapprove` bit(1) DEFAULT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `oauth_client_details` WRITE;
/*!40000 ALTER TABLE `oauth_client_details` DISABLE KEYS */;

INSERT INTO `oauth_client_details` (`client_id`, `resource_ids`, `client_secret`, `scope`, `authorized_grant_types`, `web_server_redirect_uri`, `authorities`, `access_token_validity`, `refresh_token_validity`, `additional_information`, `autoapprove`)
VALUES
	('community-app',NULL,'123','all','password,refresh_token',NULL,NULL,NULL,NULL,NULL,NULL);

/*!40000 ALTER TABLE `oauth_client_details` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table oauth_refresh_token
# ------------------------------------------------------------

DROP TABLE IF EXISTS `oauth_refresh_token`;

CREATE TABLE `oauth_refresh_token` (
  `token_id` varchar(256) DEFAULT NULL,
  `token` blob,
  `authentication` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ppi_likelihoods
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ppi_likelihoods`;

CREATE TABLE `ppi_likelihoods` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) NOT NULL,
  `name` varchar(250) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ppi_likelihoods_ppi
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ppi_likelihoods_ppi`;

CREATE TABLE `ppi_likelihoods_ppi` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `likelihood_id` bigint(20) NOT NULL,
  `ppi_name` varchar(250) NOT NULL,
  `enabled` int(11) NOT NULL DEFAULT '100',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table ppi_scores
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ppi_scores`;

CREATE TABLE `ppi_scores` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `score_from` int(11) NOT NULL,
  `score_to` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ppi_scores` WRITE;
/*!40000 ALTER TABLE `ppi_scores` DISABLE KEYS */;

INSERT INTO `ppi_scores` (`id`, `score_from`, `score_to`)
VALUES
	(1,0,4),
	(2,5,9),
	(3,10,14),
	(4,15,19),
	(5,20,24),
	(6,25,29),
	(7,30,34),
	(8,35,39),
	(9,40,44),
	(10,45,49),
	(11,50,54),
	(12,55,59),
	(13,60,64),
	(14,65,69),
	(15,70,74),
	(16,75,79),
	(17,80,84),
	(18,85,89),
	(19,90,94),
	(20,95,100);

/*!40000 ALTER TABLE `ppi_scores` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table r_enum_value
# ------------------------------------------------------------

DROP TABLE IF EXISTS `r_enum_value`;

CREATE TABLE `r_enum_value` (
  `enum_name` varchar(100) NOT NULL,
  `enum_id` int(11) NOT NULL,
  `enum_message_property` varchar(100) NOT NULL,
  `enum_value` varchar(100) NOT NULL,
  `enum_type` tinyint(1) NOT NULL,
  PRIMARY KEY (`enum_name`,`enum_id`),
  UNIQUE KEY `enum_message_property` (`enum_name`,`enum_message_property`),
  UNIQUE KEY `enum_value` (`enum_name`,`enum_value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `r_enum_value` WRITE;
/*!40000 ALTER TABLE `r_enum_value` DISABLE KEYS */;

INSERT INTO `r_enum_value` (`enum_name`, `enum_id`, `enum_message_property`, `enum_value`, `enum_type`)
VALUES
	('account_type_type_enum',0,'INVALID','INVALID',0),
	('account_type_type_enum',1,'INDIVIDUAL','INDIVIDUAL',0),
	('account_type_type_enum',2,'GROUP','GROUP',0),
	('account_type_type_enum',3,'JLG','JLG',0),
	('accrual_accounts_for_loan_type_enum',1,'FUND_SOURCE','FUND_SOURCE',0),
	('accrual_accounts_for_loan_type_enum',2,'LOAN_PORTFOLIO','LOAN_PORTFOLIO',0),
	('accrual_accounts_for_loan_type_enum',3,'INTEREST_ON_LOANS','INTEREST_ON_LOANS',0),
	('accrual_accounts_for_loan_type_enum',4,'INCOME_FROM_FEES','INCOME_FROM_FEES',0),
	('accrual_accounts_for_loan_type_enum',5,'INCOME_FROM_PENALTIES','INCOME_FROM_PENALTIES',0),
	('accrual_accounts_for_loan_type_enum',6,'LOSSES_WRITTEN_OFF','LOSSES_WRITTEN_OFF',0),
	('accrual_accounts_for_loan_type_enum',7,'INTEREST_RECEIVABLE','INTEREST_RECEIVABLE',0),
	('accrual_accounts_for_loan_type_enum',8,'FEES_RECEIVABLE','FEES_RECEIVABLE',0),
	('accrual_accounts_for_loan_type_enum',9,'PENALTIES_RECEIVABLE','PENALTIES_RECEIVABLE',0),
	('accrual_accounts_for_loan_type_enum',10,'TRANSFERS_SUSPENSE','TRANSFERS_SUSPENSE',0),
	('accrual_accounts_for_loan_type_enum',11,'OVERPAYMENT','OVERPAYMENT',0),
	('accrual_accounts_for_loan_type_enum',12,'INCOME_FROM_RECOVERY','INCOME_FROM_RECOVERY',0),
	('amortization_method_enum',0,'Equal principle payments','Equal principle payments',0),
	('amortization_method_enum',1,'Equal installments','Equal installments',0),
	('calendar_type_enum',0,'INVALID','INVALID',0),
	('calendar_type_enum',1,'CLIENTS','CLIENTS',0),
	('calendar_type_enum',2,'GROUPS','GROUPS',0),
	('calendar_type_enum',3,'LOANS','LOANS',0),
	('calendar_type_enum',4,'CENTERS','CENTERS',0),
	('calendar_type_enum',5,'SAVINGS','SAVINGS',0),
	('calendar_type_enum',6,'LOAN_RECALCULATION_REST_DETAIL','LOAN_RECALCULATION_REST_DETAIL',0),
	('calendar_type_enum',7,'LOAN_RECALCULATION_COMPOUNDING_DETAIL','LOAN_RECALCULATION_COMPOUNDING_DETAIL',0),
	('cash_accounts_for_loan_type_enum',1,'FUND_SOURCE','FUND_SOURCE',0),
	('cash_accounts_for_loan_type_enum',2,'LOAN_PORTFOLIO','LOAN_PORTFOLIO',0),
	('cash_accounts_for_loan_type_enum',3,'INTEREST_ON_LOANS','INTEREST_ON_LOANS',0),
	('cash_accounts_for_loan_type_enum',4,'INCOME_FROM_FEES','INCOME_FROM_FEES',0),
	('cash_accounts_for_loan_type_enum',5,'INCOME_FROM_PENALTIES','INCOME_FROM_PENALTIES',0),
	('cash_accounts_for_loan_type_enum',6,'LOSSES_WRITTEN_OFF','LOSSES_WRITTEN_OFF',0),
	('cash_accounts_for_loan_type_enum',10,'TRANSFERS_SUSPENSE','TRANSFERS_SUSPENSE',0),
	('cash_accounts_for_loan_type_enum',11,'OVERPAYMENT','OVERPAYMENT',0),
	('cash_accounts_for_loan_type_enum',12,'INCOME_FROM_RECOVERY','INCOME_FROM_RECOVERY',0),
	('cash_accounts_for_savings_type_enum',1,'SAVINGS_REFERENCE','SAVINGS_REFERENCE',0),
	('cash_accounts_for_savings_type_enum',2,'SAVINGS_CONTROL','SAVINGS_CONTROL',0),
	('cash_accounts_for_savings_type_enum',3,'INTEREST_ON_SAVINGS','INTEREST_ON_SAVINGS',0),
	('cash_accounts_for_savings_type_enum',4,'INCOME_FROM_FEES','INCOME_FROM_FEES',0),
	('cash_accounts_for_savings_type_enum',5,'INCOME_FROM_PENALTIES','INCOME_FROM_PENALTIES',0),
	('cash_accounts_for_savings_type_enum',10,'TRANSFERS_SUSPENSE','TRANSFERS_SUSPENSE',0),
	('cash_accounts_for_savings_type_enum',11,'OVERDRAFT_PORTFOLIO_CONTROL','OVERDRAFT_PORTFOLIO_CONTROL',0),
	('cash_accounts_for_savings_type_enum',12,'INCOME_FROM_INTEREST','INCOME_FROM_INTEREST',0),
	('cash_account_for_shares_type_enum',1,'SHARES_REFERENCE','SHARES_REFERENCE',0),
	('cash_account_for_shares_type_enum',2,'SHARES_SUSPENSE','SHARES_SUSPENSE',0),
	('cash_account_for_shares_type_enum',3,'INCOME_FROM_FEES','INCOME_FROM_FEES',0),
	('cash_account_for_shares_type_enum',4,'SHARES_EQUITY','SHARES_EQUITY',0),
	('client_transaction_type_enum',1,'PAY_CHARGE','PAY_CHARGE',0),
	('client_transaction_type_enum',2,'WAIVE_CHARGE','WAIVE_CHARGE',0),
	('entity_account_type_enum',1,'CLIENT','CLIENT',0),
	('entity_account_type_enum',2,'LOAN','LOAN',0),
	('entity_account_type_enum',3,'SAVINGS','SAVINGS',0),
	('entity_account_type_enum',4,'CENTER','CENTER',0),
	('entity_account_type_enum',5,'GROUP','GROUP',0),
	('entity_account_type_enum',6,'SHARES','SHARES',0),
	('financial_activity_type_enum',100,'ASSET_TRANSFER','ASSET_TRANSFER',0),
	('financial_activity_type_enum',101,'CASH_AT_MAINVAULT','CASH_AT_MAINVAULT',0),
	('financial_activity_type_enum',102,'CASH_AT_TELLER','CASH_AT_TELLER',0),
	('financial_activity_type_enum',103,'ASSET_FUND_SOURCE','ASSET_FUND_SOURCE',0),
	('financial_activity_type_enum',200,'LIABILITY_TRANSFER','LIABILITY_TRANSFER',0),
	('financial_activity_type_enum',201,'PAYABLE_DIVIDENDS','PAYABLE_DIVIDENDS',0),
	('financial_activity_type_enum',300,'OPENING_BALANCES_TRANSFER_CONTRA','OPENING_BALANCES_TRANSFER_CONTRA',0),
	('glaccount_type_enum',1,'ASSET','ASSET',0),
	('glaccount_type_enum',2,'LIABILITY','LIABILITY',0),
	('glaccount_type_enum',3,'EQUITY','EQUITY',0),
	('glaccount_type_enum',4,'INCOME','INCOME',0),
	('glaccount_type_enum',5,'EXPENSE','EXPENSE',0),
	('interest_calculated_in_period_enum',0,'Daily','Daily',0),
	('interest_calculated_in_period_enum',1,'Same as repayment period','Same as repayment period',0),
	('interest_method_enum',0,'Declining Balance','Declining Balance',0),
	('interest_method_enum',1,'Flat','Flat',0),
	('interest_period_frequency_enum',2,'Per month','Per month',0),
	('interest_period_frequency_enum',3,'Per year','Per year',0),
	('journal_entry_type_type_enum',1,'CREDIT','CREDIT',0),
	('journal_entry_type_type_enum',2,'DEBIT','DEBIT',0),
	('loan_status_id',0,'Invalid','Invalid',0),
	('loan_status_id',100,'Submitted and awaiting approval','Submitted and awaiting approval',0),
	('loan_status_id',200,'Approved','Approved',0),
	('loan_status_id',300,'Active','Active',0),
	('loan_status_id',400,'Withdrawn by client','Withdrawn by client',0),
	('loan_status_id',500,'Rejected','Rejected',0),
	('loan_status_id',600,'Closed','Closed',0),
	('loan_status_id',601,'Written-Off','Written-Off',0),
	('loan_status_id',602,'Rescheduled','Rescheduled',0),
	('loan_status_id',700,'Overpaid','Overpaid',0),
	('loan_transaction_strategy_id',1,'mifos-standard-strategy','Mifos style',0),
	('loan_transaction_strategy_id',2,'heavensfamily-strategy','Heavensfamily',0),
	('loan_transaction_strategy_id',3,'creocore-strategy','Creocore',0),
	('loan_transaction_strategy_id',4,'rbi-india-strategy','RBI (India)',0),
	('loan_transaction_type_enum',0,'INVALID','INVALID',0),
	('loan_transaction_type_enum',1,'DISBURSEMENT','DISBURSEMENT',0),
	('loan_transaction_type_enum',2,'REPAYMENT','REPAYMENT',0),
	('loan_transaction_type_enum',3,'CONTRA','CONTRA',0),
	('loan_transaction_type_enum',4,'WAIVE_INTEREST','WAIVE_INTEREST',0),
	('loan_transaction_type_enum',5,'REPAYMENT_AT_DISBURSEMENT','REPAYMENT_AT_DISBURSEMENT',0),
	('loan_transaction_type_enum',6,'WRITEOFF','WRITEOFF',0),
	('loan_transaction_type_enum',7,'MARKED_FOR_RESCHEDULING','MARKED_FOR_RESCHEDULING',0),
	('loan_transaction_type_enum',8,'RECOVERY_REPAYMENT','RECOVERY_REPAYMENT',0),
	('loan_transaction_type_enum',9,'WAIVE_CHARGES','WAIVE_CHARGES',0),
	('loan_transaction_type_enum',10,'ACCRUAL','ACCRUAL',0),
	('loan_transaction_type_enum',12,'INITIATE_TRANSFER','INITIATE_TRANSFER',0),
	('loan_transaction_type_enum',13,'APPROVE_TRANSFER','APPROVE_TRANSFER',0),
	('loan_transaction_type_enum',14,'WITHDRAW_TRANSFER','WITHDRAW_TRANSFER',0),
	('loan_transaction_type_enum',15,'REJECT_TRANSFER','REJECT_TRANSFER',0),
	('loan_transaction_type_enum',16,'REFUND','REFUND',0),
	('loan_transaction_type_enum',17,'CHARGE_PAYMENT','CHARGE_PAYMENT',0),
	('loan_transaction_type_enum',18,'REFUND_FOR_ACTIVE_LOAN','REFUND_FOR_ACTIVE_LOAN',0),
	('loan_transaction_type_enum',19,'INCOME_POSTING','INCOME_POSTING',0),
	('portfolio_account_type_enum',1,'LOAN','LOAN',0),
	('portfolio_account_type_enum',2,'SAVING','EXPENSE',0),
	('portfolio_account_type_enum',3,'PROVISIONING','PROVISIONING',0),
	('portfolio_account_type_enum',4,'SHARES','SHARES',0),
	('processing_result_enum',0,'invalid','Invalid',0),
	('processing_result_enum',1,'processed','Processed',0),
	('processing_result_enum',2,'awaiting.approval','Awaiting Approval',0),
	('processing_result_enum',3,'rejected','Rejected',0),
	('repayment_period_frequency_enum',0,'Days','Days',0),
	('repayment_period_frequency_enum',1,'Weeks','Weeks',0),
	('repayment_period_frequency_enum',2,'Months','Months',0),
	('savings_transaction_type_enum',0,'INVALID','INVALID',0),
	('savings_transaction_type_enum',1,'deposit','deposit',0),
	('savings_transaction_type_enum',2,'withdrawal','withdrawal',1),
	('savings_transaction_type_enum',3,'Interest Posting','Interest Posting',0),
	('savings_transaction_type_enum',4,'Withdrawal Fee','Withdrawal Fee',1),
	('savings_transaction_type_enum',5,'Annual Fee','Annual Fee',1),
	('savings_transaction_type_enum',6,'Waive Charge','Waive Charge',0),
	('savings_transaction_type_enum',7,'Pay Charge','Pay Charge',1),
	('savings_transaction_type_enum',8,'DIVIDEND_PAYOUT','DIVIDEND_PAYOUT',0),
	('savings_transaction_type_enum',12,'Initiate Transfer','Initiate Transfer',0),
	('savings_transaction_type_enum',13,'Approve Transfer','Approve Transfer',0),
	('savings_transaction_type_enum',14,'Withdraw Transfer','Withdraw Transfer',0),
	('savings_transaction_type_enum',15,'Reject Transfer','Reject Transfer',0),
	('savings_transaction_type_enum',16,'Written-Off','Written-Off',0),
	('savings_transaction_type_enum',17,'Overdraft Interest','Overdraft Interest',0),
	('savings_transaction_type_enum',19,'WITHHOLD_TAX','WITHHOLD_TAX',0),
	('status_enum',0,'Invalid','Invalid',0),
	('status_enum',100,'Pending','Pending',0),
	('status_enum',300,'Active','Active',0),
	('status_enum',600,'Closed','Closed',0),
	('teller_status',300,'Active','Active',0),
	('teller_status',400,'Inactive','Inactive',0),
	('teller_status',600,'Closed','Closed',0),
	('term_period_frequency_enum',0,'Days','Days',0),
	('term_period_frequency_enum',1,'Weeks','Weeks',0),
	('term_period_frequency_enum',2,'Months','Months',0),
	('term_period_frequency_enum',3,'Years','Years',0),
	('transaction_type_enum',1,'Disbursement','Disbursement',0),
	('transaction_type_enum',2,'Repayment','Repayment',0),
	('transaction_type_enum',3,'Contra','Contra',0),
	('transaction_type_enum',4,'Waive Interest','Waive Interest',0),
	('transaction_type_enum',5,'Repayment At Disbursement','Repayment At Disbursement',0),
	('transaction_type_enum',6,'Write-Off','Write-Off',0),
	('transaction_type_enum',7,'Marked for Rescheduling','Marked for Rescheduling',0),
	('transaction_type_enum',8,'Recovery Repayment','Recovery Repayment',0),
	('transaction_type_enum',9,'Waive Charges','Waive Charges',0),
	('transaction_type_enum',10,'Apply Charges','Apply Charges',0),
	('transaction_type_enum',11,'Apply Interest','Apply Interest',0);

/*!40000 ALTER TABLE `r_enum_value` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table ref_loan_transaction_processing_strategy
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ref_loan_transaction_processing_strategy`;

CREATE TABLE `ref_loan_transaction_processing_strategy` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(100) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `sort_order` int(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ltp_strategy_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ref_loan_transaction_processing_strategy` WRITE;
/*!40000 ALTER TABLE `ref_loan_transaction_processing_strategy` DISABLE KEYS */;

INSERT INTO `ref_loan_transaction_processing_strategy` (`id`, `code`, `name`, `sort_order`)
VALUES
	(1,'mifos-standard-strategy','Penalties, Fees, Interest, Principal order',1),
	(2,'heavensfamily-strategy','HeavensFamily Unique',6),
	(3,'creocore-strategy','Creocore Unique',7),
	(4,'rbi-india-strategy','Overdue/Due Fee/Int,Principal',2),
	(5,'principal-interest-penalties-fees-order-strategy','Principal, Interest, Penalties, Fees Order',3),
	(6,'interest-principal-penalties-fees-order-strategy','Interest, Principal, Penalties, Fees Order',4),
	(7,'early-repayment-strategy','Early Repayment Strategy',5);

/*!40000 ALTER TABLE `ref_loan_transaction_processing_strategy` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table rpt_sequence
# ------------------------------------------------------------

DROP TABLE IF EXISTS `rpt_sequence`;

CREATE TABLE `rpt_sequence` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table scheduler_detail
# ------------------------------------------------------------

DROP TABLE IF EXISTS `scheduler_detail`;

CREATE TABLE `scheduler_detail` (
  `id` smallint(2) NOT NULL AUTO_INCREMENT,
  `is_suspended` tinyint(1) NOT NULL DEFAULT '0',
  `execute_misfired_jobs` tinyint(1) NOT NULL DEFAULT '1',
  `reset_scheduler_on_bootup` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `scheduler_detail` WRITE;
/*!40000 ALTER TABLE `scheduler_detail` DISABLE KEYS */;

INSERT INTO `scheduler_detail` (`id`, `is_suspended`, `execute_misfired_jobs`, `reset_scheduler_on_bootup`)
VALUES
	(1,0,1,1);

/*!40000 ALTER TABLE `scheduler_detail` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table schema_version
# ------------------------------------------------------------

DROP TABLE IF EXISTS `schema_version`;

CREATE TABLE `schema_version` (
  `version_rank` int(11) NOT NULL,
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) NOT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`version`),
  KEY `schema_version_vr_idx` (`version_rank`),
  KEY `schema_version_ir_idx` (`installed_rank`),
  KEY `schema_version_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

LOCK TABLES `schema_version` WRITE;
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;

INSERT INTO `schema_version` (`version_rank`, `installed_rank`, `version`, `description`, `type`, `script`, `checksum`, `installed_by`, `installed_on`, `execution_time`, `success`)
VALUES
	(1,1,'1','mifosplatform-core-ddl-latest','SQL','V1__mifosplatform-core-ddl-latest.sql',955277628,'fineract_default','2016-11-15 08:26:02',2321,1),
	(10,10,'10','interest-posting-fields-for-savings','SQL','V10__interest-posting-fields-for-savings.sql',-915121401,'fineract_default','2016-11-15 08:26:04',179,1),
	(100,100,'100','Group saving summary report','SQL','V100__Group_saving_summary_report.sql',1693648402,'fineract_default','2016-11-15 08:26:16',23,1),
	(101,101,'101','add mulitplesof to account transfers table','SQL','V101__add_mulitplesof_to_account_transfers_table.sql',1170497405,'fineract_default','2016-11-15 08:26:16',190,1),
	(102,102,'102','client attendance tables','SQL','V102__client_attendance_tables.sql',671600688,'fineract_default','2016-11-15 08:26:16',66,1),
	(103,103,'103','cluster support for batch jobs','SQL','V103__cluster_support_for_batch_jobs.sql',-1003733401,'fineract_default','2016-11-15 08:26:17',80,1),
	(104,104,'104','permissions for transfers','SQL','V104__permissions_for_transfers.sql',2097086645,'fineract_default','2016-11-15 08:26:17',11,1),
	(105,105,'105','track loan transaction against office','SQL','V105__track_loan_transaction_against_office.sql',-2088762881,'fineract_default','2016-11-15 08:26:17',207,1),
	(106,106,'106','more permissions for transfers','SQL','V106__more_permissions_for_transfers.sql',53789950,'fineract_default','2016-11-15 08:26:17',18,1),
	(107,107,'107','datatable code mappings','SQL','V107__datatable_code_mappings.sql',1936829107,'fineract_default','2016-11-15 08:26:17',29,1),
	(108,108,'108','client has transfer office','SQL','V108__client_has_transfer_office.sql',1848604685,'fineract_default','2016-11-15 08:26:17',59,1),
	(109,109,'109','account transfer withdrawal fee configuration','SQL','V109__account_transfer_withdrawal_fee_configuration.sql',-1509786056,'fineract_default','2016-11-15 08:26:17',181,1),
	(11,11,'11','add-payment-details','SQL','V11__add-payment-details.sql',-2044785781,'fineract_default','2016-11-15 08:26:04',75,1),
	(110,110,'110','group center close','SQL','V110__group_center_close.sql',-2002358105,'fineract_default','2016-11-15 08:26:18',100,1),
	(111,111,'111','disable constraint approach for datatables by default','SQL','V111__disable_constraint_approach_for_datatables_by_default.sql',-1856221518,'fineract_default','2016-11-15 08:26:18',7,1),
	(112,112,'111.1','set default transfers in suspense account for existing loan products','SQL','V111_1__set default_transfers_in_suspense_account_for_existing_loan_products.sql',-555049996,'fineract_default','2016-11-15 08:26:18',3,1),
	(113,113,'112','mixreport sql support','SQL','V112__mixreport_sql_support.sql',-1634685996,'fineract_default','2016-11-15 08:26:18',127,1),
	(114,114,'113','track savings transaction against office','SQL','V113__track_savings_transaction_against_office.sql',-1937464787,'fineract_default','2016-11-15 08:26:18',175,1),
	(115,115,'114','set default transfers in suspense account for existing savings products - Copy','SQL','V114__set_default_transfers_in_suspense_account_for_existing_savings_products - Copy.sql',-171456457,'fineract_default','2016-11-15 08:26:18',3,1),
	(116,116,'115','permissions for cache api','SQL','V115__permissions_for_cache_api.sql',1158425551,'fineract_default','2016-11-15 08:26:18',32,1),
	(117,117,'116','track currency for journal entries','SQL','V116__track_currency_for_journal_entries.sql',-532037257,'fineract_default','2016-11-15 08:26:18',224,1),
	(118,118,'117','loan charge from savings','SQL','V117__loan_charge_from_savings.sql',801798692,'fineract_default','2016-11-15 08:26:19',173,1),
	(119,119,'118','savings charge','SQL','V118__savings_charge.sql',-593125861,'fineract_default','2016-11-15 08:26:19',107,1),
	(120,120,'118.1','savings charge patch update','SQL','V118_1__savings_charge_patch_update.sql',409219698,'fineract_default','2016-11-15 08:26:19',109,1),
	(121,121,'118.2','product mapping delete duplicate fund source to account mappings','SQL','V118_2__product_mapping_delete_duplicate_fund_source_to_account_mappings.sql',1393421535,'fineract_default','2016-11-15 08:26:19',15,1),
	(122,122,'118.3','permissions form propose and accept client transfers','SQL','V118_3__permissions_form_propose_and_accept_client_transfers.sql',-1752486114,'fineract_default','2016-11-15 08:26:19',8,1),
	(123,123,'118.4','reset default transfers in suspense account for existing savings products','SQL','V118_4__reset_default_transfers_in_suspense_account_for_existing_savings_products.sql',-1647024296,'fineract_default','2016-11-15 08:26:19',6,1),
	(124,124,'118.5','batch job entry for pay savings charge','SQL','V118_5__batch_job_entry_for_pay_savings_charge.sql',-301143983,'fineract_default','2016-11-15 08:26:19',9,1),
	(125,125,'118.6','defaults for income from penalties for savings product','SQL','V118_6__defaults_for_income_from_penalties_for savings_product.sql',-1821592388,'fineract_default','2016-11-15 08:26:19',2,1),
	(126,126,'118.7','move withdrawal annual fee to charges','SQL','V118_7__move_withdrawal_annual_fee_to_charges.sql',-682159103,'fineract_default','2016-11-15 08:26:19',274,1),
	(127,127,'118.8','track overpayments seperately in loan transactions','SQL','V118_8__track_overpayments_seperately_in_loan_transactions.sql',543900977,'fineract_default','2016-11-15 08:26:20',113,1),
	(128,128,'119','add template table','SQL','V119__add_template_table.sql',506250383,'fineract_default','2016-11-15 08:26:20',118,1),
	(12,12,'12','add external id to couple of tables','SQL','V12__add_external_id_to_couple_of_tables.sql',472305363,'fineract_default','2016-11-15 08:26:05',474,1),
	(129,129,'120','accounting running balance','SQL','V120__accounting_running_balance.sql',2038578089,'fineract_default','2016-11-15 08:26:20',121,1),
	(130,130,'121','accounting running balance for organization','SQL','V121__accounting_running_balance_for_organization.sql',777437006,'fineract_default','2016-11-15 08:26:20',112,1),
	(131,131,'122','recurring fee support for savings','SQL','V122__recurring_fee_support_for_savings.sql',101575000,'fineract_default','2016-11-15 08:26:20',143,1),
	(132,132,'123','remove payment mode for savings','SQL','V123__remove_payment_mode_for_savings.sql',785052987,'fineract_default','2016-11-15 08:26:20',71,1),
	(133,133,'124','added min max cap for charges','SQL','V124__added_min_max_cap_for_charges.sql',-513616995,'fineract_default','2016-11-15 08:26:21',158,1),
	(134,134,'125','added column for actual fee amount or percentage','SQL','V125__added_column_for_actual_fee_amount_or_percentage.sql',-148629234,'fineract_default','2016-11-15 08:26:21',82,1),
	(135,135,'126','initial database structure for sms outbound','SQL','V126__initial_database_structure_for_sms_outbound.sql',537635250,'fineract_default','2016-11-15 08:26:21',73,1),
	(136,136,'127','mobile no fields','SQL','V127__mobile_no_fields.sql',-1231855730,'fineract_default','2016-11-15 08:26:21',241,1),
	(137,137,'128','added loan installment charge','SQL','V128__added_loan_installment_charge.sql',-2044492671,'fineract_default','2016-11-15 08:26:21',27,1),
	(138,138,'129','client and group timeline','SQL','V129__client_and_group_timeline.sql',-334848964,'fineract_default','2016-11-15 08:26:21',304,1),
	(13,13,'13','add group and client pending configuration','SQL','V13__add_group_and_client_pending_configuration.sql',2017249783,'fineract_default','2016-11-15 08:26:05',14,1),
	(139,139,'130','calendar-history-table','SQL','V130__calendar-history-table.sql',-1996204583,'fineract_default','2016-11-15 08:26:22',47,1),
	(140,140,'131','holiday-status-column-and-permissions','SQL','V131__holiday-status-column-and-permissions.sql',-2109352908,'fineract_default','2016-11-15 08:26:22',112,1),
	(141,141,'132','borrower cycle changes','SQL','V132__borrower_cycle_changes.sql',-238834331,'fineract_default','2016-11-15 08:26:22',146,1),
	(142,142,'133','adding payment detail with journal entry','SQL','V133__adding_payment_detail_with_journal_entry.sql',-604769594,'fineract_default','2016-11-15 08:26:22',89,1),
	(143,143,'134','added column value on c configuration','SQL','V134__added_column_value_on_c_configuration.sql',-1619312365,'fineract_default','2016-11-15 08:26:22',63,1),
	(144,144,'134.1','submitted date updation for clients','SQL','V134_1__submitted_date_updation_for_clients.sql',-835307031,'fineract_default','2016-11-15 08:26:22',8,1),
	(145,145,'134.2','permissions spelling correction','SQL','V134_2__permissions_spelling_correction.sql',-851162618,'fineract_default','2016-11-15 08:26:22',12,1),
	(146,146,'135','added permission for undo written off','SQL','V135__added_permission_for_undo_written_off.sql',-147929633,'fineract_default','2016-11-15 08:26:22',7,1),
	(147,147,'136.1','update script strechy parameter','SQL','V136_1__update_script_strechy_parameter.sql',493289660,'fineract_default','2016-11-15 08:26:22',7,1),
	(148,148,'137','added is active column in m staff','SQL','V137__added_is_active_column_in_m_staff.sql',-129240963,'fineract_default','2016-11-15 08:26:22',97,1),
	(149,149,'138','add short name for m product loan and m savings product','SQL','V138__add_short_name_for_m_product_loan_and_m_savings_product.sql',1111329012,'fineract_default','2016-11-15 08:26:23',351,1),
	(150,150,'139','default value for is active updated to true in m staff','SQL','V139__default_value_for_is_active_updated_to_true_in_m_staff.sql',26619575,'fineract_default','2016-11-15 08:26:23',85,1),
	(14,14,'14','rename status id to enum','SQL','V14__rename_status_id_to_enum.sql',971956550,'fineract_default','2016-11-15 08:26:05',49,1),
	(151,151,'140','added loan charge status','SQL','V140__added_loan_charge_status.sql',1403135602,'fineract_default','2016-11-15 08:26:23',83,1),
	(152,152,'140.1','added payment detail id in ac gl journal entry','SQL','V140_1__added_payment_detail_id_in_ac_gl_journal_entry.sql',-790452836,'fineract_default','2016-11-15 08:26:23',80,1),
	(153,153,'141','add early repayment strategy','SQL','V141__add_early_repayment_strategy.sql',1919258536,'fineract_default','2016-11-15 08:26:23',7,1),
	(154,154,'142','read savingsaccount charge permission','SQL','V142__read_savingsaccount_charge_permission.sql',445185341,'fineract_default','2016-11-15 08:26:23',24,1),
	(155,155,'143','create journalentry checker permission','SQL','V143__create_journalentry_checker_permission.sql',-1667764144,'fineract_default','2016-11-15 08:26:23',7,1),
	(156,156,'144','spelling mistake corrections','SQL','V144__spelling_mistake_corrections.sql',-795294413,'fineract_default','2016-11-15 08:26:23',44,1),
	(157,157,'145','add force password reset in c configuration','SQL','V145__add_force_password_reset_in_c_configuration.sql',450084438,'fineract_default','2016-11-15 08:26:24',185,1),
	(158,158,'146','tranche loans','SQL','V146__tranche_loans.sql',-618374535,'fineract_default','2016-11-15 08:26:24',417,1),
	(159,159,'147','tranche loans column name changes','SQL','V147__tranche_loans_column_name_changes.sql',-486809945,'fineract_default','2016-11-15 08:26:24',23,1),
	(160,160,'148','overdraft changes','SQL','V148__overdraft_changes.sql',-1245017565,'fineract_default','2016-11-15 08:26:25',356,1),
	(161,161,'149','add created date savings transaction','SQL','V149__add_created_date_savings_transaction.sql',-1464354272,'fineract_default','2016-11-15 08:26:25',87,1),
	(15,15,'15','center permissions','SQL','V15__center_permissions.sql',-1652318947,'fineract_default','2016-11-15 08:26:05',17,1),
	(162,162,'150','basic savings report','SQL','V150__basic_savings_report.sql',-367961884,'fineract_default','2016-11-15 08:26:25',121,1),
	(163,163,'151','add default savings account to client','SQL','V151__add_default_savings_account_to_client.sql',149734852,'fineract_default','2016-11-15 08:26:25',92,1),
	(164,164,'152','added grace for over due','SQL','V152__added_grace_for_over_due.sql',523114401,'fineract_default','2016-11-15 08:26:25',360,1),
	(165,165,'153','Insert missed permissions','SQL','V153__Insert_missed_permissions.sql',-1668699248,'fineract_default','2016-11-15 08:26:25',16,1),
	(166,166,'154','aging details','SQL','V154__aging_details.sql',1490415344,'fineract_default','2016-11-15 08:26:26',10,1),
	(167,167,'155','stretchy into pentaho','SQL','V155__stretchy_into_pentaho.sql',-1765542054,'fineract_default','2016-11-15 08:26:26',220,1),
	(168,168,'156','added loan saving txns pentaho','SQL','V156__added_loan_saving_txns_pentaho.sql',-225558880,'fineract_default','2016-11-15 08:26:26',17,1),
	(169,169,'157','overdue charge improvements','SQL','V157__overdue_charge_improvements.sql',557269609,'fineract_default','2016-11-15 08:26:26',102,1),
	(170,170,'158','dashboard and navigation queries','SQL','V158__dashboard_and_navigation_queries.sql',260379293,'fineract_default','2016-11-15 08:26:26',26,1),
	(171,171,'159','add transaction id column m portfolio command source','SQL','V159__add_transaction_id_column_m_portfolio_command_source.sql',848049166,'fineract_default','2016-11-15 08:26:26',188,1),
	(16,16,'16','drop min max column on loan table','SQL','V16__drop_min_max_column_on_loan_table.sql',-620841858,'fineract_default','2016-11-15 08:26:05',220,1),
	(172,172,'160','standing instruction changes','SQL','V160__standing_instruction_changes.sql',606544932,'fineract_default','2016-11-15 08:26:27',305,1),
	(173,173,'160.2','Allow nullValue For principal on lonProduct','SQL','V160_2__Allow_nullValue_For_principal_on_lonProduct.sql',-1888713202,'fineract_default','2016-11-15 08:26:27',127,1),
	(174,174,'161','added accrual batch job','SQL','V161__added_accrual_batch_job.sql',-2105048610,'fineract_default','2016-11-15 08:26:27',66,1),
	(175,175,'162','overdue charge batch job','SQL','V162__overdue_charge_batch_job.sql',-1920617111,'fineract_default','2016-11-15 08:26:27',7,1),
	(176,176,'163','added npa for loans','SQL','V163__added_npa_for_loans.sql',1195630185,'fineract_default','2016-11-15 08:26:27',366,1),
	(177,177,'164','fd and rd deposit tables','SQL','V164__fd_and_rd_deposit_tables.sql',210228160,'fineract_default','2016-11-15 08:26:28',757,1),
	(178,178,'165','added permission for disburse to saving account','SQL','V165__added_permission_for_disburse_to_saving_account.sql',1731284424,'fineract_default','2016-11-15 08:26:28',8,1),
	(179,179,'166','added deposit amount to product term and preclosure','SQL','V166__added_deposit_amount_to_product_term_and_preclosure.sql',1150192306,'fineract_default','2016-11-15 08:26:28',123,1),
	(180,180,'167','added columns for writtenOff loans recovered','SQL','V167__added_columns_for_writtenOff_loans_recovered.sql',2034680396,'fineract_default','2016-11-15 08:26:29',263,1),
	(181,181,'168','added transfer fixed deposit interest to linked account','SQL','V168__added_transfer_fixed_deposit_interest_to_linked_account.sql',-15179921,'fineract_default','2016-11-15 08:26:29',117,1),
	(182,182,'169','update dashboard reports to core reports use report to false','SQL','V169__update_dashboard_reports_to_core_reports_use_report_to_false.sql',1893278432,'fineract_default','2016-11-15 08:26:29',16,1),
	(17,17,'17','update stretchy reporting ddl','SQL','V17__update_stretchy_reporting_ddl.sql',1950226573,'fineract_default','2016-11-15 08:26:05',270,1),
	(183,183,'170','update deposit accounts maturity details job','SQL','V170__update_deposit_accounts_maturity_details_job.sql',-1809175088,'fineract_default','2016-11-15 08:26:29',7,1),
	(184,184,'171','added mandatory savings and rd changes','SQL','V171__added_mandatory_savings_and_rd_changes.sql',1819723867,'fineract_default','2016-11-15 08:26:29',402,1),
	(185,185,'172','accounting changes for transfers','SQL','V172__accounting_changes_for_transfers.sql',495285267,'fineract_default','2016-11-15 08:26:29',53,1),
	(186,186,'173','ppi','SQL','V173__ppi.sql',-315832082,'fineract_default','2016-11-15 08:26:30',240,1),
	(187,187,'174','remove interest accrual','SQL','V174__remove_interest_accrual.sql',-86335365,'fineract_default','2016-11-15 08:26:30',6,1),
	(188,188,'175','added incentive interest rates','SQL','V175__added_incentive_interest_rates.sql',477904540,'fineract_default','2016-11-15 08:26:30',286,1),
	(189,189,'176','updates to financial activity accounts','SQL','V176__updates_to_financial_activity_accounts.sql',-832139038,'fineract_default','2016-11-15 08:26:30',162,1),
	(190,190,'177','cleanup for client incentives','SQL','V177__cleanup_for_client_incentives.sql',1886371318,'fineract_default','2016-11-15 08:26:30',14,1),
	(191,191,'178','updates to financial activity accounts pt2','SQL','V178__updates_to_financial_activity_accounts_pt2.sql',1427890502,'fineract_default','2016-11-15 08:26:30',23,1),
	(192,192,'179','updates to action names for maker checker permissions','SQL','V179__updates_to_action_names_for_maker_checker_permissions.sql',1694854506,'fineract_default','2016-11-15 08:26:31',10,1),
	(18,18,'18','update stretchy reporting reportSql','SQL','V18__update_stretchy_reporting_reportSql.sql',897124129,'fineract_default','2016-11-15 08:26:05',12,1),
	(193,193,'180','update report schemas for disbursed vs awaitingdisbursal and groupnamesbystaff','SQL','V180__update_report_schemas_for_disbursed_vs_awaitingdisbursal_and_groupnamesbystaff.sql',-1059355980,'fineract_default','2016-11-15 08:26:31',8,1),
	(194,194,'181','standing instruction logging','SQL','V181__standing_instruction_logging.sql',37469411,'fineract_default','2016-11-15 08:26:31',24,1),
	(195,195,'182','added min required balance to savings product','SQL','V182__added_min_required_balance_to_savings_product.sql',293816320,'fineract_default','2016-11-15 08:26:31',193,1),
	(196,196,'183','added min balance for interest calculation','SQL','V183__added_min_balance_for_interest_calculation.sql',1252599574,'fineract_default','2016-11-15 08:26:31',169,1),
	(197,197,'184','update min required balance for savings product','SQL','V184__update_min_required_balance_for_savings_product.sql',1944024143,'fineract_default','2016-11-15 08:26:31',26,1),
	(198,198,'185','add accrual till date for periodic accrual','SQL','V185__add_accrual_till_date_for_periodic_accrual.sql',880447122,'fineract_default','2016-11-15 08:26:31',252,1),
	(199,199,'186','added periodic accrual job','SQL','V186__added_periodic_accrual_job.sql',301104388,'fineract_default','2016-11-15 08:26:32',10,1),
	(200,200,'187','added permission to periodic accrual','SQL','V187__added_permission_to_periodic_accrual.sql',-2074721454,'fineract_default','2016-11-15 08:26:32',20,1),
	(201,201,'188','add savingscharge inactivate permissions','SQL','V188__add_savingscharge_inactivate_permissions.sql',-540669352,'fineract_default','2016-11-15 08:26:32',91,1),
	(202,202,'189','m loan interest recalculation tables','SQL','V189__m_loan_interest_recalculation_tables.sql',-99299101,'fineract_default','2016-11-15 08:26:32',403,1),
	(19,19,'19','report maintenance permissions','SQL','V19__report_maintenance_permissions.sql',1970906090,'fineract_default','2016-11-15 08:26:05',28,1),
	(203,203,'190','add associategroup disassociategroup permissions','SQL','V190__add_associategroup_disassociategroup_permissions.sql',381935931,'fineract_default','2016-11-15 08:26:32',11,1),
	(204,204,'191','update gl account increase size of name col','SQL','V191__update_gl_account_increase_size_of_name_col.sql',1536985501,'fineract_default','2016-11-15 08:26:32',48,1),
	(205,205,'192','interest recalculate job','SQL','V192__interest_recalculate_job.sql',79432898,'fineract_default','2016-11-15 08:26:32',10,1),
	(206,206,'193','added column joiningDate for staff','SQL','V193__added_column_joiningDate_for_staff.sql',-821872836,'fineract_default','2016-11-15 08:26:33',100,1),
	(207,207,'194','added recalculatedInterestComponent for interest recalculation','SQL','V194__added_recalculatedInterestComponent_for_interest_recalculation.sql',-1166586891,'fineract_default','2016-11-15 08:26:33',65,1),
	(208,208,'195','moved rest frequency to product level','SQL','V195__moved_rest_frequency_to_product_level.sql',-1160182665,'fineract_default','2016-11-15 08:26:33',139,1),
	(209,209,'196','added loan running balance to transactions','SQL','V196__added_loan_running_balance_to_transactions.sql',1409766476,'fineract_default','2016-11-15 08:26:33',113,1),
	(210,210,'197','updated loan running balance of transactions','SQL','V197__updated_loan_running_balance_of_transactions.sql',1635739572,'fineract_default','2016-11-15 08:26:33',31,1),
	(211,211,'198','loan rescheduling tables and permissions','SQL','V198__loan_rescheduling_tables_and_permissions.sql',-1766835098,'fineract_default','2016-11-15 08:26:33',334,1),
	(212,212,'199','removed extra columns from schedule history','SQL','V199__removed_extra_columns_from_schedule_history.sql',-1832514885,'fineract_default','2016-11-15 08:26:34',80,1),
	(2,2,'2','mifosx-base-reference-data-utf8','SQL','V2__mifosx-base-reference-data-utf8.sql',-1196210340,'fineract_default','2016-11-15 08:26:02',76,1),
	(20,20,'20','report maint perms really configuration','SQL','V20__report_maint_perms_really_configuration.sql',453012588,'fineract_default','2016-11-15 08:26:05',8,1),
	(213,213,'200','alter savings account for start interest calculation date','SQL','V200__alter_savings_account_for_start_interest_calculation_date.sql',-1163540853,'fineract_default','2016-11-15 08:26:34',100,1),
	(214,214,'201','webhooks','SQL','V201__webhooks.sql',2049033132,'fineract_default','2016-11-15 08:26:34',163,1),
	(215,215,'202','savings officer history table','SQL','V202__savings_officer_history_table.sql',1234668850,'fineract_default','2016-11-15 08:26:34',47,1),
	(216,216,'203','added subbmittedDate loantransaction','SQL','V203__added_subbmittedDate_loantransaction.sql',-1629312170,'fineract_default','2016-11-15 08:26:34',96,1),
	(217,217,'204','insert script for charges paid by for accruals','SQL','V204__insert_script_for_charges_paid_by_for_accruals.sql',795810978,'fineract_default','2016-11-15 08:26:34',4,1),
	(218,218,'205','fix for charge and interest waiver with accruals','SQL','V205__fix_for_charge_and_interest_waiver_with_accruals.sql',1503546394,'fineract_default','2016-11-15 08:26:34',169,1),
	(219,219,'206','interest posting configuration','SQL','V206__interest_posting_configuration.sql',154771122,'fineract_default','2016-11-15 08:26:34',56,1),
	(220,220,'207','min max clients per group','SQL','V207__min_max_clients_per_group.sql',184134907,'fineract_default','2016-11-15 08:26:35',73,1),
	(221,221,'208','min max clients in group redux','SQL','V208__min_max_clients_in_group_redux.sql',-928317934,'fineract_default','2016-11-15 08:26:35',71,1),
	(222,222,'209','add all report names in m permission table','SQL','V209__add_all_report_names_in_m_permission_table.sql',-365542947,'fineract_default','2016-11-15 08:26:35',48,1),
	(21,21,'21','activation-permissions-for-clients','SQL','V21__activation-permissions-for-clients.sql',-247109946,'fineract_default','2016-11-15 08:26:06',88,1),
	(223,223,'210','track manually adjusted transactions','SQL','V210__track_manually_adjusted_transactions.sql',1826188666,'fineract_default','2016-11-15 08:26:35',96,1),
	(224,224,'211','minimum days between disbursal and first repayment','SQL','V211__minimum_days_between_disbursal_and_first_repayment.sql',-1661038663,'fineract_default','2016-11-15 08:26:35',104,1),
	(225,225,'212','add NthDay and DayOfWeek columns loan','SQL','V212__add_NthDay_and_DayOfWeek_columns_loan.sql',-604136808,'fineract_default','2016-11-15 08:26:35',216,1),
	(226,226,'213','NthDay and DayOfWeek columns should be nullable','SQL','V213__NthDay_and_DayOfWeek_columns_should_be_nullable.sql',-467766587,'fineract_default','2016-11-15 08:26:36',238,1),
	(227,227,'214','alter table add create SI at disbursement','SQL','V214__alter_table_add_create_SI_at_disbursement.sql',634522786,'fineract_default','2016-11-15 08:26:36',226,1),
	(228,228,'215','guarantee on hold fund changes','SQL','V215__guarantee_on_hold_fund_changes.sql',150894107,'fineract_default','2016-11-15 08:26:36',329,1),
	(229,229,'216','adding loan proposed amount to loan','SQL','V216__adding_loan_proposed_amount_to_loan.sql',-1187625362,'fineract_default','2016-11-15 08:26:37',235,1),
	(230,230,'217','client substatus and codevalue description','SQL','V217__client_substatus_and_codevalue_description.sql',1580988935,'fineract_default','2016-11-15 08:26:37',171,1),
	(231,231,'218','add user and datetime for loan savings transactions','SQL','V218__add_user_and_datetime_for_loan_savings_transactions.sql',79809857,'fineract_default','2016-11-15 08:26:37',194,1),
	(232,232,'219','guarantor on hold fund changes for account','SQL','V219__guarantor_on_hold_fund_changes_for_account.sql',605515418,'fineract_default','2016-11-15 08:26:38',523,1),
	(22,22,'22','alter-group-for-consistency-add-permissions','SQL','V22__alter-group-for-consistency-add-permissions.sql',1994886076,'fineract_default','2016-11-15 08:26:06',226,1),
	(233,233,'220','account number preferences','SQL','V220__account_number_preferences.sql',5010937,'fineract_default','2016-11-15 08:26:38',38,1),
	(234,234,'221','add version for m savings account','SQL','V221__add_version_for_m_savings_account.sql',-458458210,'fineract_default','2016-11-15 08:26:38',129,1),
	(235,235,'222','guarantor on hold fund changes for transactions','SQL','V222__guarantor_on_hold_fund_changes_for_transactions.sql',1500152124,'fineract_default','2016-11-15 08:26:38',423,1),
	(236,236,'223','add version for m loan account','SQL','V223__add_version_for_m_loan_account.sql',630974445,'fineract_default','2016-11-15 08:26:39',240,1),
	(237,237,'224','client lifecycle adding statuses','SQL','V224__client_lifecycle_adding_statuses.sql',-1899179981,'fineract_default','2016-11-15 08:26:39',398,1),
	(238,238,'225','permissions for updating recurring deposit amount','SQL','V225__permissions_for_updating_recurring_deposit_amount.sql',-1994557062,'fineract_default','2016-11-15 08:26:39',13,1),
	(239,239,'226','configuration for enforcing calendars for jlg loans','SQL','V226__configuration_for_enforcing_calendars_for_jlg_loans.sql',1439092124,'fineract_default','2016-11-15 08:26:39',19,1),
	(240,240,'227','loan-refund-permissions','SQL','V227__loan-refund-permissions.sql',-2112872726,'fineract_default','2016-11-15 08:26:39',30,1),
	(241,241,'228','entity to entity access','SQL','V228__entity_to_entity_access.sql',-283406757,'fineract_default','2016-11-15 08:26:39',78,1),
	(242,242,'229','teller cash management','SQL','V229__teller_cash_management.sql',-1424678232,'fineract_default','2016-11-15 08:26:40',438,1),
	(23,23,'23','remove-enable-disable-configuration-for-client-group-status','SQL','V23__remove-enable-disable-configuration-for-client-group-status.sql',267625051,'fineract_default','2016-11-15 08:26:06',92,1),
	(243,243,'230','role status and correspoding permissions','SQL','V230__role_status_and_correspoding_permissions.sql',-11380981,'fineract_default','2016-11-15 08:26:40',91,1),
	(244,244,'231','m cashier transaction added currency code','SQL','V231__m_cashier_transaction_added_currency_code.sql',613838774,'fineract_default','2016-11-15 08:26:40',61,1),
	(245,245,'232','insert center closure reason','SQL','V232__insert_center_closure_reason.sql',1610893120,'fineract_default','2016-11-15 08:26:40',10,1),
	(246,246,'233','Savings Transaction Receipt','SQL','V233__Savings_Transaction_Receipt.sql',-866032406,'fineract_default','2016-11-15 08:26:40',9,1),
	(247,247,'234','opening balaces setup','SQL','V234__opening_balaces_setup.sql',1086146792,'fineract_default','2016-11-15 08:26:40',53,1),
	(248,248,'235','add ugd template id m hook','SQL','V235__add_ugd_template_id_m_hook.sql',-1822383963,'fineract_default','2016-11-15 08:26:40',143,1),
	(249,249,'236','individual collection sheet permissions','SQL','V236__individual_collection_sheet_permissions.sql',2002138461,'fineract_default','2016-11-15 08:26:41',7,1),
	(250,250,'237','add threshold config for last instalment','SQL','V237__add_threshold_config_for_last_instalment.sql',-1244564740,'fineract_default','2016-11-15 08:26:41',129,1),
	(251,251,'238','update staff display name length','SQL','V238__update_staff_display_name_length.sql',-2026750320,'fineract_default','2016-11-15 08:26:41',76,1),
	(252,252,'239','Loan Transaction Receipt','SQL','V239__Loan_Transaction_Receipt.sql',-2048008570,'fineract_default','2016-11-15 08:26:41',8,1),
	(24,24,'24','add-group-client-foreign-key-constraint-in-loan-table','SQL','V24__add-group-client-foreign-key-constraint-in-loan-table.sql',-895801251,'fineract_default','2016-11-15 08:26:06',116,1),
	(253,253,'240','arrears aging config for interest recalculation','SQL','V240__arrears_aging_config_for_interest_recalculation.sql',-569040320,'fineract_default','2016-11-15 08:26:41',159,1),
	(254,254,'241','fixed emi changes','SQL','V241__fixed_emi_changes.sql',300787261,'fineract_default','2016-11-15 08:26:41',118,1),
	(255,255,'242','entitytoentitymappingrelation','SQL','V242__entitytoentitymappingrelation.sql',745908831,'fineract_default','2016-11-15 08:26:41',81,1),
	(256,256,'243','alter loan disbursement details','SQL','V243__alter_loan_disbursement_details.sql',-1491848388,'fineract_default','2016-11-15 08:26:41',52,1),
	(257,257,'244','staff assignment history table','SQL','V244__staff_assignment_history_table.sql',18710234,'fineract_default','2016-11-15 08:26:42',43,1),
	(258,258,'245','open rd changes','SQL','V245__open_rd_changes.sql',-2057800318,'fineract_default','2016-11-15 08:26:42',8,1),
	(259,259,'246','drop group client foreign key from m loan','SQL','V246__drop_group_client_foreign_key_from_m_loan.sql',1508935468,'fineract_default','2016-11-15 08:26:42',23,1),
	(260,260,'247','consistency wrt spelling principalThresholdForLastInstalment','SQL','V247__consistency_wrt_spelling_principalThresholdForLastInstalment.sql',682671217,'fineract_default','2016-11-15 08:26:42',11,1),
	(261,261,'248','added password never expired to User','SQL','V248__added_password_never_expired_to_User.sql',2112211436,'fineract_default','2016-11-15 08:26:42',94,1),
	(262,262,'249','workingdays permissions','SQL','V249__workingdays_permissions.sql',111355911,'fineract_default','2016-11-15 08:26:42',10,1),
	(25,25,'25','update client reports for status and activation change','SQL','V25__update_client_reports_for_status_and_activation_change.sql',-156638565,'fineract_default','2016-11-15 08:26:06',24,1),
	(263,263,'250','password validation policy','SQL','V250__password_validation_policy.sql',625441779,'fineract_default','2016-11-15 08:26:42',41,1),
	(264,264,'251','paymentType table','SQL','V251__paymentType_table.sql',-1153248008,'fineract_default','2016-11-15 08:26:42',166,1),
	(265,265,'252','bug fix teller cash management','SQL','V252__bug_fix_teller_cash_management.sql',-539616044,'fineract_default','2016-11-15 08:26:42',75,1),
	(266,266,'253','product loan configurable attributes','SQL','V253__product_loan_configurable_attributes.sql',611141994,'fineract_default','2016-11-15 08:26:42',36,1),
	(267,267,'254','General Ledger Report','SQL','V254__General_Ledger_Report.sql',2119102660,'fineract_default','2016-11-15 08:26:42',14,1),
	(268,268,'255','pre close interest period config','SQL','V255__pre_close_interest_period_config.sql',1808952818,'fineract_default','2016-11-15 08:26:43',61,1),
	(269,269,'256','Update script for General Ledger report','SQL','V256__Update script for General_Ledger_report.sql',696052144,'fineract_default','2016-11-15 08:26:43',19,1),
	(270,270,'257','staff image association','SQL','V257__staff_image_association.sql',-836387316,'fineract_default','2016-11-15 08:26:43',54,1),
	(271,271,'258','interest compounding changes','SQL','V258__interest_compounding_changes.sql',360400057,'fineract_default','2016-11-15 08:26:43',128,1),
	(272,272,'259','alter working days','SQL','V259__alter_working_days.sql',-1471987996,'fineract_default','2016-11-15 08:26:43',63,1),
	(26,26,'26','add-support-for-withdrawal-fees-on-savings','SQL','V26__add-support-for-withdrawal-fees-on-savings.sql',129901392,'fineract_default','2016-11-15 08:26:07',305,1),
	(273,273,'260','alter password validation policy','SQL','V260__alter_password_validation_policy.sql',-1248692662,'fineract_default','2016-11-15 08:26:43',51,1),
	(274,274,'261','Update script for Client Loan Account Schedule Report','SQL','V261__Update script for Client_Loan_Account_Schedule_Report.sql',425432201,'fineract_default','2016-11-15 08:26:43',7,1),
	(275,275,'262','accountNumber for groups','SQL','V262__accountNumber_for_groups.sql',1922297099,'fineract_default','2016-11-15 08:26:43',151,1),
	(276,276,'263','mifos reports','SQL','V263__mifos_reports.sql',2128016331,'fineract_default','2016-11-15 08:26:43',34,1),
	(277,277,'264','insert paymenttype and report read permission','SQL','V264__insert_paymenttype_and_report_read_permission.sql',-634268959,'fineract_default','2016-11-15 08:26:43',8,1),
	(278,278,'265','modify external service schema','SQL','V265__modify_external_service_schema.sql',300433155,'fineract_default','2016-11-15 08:26:44',292,1),
	(279,279,'266','client fees','SQL','V266__client_fees.sql',1859569785,'fineract_default','2016-11-15 08:26:44',117,1),
	(280,280,'267','client transaction permissions','SQL','V267__client_transaction_permissions.sql',731273171,'fineract_default','2016-11-15 08:26:44',9,1),
	(281,281,'268','update gmail password','SQL','V268__update_gmail_password.sql',1571111604,'fineract_default','2016-11-15 08:26:44',7,1),
	(282,282,'269','increased calendar title length ','SQL','V269__increased_calendar_title_length .sql',1602892066,'fineract_default','2016-11-15 08:26:44',81,1),
	(27,27,'27','add-loan-type-column-to-loan-table','SQL','V27__add-loan-type-column-to-loan-table.sql',612867183,'fineract_default','2016-11-15 08:26:07',238,1),
	(283,283,'270','add rounding mode configuration','SQL','V270__add_rounding_mode_configuration.sql',1970738261,'fineract_default','2016-11-15 08:26:44',78,1),
	(284,284,'271','accounting for client charges','SQL','V271__accounting_for_client_charges.sql',1964981050,'fineract_default','2016-11-15 08:26:44',130,1),
	(285,285,'272','loan tranche disbursement charge','SQL','V272__loan_tranche_disbursement_charge.sql',1144829058,'fineract_default','2016-11-15 08:26:45',137,1),
	(286,286,'273','oauth changes','SQL','V273__oauth_changes.sql',-245059913,'fineract_default','2016-11-15 08:26:45',77,1),
	(287,287,'274','Loan Reschedule Code Value','SQL','V274__Loan_Reschedule_Code_Value.sql',-5117183,'fineract_default','2016-11-15 08:26:45',6,1),
	(288,288,'275','loan transaction to repayment schedule mapping','SQL','V275__loan_transaction_to_repayment_schedule_mapping.sql',-221403658,'fineract_default','2016-11-15 08:26:45',28,1),
	(289,289,'276','loan recalulated till date','SQL','V276__loan_recalulated_till_date.sql',16474746,'fineract_default','2016-11-15 08:26:45',227,1),
	(290,290,'277','Loan Product Provisioning','SQL','V277__Loan_Product_Provisioning.sql',-391952085,'fineract_default','2016-11-15 08:26:45',225,1),
	(291,291,'278','LoanTransactionProcessingStrategy','SQL','V278__LoanTransactionProcessingStrategy.sql',-237974347,'fineract_default','2016-11-15 08:26:46',127,1),
	(292,292,'279','floating rates','SQL','V279__floating_rates.sql',-500468035,'fineract_default','2016-11-15 08:26:46',421,1),
	(28,28,'28','accounting-abstractions-and-autoposting','SQL','V28__accounting-abstractions-and-autoposting.sql',-2064898972,'fineract_default','2016-11-15 08:26:07',81,1),
	(293,293,'280','spm framework initial tables','SQL','V280__spm_framework_initial_tables.sql',-912305200,'fineract_default','2016-11-15 08:26:46',161,1),
	(294,294,'281','add configuration param backdate-penalties','SQL','V281__add_configuration_param_backdate-penalties.sql',-1810298086,'fineract_default','2016-11-15 08:26:46',13,1),
	(295,295,'282','CustomerSelfService','SQL','V282__CustomerSelfService.sql',240551284,'fineract_default','2016-11-15 08:26:46',110,1),
	(296,296,'283','Variable Installments','SQL','V283__Variable_Installments.sql',-1494982036,'fineract_default','2016-11-15 08:26:47',225,1),
	(297,297,'284','update codevalue','SQL','V284__update_codevalue.sql',-880137513,'fineract_default','2016-11-15 08:26:47',72,1),
	(298,298,'285','undo last tranche script','SQL','V285__undo_last_tranche_script.sql',-691462674,'fineract_default','2016-11-15 08:26:47',7,1),
	(299,299,'286','partial period interest calcualtion','SQL','V286__partial_period_interest_calcualtion.sql',2098674974,'fineract_default','2016-11-15 08:26:47',351,1),
	(300,300,'287','alter spm scorecard','SQL','V287__alter_spm_scorecard.sql',-1380609770,'fineract_default','2016-11-15 08:26:47',43,1),
	(301,301,'288','overdraft interest','SQL','V288__overdraft_interest.sql',-1725673774,'fineract_default','2016-11-15 08:26:48',191,1),
	(302,302,'289','client non person','SQL','V289__client_non_person.sql',-961697782,'fineract_default','2016-11-15 08:26:48',268,1),
	(29,29,'29','add-support-for-annual-fees-on-savings','SQL','V29__add-support-for-annual-fees-on-savings.sql',-995632079,'fineract_default','2016-11-15 08:26:07',298,1),
	(303,303,'290','shares dividends permissions script','SQL','V290__shares_dividends_permissions_script.sql',146587860,'fineract_default','2016-11-15 08:26:48',18,1),
	(304,304,'291','organisation start date config','SQL','V291__organisation_start_date_config.sql',-1674309950,'fineract_default','2016-11-15 08:26:48',67,1),
	(305,305,'292','update organisation start date','SQL','V292__update_organisation_start_date.sql',2016095558,'fineract_default','2016-11-15 08:26:48',14,1),
	(306,306,'293','interest rate chart support for amounts','SQL','V293__interest_rate_chart_support_for_amounts.sql',-1720908295,'fineract_default','2016-11-15 08:26:48',247,1),
	(307,307,'294','configuration for paymnettype application forDisbursement charge','SQL','V294__configuration_for_paymnettype_application_forDisbursement_charge.sql',-754382065,'fineract_default','2016-11-15 08:26:48',7,1),
	(308,308,'295','configuration for interest charged date same as disbursal date','SQL','V295__configuration_for_interest_charged_date_same_as_disbursal_date.sql',-1113285243,'fineract_default','2016-11-15 08:26:49',15,1),
	(309,309,'296','skip repayment on first-day of month','SQL','V296__skip_repayment_on first-day_of_month.sql',-172630113,'fineract_default','2016-11-15 08:26:49',8,1),
	(310,310,'297','Adding Meeting Time column','SQL','V297__Adding_Meeting_Time_column.sql',-637673654,'fineract_default','2016-11-15 08:26:49',64,1),
	(311,311,'298','savings interest tax','SQL','V298__savings_interest_tax.sql',-1023309693,'fineract_default','2016-11-15 08:26:49',340,1),
	(312,312,'299','share products','SQL','V299__share_products.sql',1270845438,'fineract_default','2016-11-15 08:26:50',383,1),
	(3,3,'3','mifosx-permissions-and-authorisation-utf8','SQL','V3__mifosx-permissions-and-authorisation-utf8.sql',656939441,'fineract_default','2016-11-15 08:26:02',32,1),
	(30,30,'30','add-referenceNumber-to-acc gl journal entry','SQL','V30__add-referenceNumber-to-acc_gl_journal_entry.sql',931391195,'fineract_default','2016-11-15 08:26:07',107,1),
	(313,313,'300','configuration for allow changing of emi amount','SQL','V300__configuration_for_allow_changing_of_emi_amount.sql',-490331317,'fineract_default','2016-11-15 08:26:50',146,1),
	(314,314,'301','recurring moratorium principal periods','SQL','V301__recurring_moratorium_principal_periods.sql',816871436,'fineract_default','2016-11-15 08:26:50',343,1),
	(315,315,'302','add status to client identifier','SQL','V302__add_status_to_client_identifier.sql',1978862509,'fineract_default','2016-11-15 08:26:50',97,1),
	(316,316,'303','Savings Account Dormancy','SQL','V303__Savings_Account_Dormancy.sql',-533139714,'fineract_default','2016-11-15 08:26:50',196,1),
	(317,317,'304','customer self service third party transfers','SQL','V304__customer_self_service_third_party_transfers.sql',-341614071,'fineract_default','2016-11-15 08:26:51',55,1),
	(318,318,'305','compounding and rest frequency nth day freq and insertion script for accrual job','SQL','V305__compounding_and_rest_frequency_nth_day_freq_and_insertion_script_for_accrual_job.sql',710584648,'fineract_default','2016-11-15 08:26:51',541,1),
	(319,319,'306','add domancy tracking job to savings group','SQL','V306__add_domancy_tracking_job_to_savings_group.sql',-2998873,'fineract_default','2016-11-15 08:26:51',17,1),
	(320,320,'307','add share notes','SQL','V307__add_share_notes.sql',-1950926410,'fineract_default','2016-11-15 08:26:51',118,1),
	(321,321,'308','add interest recalculation in savings account','SQL','V308__add_interest_recalculation_in_savings_account.sql',1869901088,'fineract_default','2016-11-15 08:26:52',139,1),
	(322,322,'309','add loan write off reason code','SQL','V309__add_loan_write_off_reason_code.sql',1221434865,'fineract_default','2016-11-15 08:26:52',117,1),
	(31,31,'31','drop-autopostings','SQL','V31__drop-autopostings.sql',1482958085,'fineract_default','2016-11-15 08:26:07',20,1),
	(323,323,'310','copy data from entitytoentityaccess to entitytoentitymapping','SQL','V310__copy_data_from_entitytoentityaccess_to_entitytoentitymapping.sql',1179078728,'fineract_default','2016-11-15 08:26:52',4,1),
	(324,324,'311','foreclosure details','SQL','V311__foreclosure_details.sql',1236003234,'fineract_default','2016-11-15 08:26:52',243,1),
	(325,325,'312','add is mandatory to code value','SQL','V312__add_is_mandatory_to_code_value.sql',-1943949742,'fineract_default','2016-11-15 08:26:52',79,1),
	(326,326,'313','multi rescheduling script','SQL','V313__multi_rescheduling_script.sql',-1003845274,'fineract_default','2016-11-15 08:26:53',407,1),
	(327,327,'314','updating r enum table','SQL','V314__updating_r_enum_table.sql',780881263,'fineract_default','2016-11-15 08:26:53',115,1),
	(328,328,'315','add sync expected with disbursement date in m product loan','SQL','V315__add_sync_expected_with_disbursement_date_in_m_product_loan.sql',553617808,'fineract_default','2016-11-15 08:26:53',118,1),
	(329,329,'316','address module tables metadat','SQL','V316__address_module_tables_metadat.sql',-776128404,'fineract_default','2016-11-15 08:26:53',124,1),
	(330,330,'317','report mailing job module','SQL','V317__report_mailing_job_module.sql',-1917516805,'fineract_default','2016-11-15 08:26:53',113,1),
	(331,331,'318','topuploan','SQL','V318__topuploan.sql',590465441,'fineract_default','2016-11-15 08:26:54',416,1),
	(332,332,'319','client undoreject','SQL','V319__client_undoreject.sql',-1615618857,'fineract_default','2016-11-15 08:26:54',249,1),
	(32,32,'32','associate-disassociate-clients-from-group-permissions','SQL','V32__associate-disassociate-clients-from-group-permissions.sql',-494472694,'fineract_default','2016-11-15 08:26:08',9,1),
	(33,33,'33','drop unique check on stretchy report parameter','SQL','V33__drop_unique_check_on_stretchy_report_parameter.sql',594468369,'fineract_default','2016-11-15 08:26:08',15,1),
	(34,34,'34','add unique check on stretchy report parameter','SQL','V34__add_unique_check_on_stretchy_report_parameter.sql',-174129685,'fineract_default','2016-11-15 08:26:08',36,1),
	(35,35,'35','add hierarchy column for acc gl account','SQL','V35__add_hierarchy_column_for_acc_gl_account.sql',1606939439,'fineract_default','2016-11-15 08:26:08',62,1),
	(36,36,'36','add tag id column for acc gl account','SQL','V36__add_tag_id_column_for_acc_gl_account.sql',-1913861595,'fineract_default','2016-11-15 08:26:08',77,1),
	(37,37,'37','add-center-group-collection-sheet-permissions','SQL','V37__add-center-group-collection-sheet-permissions.sql',-1387816026,'fineract_default','2016-11-15 08:26:08',16,1),
	(38,38,'38','add-group-summary-details-report','SQL','V38__add-group-summary-details-report.sql',-734381577,'fineract_default','2016-11-15 08:26:08',17,1),
	(39,39,'39','payment-channels-updates','SQL','V39__payment-channels-updates.sql',-1060218860,'fineract_default','2016-11-15 08:26:08',159,1),
	(4,4,'4','mifosx-core-reports-utf8','SQL','V4__mifosx-core-reports-utf8.sql',1938269916,'fineract_default','2016-11-15 08:26:02',157,1),
	(40,40,'40','add permissions for accounting rule','SQL','V40__add_permissions_for_accounting_rule.sql',-116179709,'fineract_default','2016-11-15 08:26:08',7,1),
	(41,41,'41','group-summary-reports','SQL','V41__group-summary-reports.sql',-772715166,'fineract_default','2016-11-15 08:26:08',14,1),
	(42,42,'42','Add default value for id for acc accounting rule','SQL','V42__Add_default_value_for_id_for_acc_accounting_rule.sql',604918027,'fineract_default','2016-11-15 08:26:08',57,1),
	(43,43,'43','accounting-for-savings','SQL','V43__accounting-for-savings.sql',-1500414425,'fineract_default','2016-11-15 08:26:09',114,1),
	(44,44,'44','document-increase-size-of-column-type','SQL','V44__document-increase-size-of-column-type.sql',-1050476515,'fineract_default','2016-11-15 08:26:09',34,1),
	(45,45,'45','create acc rule tags table','SQL','V45__create_acc_rule_tags_table.sql',1162013385,'fineract_default','2016-11-15 08:26:09',31,1),
	(46,46,'46','extend datatables api','SQL','V46__extend_datatables_api.sql',1411386919,'fineract_default','2016-11-15 08:26:09',7,1),
	(47,47,'47','staff-hierarchy-link-to-users','SQL','V47__staff-hierarchy-link-to-users.sql',1889695678,'fineract_default','2016-11-15 08:26:09',216,1),
	(48,48,'48','adding-S3-Support','SQL','V48__adding-S3-Support.sql',1203678485,'fineract_default','2016-11-15 08:26:09',260,1),
	(49,49,'49','track-loan-charge-payment-transactions','SQL','V49__track-loan-charge-payment-transactions.sql',545881620,'fineract_default','2016-11-15 08:26:09',37,1),
	(5,5,'5','update-savings-product-and-account-tables','SQL','V5__update-savings-product-and-account-tables.sql',-1335665240,'fineract_default','2016-11-15 08:26:02',192,1),
	(50,50,'50','add-grace-settings-to-loan-product','SQL','V50__add-grace-settings-to-loan-product.sql',781542044,'fineract_default','2016-11-15 08:26:10',339,1),
	(333,333,'5000','Daily Teller Cash Report pentaho','SQL','V5000__Daily_Teller_Cash_Report_pentaho.sql',-638871297,'fineract_default','2016-11-15 08:26:54',50,1),
	(51,51,'51','track-additional-details-related-to-installment-performance','SQL','V51__track-additional-details-related-to-installment-performance.sql',1877290988,'fineract_default','2016-11-15 08:26:10',123,1),
	(52,52,'52','add boolean support cols to acc accounting rule','SQL','V52__add_boolean_support_cols_to_acc_accounting_rule.sql',-1027998479,'fineract_default','2016-11-15 08:26:10',113,1),
	(53,53,'53','track-advance-and-late-payments-on-installment','SQL','V53__track-advance-and-late-payments-on-installment.sql',1329153113,'fineract_default','2016-11-15 08:26:10',65,1),
	(54,54,'54','charge-to-income-account-mappings','SQL','V54__charge-to-income-account-mappings.sql',-407918884,'fineract_default','2016-11-15 08:26:10',59,1),
	(55,55,'55','add-additional-transaction-processing-strategies','SQL','V55__add-additional-transaction-processing-strategies.sql',431870896,'fineract_default','2016-11-15 08:26:10',74,1),
	(56,56,'56','track-overpaid-amount-on-loans','SQL','V56__track-overpaid-amount-on-loans.sql',-1032410124,'fineract_default','2016-11-15 08:26:11',234,1),
	(57,57,'57','add default values to debit and credit accounts acc accounting rule','SQL','V57__add_default_values_to_debit_and_credit_accounts_acc_accounting_rule.sql',235706681,'fineract_default','2016-11-15 08:26:11',97,1),
	(58,58,'58','create-holiday-tables changed','SQL','V58__create-holiday-tables_changed.sql',1656341096,'fineract_default','2016-11-15 08:26:11',71,1),
	(59,59,'59','add group roles schema and permissions','SQL','V59__add_group_roles_schema_and_permissions.sql',755577759,'fineract_default','2016-11-15 08:26:11',42,1),
	(6,6,'6','add min max principal column to loan','SQL','V6__add_min_max_principal_column_to_loan.sql',1691311198,'fineract_default','2016-11-15 08:26:03',296,1),
	(60,60,'60','quipo dashboard reports','SQL','V60__quipo_dashboard_reports.sql',1200522596,'fineract_default','2016-11-15 08:26:11',55,1),
	(61,61,'61','txn running balance example','SQL','V61__txn_running_balance_example.sql',1448824868,'fineract_default','2016-11-15 08:26:11',15,1),
	(62,62,'62','add staff id to m client changed','SQL','V62__add_staff_id_to_m_client_changed.sql',1876751638,'fineract_default','2016-11-15 08:26:11',70,1),
	(63,63,'63','add sync disbursement with meeting column to loan','SQL','V63__add_sync_disbursement_with_meeting_column_to_loan.sql',-668764096,'fineract_default','2016-11-15 08:26:12',229,1),
	(64,64,'64','add permission for assign staff','SQL','V64__add_permission_for_assign_staff.sql',-1177097659,'fineract_default','2016-11-15 08:26:12',7,1),
	(65,65,'65','fix rupee symbol issues','SQL','V65__fix_rupee_symbol_issues.sql',-1194106354,'fineract_default','2016-11-15 08:26:12',8,1),
	(66,66,'66','client close functionality','SQL','V66__client_close_functionality.sql',-1362214442,'fineract_default','2016-11-15 08:26:12',63,1),
	(67,67,'67','loans in advance table','SQL','V67__loans_in_advance_table.sql',29130560,'fineract_default','2016-11-15 08:26:12',20,1),
	(68,68,'68','quipo dashboard reports updated','SQL','V68__quipo_dashboard_reports_updated.sql',-1865417462,'fineract_default','2016-11-15 08:26:12',59,1),
	(69,69,'69','loans in advance initialise','SQL','V69__loans_in_advance_initialise.sql',1132804183,'fineract_default','2016-11-15 08:26:12',25,1),
	(7,7,'7','remove read makerchecker permission','SQL','V7__remove_read_makerchecker_permission.sql',-2078415771,'fineract_default','2016-11-15 08:26:03',18,1),
	(70,70,'70','quipo program detail query fix','SQL','V70__quipo_program_detail_query_fix.sql',-1314752325,'fineract_default','2016-11-15 08:26:12',8,1),
	(71,71,'71','insert reschedule repayment to configuration','SQL','V71__insert_reschedule_repayment_to_configuration.sql',-1744995263,'fineract_default','2016-11-15 08:26:12',7,1),
	(72,72,'72','add m loan counter changes','SQL','V72__add_m_loan_counter_changes.sql',1657331766,'fineract_default','2016-11-15 08:26:12',149,1),
	(73,73,'73','add repayments rescheduled to and processed column to holiday','SQL','V73__add_repayments_rescheduled_to_and_processed_column_to_holiday.sql',1126478114,'fineract_default','2016-11-15 08:26:12',65,1),
	(74,74,'74','alter m loan counter table add group','SQL','V74__alter_m_loan_counter_table_add_group.sql',-1934237868,'fineract_default','2016-11-15 08:26:13',247,1),
	(75,75,'75','add reschedule-repayments-on-holidays to configuration','SQL','V75__add_reschedule-repayments-on-holidays_to_configuration.sql',-1278134204,'fineract_default','2016-11-15 08:26:13',7,1),
	(76,76,'76','rename permission grouping','SQL','V76__rename_permission_grouping.sql',-1636539309,'fineract_default','2016-11-15 08:26:13',10,1),
	(77,77,'77','alter m product loan changes','SQL','V77__alter_m_product_loan_changes.sql',1835358988,'fineract_default','2016-11-15 08:26:13',110,1),
	(78,78,'78','breakdown portfolio grouping','SQL','V78__breakdown_portfolio_grouping.sql',-198729568,'fineract_default','2016-11-15 08:26:13',7,1),
	(79,79,'79','schedule jobs tables','SQL','V79__schedule_jobs_tables.sql',312120211,'fineract_default','2016-11-15 08:26:13',64,1),
	(8,8,'8','deposit-transaction-permissions-if-they-exist','SQL','V8__deposit-transaction-permissions-if-they-exist.sql',1801801284,'fineract_default','2016-11-15 08:26:03',6,1),
	(80,80,'80','schedule jobs tables updates','SQL','V80__schedule_jobs_tables_updates.sql',-748120531,'fineract_default','2016-11-15 08:26:13',172,1),
	(81,81,'81','savings related changes','SQL','V81__savings_related_changes.sql',-888957999,'fineract_default','2016-11-15 08:26:14',565,1),
	(82,82,'82','schedule jobs tables updates for running status','SQL','V82__schedule_jobs_tables_updates_for_running_status.sql',229481826,'fineract_default','2016-11-15 08:26:14',101,1),
	(83,83,'83','non-working-days-table','SQL','V83__non-working-days-table.sql',1881541622,'fineract_default','2016-11-15 08:26:14',25,1),
	(84,84,'84','undo savings transaction permission','SQL','V84__undo_savings_transaction_permission.sql',-1779650707,'fineract_default','2016-11-15 08:26:14',6,1),
	(85,85,'85','product mix related changes','SQL','V85__product_mix_related_changes.sql',-1468649166,'fineract_default','2016-11-15 08:26:14',219,1),
	(86,86,'86','update-working-days','SQL','V86__update-working-days.sql',-1140835665,'fineract_default','2016-11-15 08:26:14',26,1),
	(87,87,'87','add permission for scheduler','SQL','V87__add_permission_for_scheduler.sql',1996443143,'fineract_default','2016-11-15 08:26:14',9,1),
	(88,88,'88','added update constrain for scheduler jobs','SQL','V88__added_update_constrain_for_scheduler_jobs.sql',777067784,'fineract_default','2016-11-15 08:26:15',48,1),
	(89,89,'89','added scheduler group','SQL','V89__added_scheduler_group.sql',-2129901927,'fineract_default','2016-11-15 08:26:15',44,1),
	(9,9,'9','add min max constraint column to loan loanproduct','SQL','V9__add_min_max_constraint_column_to_loan_loanproduct.sql',-518699440,'fineract_default','2016-11-15 08:26:04',672,1),
	(90,90,'90','client performance history reports','SQL','V90__client_performance_history_reports.sql',-140192401,'fineract_default','2016-11-15 08:26:15',24,1),
	(91,91,'91','apply annual fees permission','SQL','V91__apply_annual_fees_permission.sql',923770634,'fineract_default','2016-11-15 08:26:15',8,1),
	(92,92,'91.1','configuration settings for holiday and non workingday','SQL','V91_1__configuration_settings_for_holiday_and_non_workingday.sql',-308211608,'fineract_default','2016-11-15 08:26:15',9,1),
	(93,93,'92','group center assign staff permission','SQL','V92__group_center_assign_staff_permission.sql',-1774462272,'fineract_default','2016-11-15 08:26:15',7,1),
	(94,94,'93','loan transaction external id','SQL','V93__loan_transaction_external_id.sql',1057431340,'fineract_default','2016-11-15 08:26:15',82,1),
	(95,95,'94','added savings accont type','SQL','V94__added_savings_accont type.sql',652367910,'fineract_default','2016-11-15 08:26:15',122,1),
	(96,96,'95','batch job postInterest','SQL','V95__batch_job_postInterest.sql',597753088,'fineract_default','2016-11-15 08:26:15',8,1),
	(97,97,'96','savings accounts transfers table','SQL','V96__savings_accounts_transfers_table.sql',695072575,'fineract_default','2016-11-15 08:26:15',88,1),
	(98,98,'97','add permission for adjust savings transaction','SQL','V97__add_permission_for_adjust_savings_transaction.sql',103624768,'fineract_default','2016-11-15 08:26:15',38,1),
	(99,99,'98','added currency roundof for multipleof','SQL','V98__added_currency_roundof_for_multipleof.sql',-2113842963,'fineract_default','2016-11-15 08:26:16',674,1);

/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table sms_messages_outbound
# ------------------------------------------------------------

DROP TABLE IF EXISTS `sms_messages_outbound`;

CREATE TABLE `sms_messages_outbound` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `group_id` bigint(20) DEFAULT NULL,
  `client_id` bigint(20) DEFAULT NULL,
  `staff_id` bigint(20) DEFAULT NULL,
  `status_enum` int(5) NOT NULL DEFAULT '100',
  `mobile_no` varchar(50) NOT NULL,
  `message` varchar(1000) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKGROUP000000001` (`group_id`),
  KEY `FKCLIENT00000001` (`client_id`),
  KEY `FKSTAFF000000001` (`staff_id`),
  CONSTRAINT `FKCLIENT00000001` FOREIGN KEY (`client_id`) REFERENCES `m_client` (`id`),
  CONSTRAINT `FKGROUP000000001` FOREIGN KEY (`group_id`) REFERENCES `m_group` (`id`),
  CONSTRAINT `FKSTAFF000000001` FOREIGN KEY (`staff_id`) REFERENCES `m_staff` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table stretchy_parameter
# ------------------------------------------------------------

DROP TABLE IF EXISTS `stretchy_parameter`;

CREATE TABLE `stretchy_parameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter_name` varchar(45) NOT NULL,
  `parameter_variable` varchar(45) DEFAULT NULL,
  `parameter_label` varchar(45) NOT NULL,
  `parameter_displayType` varchar(45) NOT NULL,
  `parameter_FormatType` varchar(10) NOT NULL,
  `parameter_default` varchar(45) NOT NULL,
  `special` varchar(1) DEFAULT NULL,
  `selectOne` varchar(1) DEFAULT NULL,
  `selectAll` varchar(1) DEFAULT NULL,
  `parameter_sql` text,
  `parent_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_UNIQUE` (`parameter_name`),
  KEY `fk_stretchy_parameter_001_idx` (`parent_id`),
  CONSTRAINT `fk_stretchy_parameter_001` FOREIGN KEY (`parent_id`) REFERENCES `stretchy_parameter` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `stretchy_parameter` WRITE;
/*!40000 ALTER TABLE `stretchy_parameter` DISABLE KEYS */;

INSERT INTO `stretchy_parameter` (`id`, `parameter_name`, `parameter_variable`, `parameter_label`, `parameter_displayType`, `parameter_FormatType`, `parameter_default`, `special`, `selectOne`, `selectAll`, `parameter_sql`, `parent_id`)
VALUES
	(1,'startDateSelect','startDate','startDate','date','date','today',NULL,NULL,NULL,NULL,NULL),
	(2,'endDateSelect','endDate','endDate','date','date','today',NULL,NULL,NULL,NULL,NULL),
	(3,'obligDateTypeSelect','obligDateType','obligDateType','select','number','0',NULL,NULL,NULL,'select * from\r\n(select 1 as id, \"Closed\" as `name` union all\r\nselect 2, \"Disbursal\" ) x\r\norder by x.`id`',NULL),
	(5,'OfficeIdSelectOne','officeId','Office','select','number','0',NULL,'Y',NULL,'select id, \r\nconcat(substring(\"........................................\", 1, \r\n   \n\n((LENGTH(`hierarchy`) - LENGTH(REPLACE(`hierarchy`, \'.\', \'\')) - 1) * 4)), \r\n   `name`) as tc\r\nfrom m_office\r\nwhere hierarchy like concat\n\n(\'${currentUserHierarchy}\', \'%\')\r\norder by hierarchy',NULL),
	(6,'loanOfficerIdSelectAll','loanOfficerId','Loan Officer','select','number','0',NULL,NULL,'Y','(select lo.id, lo.display_name as `Name` \r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\njoin m_staff lo on lo.office_id = ounder.id\r\nwhere lo.is_loan_officer = true\r\nand o.id = ${officeId})\r\nunion all\r\n(select -10, \'-\')\r\norder by 2',5),
	(10,'currencyIdSelectAll','currencyId','Currency','select','number','0',NULL,NULL,'Y','select `code`, `name`\r\nfrom m_organisation_currency\r\norder by `code`',NULL),
	(20,'fundIdSelectAll','fundId','Fund','select','number','0',NULL,NULL,'Y','(select id, `name`\r\nfrom m_fund)\r\nunion all\r\n(select -10, \'-\')\r\norder by 2',NULL),
	(25,'loanProductIdSelectAll','loanProductId','Product','select','number','0',NULL,NULL,'Y','select p.id, p.`name`\r\nfrom m_product_loan p\r\nwhere (p.currency_code = \'${currencyId}\' or \'-1\'= \'${currencyId}\')\r\norder by 2',10),
	(26,'loanPurposeIdSelectAll','loanPurposeId','Loan Purpose','select','number','0',NULL,NULL,'Y','select -10 as id, \'-\' as code_value\r\nunion all\r\nselect * from (select v.id, v.code_value\r\nfrom m_code c\r\njoin m_code_value v on v.code_id = c.id\r\nwhere c.code_name = \"loanPurpose\"\r\norder by v.order_position)  x',NULL),
	(100,'parTypeSelect','parType','parType','select','number','0',NULL,NULL,NULL,'select * from\r\n(select 1 as id, \"Principal Only\" as `name` union all\r\nselect 2, \"Principal + Interest\" union all\r\nselect 3, \"Principal + Interest + Fees\" union all\r\nselect 4, \"Principal + Interest + Fees + Penalties\") x\r\norder by x.`id`',NULL),
	(1001,'FullReportList',NULL,'n/a','n/a','n/a','n/a','Y',NULL,NULL,'select  r.id as report_id, r.report_name, r.report_type, r.report_subtype, r.report_category,\nrp.id as parameter_id, rp.report_parameter_name, p.parameter_name\n  from stretchy_report r\n  left join stretchy_report_parameter rp on rp.report_id = r.id \n  left join stretchy_parameter p on p.id = rp.parameter_id\n  where r.use_report is true\n  and exists\n  ( select \'f\'\n  from m_appuser_role ur \n  join m_role r on r.id = ur.role_id\n  join m_role_permission rp on rp.role_id = r.id\n  join m_permission p on p.id = rp.permission_id\n  where ur.appuser_id = ${currentUserId}\n  and (p.code in (\'ALL_FUNCTIONS_READ\', \'ALL_FUNCTIONS\') or p.code = concat(\"READ_\", r.report_name)) )\n  order by r.report_category, r.report_name, rp.id',NULL),
	(1002,'FullParameterList',NULL,'n/a','n/a','n/a','n/a','Y',NULL,NULL,'select sp.parameter_name, sp.parameter_variable, sp.parameter_label, sp.parameter_displayType, \r sp.parameter_FormatType, sp.parameter_default, sp.selectOne,  sp.selectAll, spp.parameter_name as parentParameterName\r from stretchy_parameter sp\r left join stretchy_parameter spp on spp.id = sp.parent_id\r where sp.special is null\r and exists \r 	(select \'f\' \r 	from stretchy_report sr\r 	join stretchy_report_parameter srp on srp.report_id = sr.id\r 	where sr.report_name in(${reportListing})\r 	and srp.parameter_id = sp.id\r 	)\r order by sp.id',NULL),
	(1003,'reportCategoryList',NULL,'n/a','n/a','n/a','n/a','Y',NULL,NULL,'select  r.id as report_id, r.report_name, r.report_type, r.report_subtype, r.report_category,\n  rp.id as parameter_id, rp.report_parameter_name, p.parameter_name\n  from stretchy_report r\n  left join stretchy_report_parameter rp on rp.report_id = r.id\n  left join stretchy_parameter p on p.id = rp.parameter_id\n  where r.report_category = \'${reportCategory}\'\n  and r.use_report is true\n  and exists\n  (select \'f\'\n  from m_appuser_role ur \n  join m_role r on r.id = ur.role_id\n  join m_role_permission rp on rp.role_id = r.id\n  join m_permission p on p.id = rp.permission_id\n  where ur.appuser_id = ${currentUserId}\n  and (p.code in (\'ALL_FUNCTIONS_READ\', \'ALL_FUNCTIONS\') or p.code = concat(\"READ_\", r.report_name)) )\n  order by r.report_category, r.report_name, rp.id',NULL),
	(1004,'selectAccount','accountNo','Enter Account No','text','string','n/a',NULL,NULL,NULL,NULL,NULL),
	(1005,'savingsProductIdSelectAll','savingsProductId','Product','select','number','0',NULL,NULL,'Y','select p.id, p.`name`\r\nfrom m_savings_product p\r\norder by 2',NULL),
	(1006,'transactionId','transactionId','transactionId','text','string','n/a',NULL,NULL,NULL,NULL,NULL),
	(1007,'selectCenterId','centerId','Enter Center Id','text','string','n/a',NULL,NULL,NULL,NULL,NULL),
	(1008,'SelectGLAccountNO','GLAccountNO','GLAccountNO','select','number','0',NULL,NULL,NULL,'select id aid,name aname\r\nfrom acc_gl_account',NULL),
	(1009,'asOnDate','asOn','As On','date','date','today',NULL,NULL,NULL,NULL,NULL),
	(1010,'SavingsAccountSubStatus','subStatus','SavingsAccountDormancyStatus','select','number','100',NULL,NULL,NULL,'select * from\r\n(select 100 as id, \"Inactive\" as name  union all\r\nselect 200 as id, \"Dormant\" as  name union all \r\nselect 300 as id, \"Escheat\" as name) x\r\norder by x.`id`',NULL),
	(1011,'tellerIdSelectOne','tellerId','Teller','select','number','0',NULL,'Y','N','select id, name from m_tellers where office_id = ${officeId}',5),
	(1012,'cashierIdSelectOne','cashierId','Cashier','select','number','0',NULL,'Y','N','select c.id, s.display_name from m_cashiers as c left join m_staff as s on c.staff_id = s.id where c.teller_id = ${tellerId}',1011),
	(1013,'currencyCodeSelectOne','currencyCode','Currency','select','string','0',NULL,'Y','N','select `code`, `name` from m_organisation_currency order by `code`',NULL);

/*!40000 ALTER TABLE `stretchy_parameter` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table stretchy_report
# ------------------------------------------------------------

DROP TABLE IF EXISTS `stretchy_report`;

CREATE TABLE `stretchy_report` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_name` varchar(100) NOT NULL,
  `report_type` varchar(20) NOT NULL,
  `report_subtype` varchar(20) DEFAULT NULL,
  `report_category` varchar(45) DEFAULT NULL,
  `report_sql` text,
  `description` text,
  `core_report` tinyint(1) DEFAULT '0',
  `use_report` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_name_UNIQUE` (`report_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `stretchy_report` WRITE;
/*!40000 ALTER TABLE `stretchy_report` DISABLE KEYS */;

INSERT INTO `stretchy_report` (`id`, `report_name`, `report_type`, `report_subtype`, `report_category`, `report_sql`, `description`, `core_report`, `use_report`)
VALUES
	(1,'Client Listing','Table',NULL,'Client','select\nconcat(repeat(\"..\",\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\n c.account_no as \"Client Account No.\",\nc.display_name as \"Name\",\nr.enum_message_property as \"Status\",\nc.activation_date as \"Activation\", c.external_id as \"External Id\"\nfrom m_office o\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\nleft join r_enum_value r on r.enum_name = \'status_enum\' and r.enum_id = c.status_enum\nwhere o.id = ${officeId}\norder by ounder.hierarchy, c.account_no','Individual Client Report\r\n\r\nLists the small number of defined fields on the client table.  Would expect to copy this \n\nreport and add any \'one to one\' additional data for specific tenant needs.\r\n\r\nCan be run for any size MFI but you\'d expect it only to be run within a branch for \n\nlarger ones.  Depending on how many columns are displayed, there is probably is a limit of about 20/50k clients returned for html display (export to excel doesn\'t \n\nhave that client browser/memory impact).',1,1),
	(2,'Client Loans Listing','Table',NULL,'Client','select\nconcat(repeat(\"..\",\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\", c.account_no as \"Client Account No.\",\nc.display_name as \"Name\",\nr.enum_message_property as \"Client Status\",\nlo.display_name as \"Loan Officer\", l.account_no as \"Loan Account No.\", l.external_id as \"External Id\", p.name as Loan, st.enum_message_property as \"Status\",\nf.`name` as Fund, purp.code_value as \"Loan Purpose\",\nifnull(cur.display_symbol, l.currency_code) as Currency,\nl.principal_amount, l.arrearstolerance_amount as \"Arrears Tolerance Amount\",\nl.number_of_repayments as \"Expected No. Repayments\",\nl.annual_nominal_interest_rate as \" Annual Nominal Interest Rate\",\nl.nominal_interest_rate_per_period as \"Nominal Interest Rate Per Period\",\nipf.enum_message_property as \"Interest Rate Frequency\",\nim.enum_message_property as \"Interest Method\",\nicp.enum_message_property as \"Interest Calculated in Period\",\nl.term_frequency as \"Term Frequency\",\ntf.enum_message_property as \"Term Frequency Period\",\nl.repay_every as \"Repayment Frequency\",\nrf.enum_message_property as \"Repayment Frequency Period\",\nam.enum_message_property as \"Amortization\",\nl.total_charges_due_at_disbursement_derived as \"Total Charges Due At Disbursement\",\ndate(l.submittedon_date) as Submitted, date(l.approvedon_date) Approved, l.expected_disbursedon_date As \"Expected Disbursal\",\ndate(l.expected_firstrepaymenton_date) as \"Expected First Repayment\",\ndate(l.interest_calculated_from_date) as \"Interest Calculated From\" ,\ndate(l.disbursedon_date) as Disbursed,\ndate(l.expected_maturedon_date) \"Expected Maturity\",\ndate(l.maturedon_date) as \"Matured On\", date(l.closedon_date) as Closed,\ndate(l.rejectedon_date) as Rejected, date(l.rescheduledon_date) as Rescheduled,\ndate(l.withdrawnon_date) as Withdrawn, date(l.writtenoffon_date) \"Written Off\"\nfrom m_office o\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\nleft join r_enum_value r on r.enum_name = \'status_enum\'\n and r.enum_id = c.status_enum\nleft join m_loan l on l.client_id = c.id\nleft join m_staff lo on lo.id = l.loan_officer_id\nleft join m_product_loan p on p.id = l.product_id\nleft join m_fund f on f.id = l.fund_id\nleft join r_enum_value st on st.enum_name = \"loan_status_id\" and st.enum_id = l.loan_status_id\nleft join r_enum_value ipf on ipf.enum_name = \"interest_period_frequency_enum\"\n and ipf.enum_id = l.interest_period_frequency_enum\nleft join r_enum_value im on im.enum_name = \"interest_method_enum\"\n and im.enum_id = l.interest_method_enum\nleft join r_enum_value tf on tf.enum_name = \"term_period_frequency_enum\"\n and tf.enum_id = l.term_period_frequency_enum\nleft join r_enum_value icp on icp.enum_name = \"interest_calculated_in_period_enum\"\n and icp.enum_id = l.interest_calculated_in_period_enum\nleft join r_enum_value rf on rf.enum_name = \"repayment_period_frequency_enum\"\n and rf.enum_id = l.repayment_period_frequency_enum\nleft join r_enum_value am on am.enum_name = \"amortization_method_enum\"\n and am.enum_id = l.amortization_method_enum\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\nleft join m_currency cur on cur.code = l.currency_code\nwhere o.id = ${officeId}\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\norder by ounder.hierarchy, 2 , l.id','Individual Client Report\r\n\r\nPretty \n\nwide report that lists the basic details of client loans.  \r\n\r\nCan be run for any size MFI but you\'d expect it only to be run within a branch for larger ones.  \n\nThere is probably is a limit of about 20/50k clients returned for html display (export to excel doesn\'t have that client browser/memory impact).',1,1),
	(5,'Loans Awaiting Disbursal','Table',NULL,'Loan','SELECT \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nc.account_no as \"Client Account No\", c.display_name as \"Name\", l.account_no as \"Loan Account No.\", pl.`name` as \"Product\", \r\nf.`name` as Fund, ifnull(cur.display_symbol, l.currency_code) as Currency,  \r\nl.principal_amount as Principal,  \r\nl.term_frequency as \"Term Frequency\",\n\n\r\ntf.enum_message_property as \"Term Frequency Period\",\r\nl.annual_nominal_interest_rate as \" Annual Nominal Interest Rate\",\r\ndate(l.approvedon_date) \"Approved\",\r\ndatediff(l.expected_disbursedon_date, curdate()) as \"Days to Disbursal\",\r\ndate(l.expected_disbursedon_date) \"Expected Disbursal\",\r\npurp.code_value as \"Loan Purpose\",\r\n lo.display_name as \"Loan Officer\"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join r_enum_value tf on tf.enum_name = \"term_period_frequency_enum\" and tf.enum_id = l.term_period_frequency_enum\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 200\r\norder by ounder.hierarchy, datediff(l.expected_disbursedon_date, curdate()),  c.account_no','Individual Client Report',1,1),
	(6,'Loans Awaiting Disbursal Summary','Table',NULL,'Loan','SELECT \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\npl.`name` as \"Product\", \r\nifnull(cur.display_symbol, l.currency_code) as Currency,  f.`name` as Fund,\r\nsum(l.principal_amount) as Principal\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 200\r\ngroup by ounder.hierarchy, pl.`name`, l.currency_code,  f.`name`\r\norder by ounder.hierarchy, pl.`name`, l.currency_code,  f.`name`','Individual Client Report',1,1),
	(7,'Loans Awaiting Disbursal Summary by Month','Table',NULL,'Loan','SELECT \r\nconcat(repeat(\"..\",   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\npl.`name` as \"Product\", \r\nifnull(cur.display_symbol, l.currency_code) as Currency,  \r\nyear(l.expected_disbursedon_date) as \"Year\", \r\nmonthname(l.expected_disbursedon_date) as \"Month\",\r\nsum(l.principal_amount) as Principal\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 200\r\ngroup by ounder.hierarchy, pl.`name`, l.currency_code, year(l.expected_disbursedon_date), month(l.expected_disbursedon_date)\r\norder by ounder.hierarchy, pl.`name`, l.currency_code, year(l.expected_disbursedon_date), month(l.expected_disbursedon_date)','Individual Client Report',1,1),
	(8,'Loans Pending Approval','Table',NULL,'Loan','SELECT \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nc.account_no as \"Client Account No.\", c.display_name as \"Client Name\", \r\nifnull(cur.display_symbol, l.currency_code) as Currency,  pl.`name` as \"Product\", \r\nl.account_no as \"Loan Account No.\", \r\nl.principal_amount as \"Loan Amount\", \r\nl.term_frequency as \"Term Frequency\",\n\n\r\ntf.enum_message_property as \"Term Frequency Period\",\r\nl.annual_nominal_interest_rate as \" Annual \n\nNominal Interest Rate\", \r\ndatediff(curdate(), l.submittedon_date) \"Days Pending Approval\", \r\npurp.code_value as \"Loan Purpose\",\r\nlo.display_name as \"Loan Officer\"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join r_enum_value tf on tf.enum_name = \"term_period_frequency_enum\" and tf.enum_id = l.term_period_frequency_enum\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 100 /*Submitted and awaiting approval */\r\norder by ounder.hierarchy, l.submittedon_date,  l.account_no','Individual Client Report',1,1),
	(11,'Active Loans - Summary','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as \"Office/Branch\", x.currency as Currency,\r\n x.client_count as \"No. of Clients\", x.active_loan_count as \"No. Active Loans\", x. loans_in_arrears_count as \"No. of Loans in Arrears\",\r\nx.principal as \"Total Loans Disbursed\", x.principal_repaid as \"Principal Repaid\", x.principal_outstanding as \"Principal Outstanding\", x.principal_overdue as \"Principal Overdue\",\r\nx.interest as \"Total Interest\", x.interest_repaid as \"Interest Repaid\", x.interest_outstanding as \"Interest Outstanding\", x.interest_overdue as \"Interest Overdue\",\r\nx.fees as \"Total Fees\", x.fees_repaid as \"Fees Repaid\", x.fees_outstanding as \"Fees Outstanding\", x.fees_overdue as \"Fees Overdue\",\r\nx.penalties as \"Total Penalties\", x.penalties_repaid as \"Penalties Repaid\", x.penalties_outstanding as \"Penalties Outstanding\", x.penalties_overdue as \"Penalties Overdue\",\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.principal_overdue * 100) / x.principal_outstanding, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue + x.penalties_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding + x.penalties_overdue), 2) as char)\r\n	else \"invalid PAR Type\"\r\n	end) as \"Portfolio at Risk %\"\r\n from m_office mo\r\njoin \r\n(select ounder.id as branch,\r\nifnull(cur.display_symbol, l.currency_code) as currency,\r\ncount(distinct(c.id)) as client_count, \r\ncount(distinct(l.id)) as  active_loan_count,\r\ncount(distinct(if(laa.loan_id is not null,  l.id, null)  )) as loans_in_arrears_count,\r\n\r\nsum(l.principal_disbursed_derived) as principal,\r\nsum(l.principal_repaid_derived) as principal_repaid,\r\nsum(l.principal_outstanding_derived) as principal_outstanding,\r\nsum(laa.principal_overdue_derived) as principal_overdue,\r\n\r\nsum(l.interest_charged_derived) as interest,\r\nsum(l.interest_repaid_derived) as interest_repaid,\r\nsum(l.interest_outstanding_derived) as interest_outstanding,\r\nsum(laa.interest_overdue_derived) as interest_overdue,\r\n\r\nsum(l.fee_charges_charged_derived) as fees,\r\nsum(l.fee_charges_repaid_derived) as fees_repaid,\r\nsum(l.fee_charges_outstanding_derived)  as fees_outstanding,\r\nsum(laa.fee_charges_overdue_derived) as fees_overdue,\r\n\r\nsum(l.penalty_charges_charged_derived) as penalties,\r\nsum(l.penalty_charges_repaid_derived) as penalties_repaid,\r\nsum(l.penalty_charges_outstanding_derived) as penalties_outstanding,\r\nsum(laa.penalty_charges_overdue_derived) as penalties_overdue\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nleft join m_currency cur on cur.code = l.currency_code\r\n\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by ounder.id, l.currency_code) x on x.branch = mo.id\r\norder by mo.hierarchy, x.Currency',NULL,1,1),
	(12,'Active Loans - Details','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as \"Loan Officer\", \r\nc.display_name as \"Client\", l.account_no as \"Loan Account No.\", pl.`name` as \"Product\", \r\nf.`name` as Fund,  \r\nl.principal_amount as \"Loan Amount\", \r\nl.annual_nominal_interest_rate as \" Annual Nominal Interest Rate\", \r\ndate(l.disbursedon_date) as \"Disbursed Date\", \r\ndate(l.expected_maturedon_date) as \"Expected Matured On\",\r\n\r\nl.principal_repaid_derived as \"Principal Repaid\",\r\nl.principal_outstanding_derived as \"Principal Outstanding\",\r\nlaa.principal_overdue_derived as \"Principal Overdue\",\r\n\r\nl.interest_repaid_derived as \"Interest Repaid\",\r\nl.interest_outstanding_derived as \"Interest Outstanding\",\r\nlaa.interest_overdue_derived as \"Interest Overdue\",\r\n\r\nl.fee_charges_repaid_derived as \"Fees Repaid\",\r\nl.fee_charges_outstanding_derived  as \"Fees Outstanding\",\r\nlaa.fee_charges_overdue_derived as \"Fees Overdue\",\r\n\r\nl.penalty_charges_repaid_derived as \"Penalties Repaid\",\r\nl.penalty_charges_outstanding_derived as \"Penalties Outstanding\",\r\npenalty_charges_overdue_derived as \"Penalties Overdue\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no','Individual Client \n\nReport',1,1),
	(13,'Obligation Met Loans Details','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nc.account_no as \"Client Account No.\", c.display_name as \"Client\",\r\nl.account_no as \"Loan Account No.\", pl.`name` as \"Product\", \r\nf.`name` as Fund,  \r\nl.principal_amount as \"Loan Amount\", \r\nl.total_repayment_derived  as \"Total Repaid\", \r\nl.annual_nominal_interest_rate as \" Annual Nominal Interest Rate\", \r\ndate(l.disbursedon_date) as \"Disbursed\", \r\ndate(l.closedon_date) as \"Closed\",\r\n\r\nl.principal_repaid_derived as \"Principal Repaid\",\r\nl.interest_repaid_derived as \"Interest Repaid\",\r\nl.fee_charges_repaid_derived as \"Fees Repaid\",\r\nl.penalty_charges_repaid_derived as \"Penalties Repaid\",\r\nlo.display_name as \"Loan Officer\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand (case\r\n	when ${obligDateType} = 1 then\r\n    l.closedon_date between \'${startDate}\' and \'${endDate}\'\r\n	when ${obligDateType} = 2 then\r\n    l.disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\n	else 1 = 1\r\n	end)\r\nand l.loan_status_id = 600\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no','Individual Client \n\nReport',1,1),
	(14,'Obligation Met Loans Summary','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\ncount(distinct(c.id)) as \"No. of Clients\",\r\ncount(distinct(l.id)) as \"No. of Loans\",\r\nsum(l.principal_amount) as \"Total Loan Amount\", \r\nsum(l.principal_repaid_derived) as \"Total Principal Repaid\",\r\nsum(l.interest_repaid_derived) as \"Total Interest Repaid\",\r\nsum(l.fee_charges_repaid_derived) as \"Total Fees Repaid\",\r\nsum(l.penalty_charges_repaid_derived) as \"Total Penalties Repaid\",\r\nsum(l.interest_waived_derived) as \"Total Interest Waived\",\r\nsum(l.fee_charges_waived_derived) as \"Total Fees Waived\",\r\nsum(l.penalty_charges_waived_derived) as \"Total Penalties Waived\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand (case\r\n	when ${obligDateType} = 1 then\r\n    l.closedon_date between \'${startDate}\' and \'${endDate}\'\r\n	when ${obligDateType} = 2 then\r\n    l.disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\n	else 1 = 1\r\n	end)\r\nand l.loan_status_id = 600\r\ngroup by ounder.hierarchy, l.currency_code\r\norder by ounder.hierarchy, l.currency_code','Individual Client \n\nReport',1,1),
	(15,'Portfolio at Risk','Table',NULL,'Loan','select x.Currency, x.`Principal Outstanding`, x.`Principal Overdue`, x.`Interest Outstanding`, x.`Interest Overdue`, \r\nx.`Fees Outstanding`, x.`Fees Overdue`, x.`Penalties Outstanding`, x.`Penalties Overdue`,\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.`Principal Overdue` * 100) / x.`Principal Outstanding`, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding`), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding`), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue` + x.`Penalties Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding` + x.`Penalties Overdue`), 2) as char)\r\n	else \"invalid PAR Type\"\r\n	end) as \"Portfolio at Risk %\"\r\n from \r\n(select  ifnull(cur.display_symbol, l.currency_code) as Currency,  \r\nsum(l.principal_outstanding_derived) as \"Principal Outstanding\",\r\nsum(laa.principal_overdue_derived) as \"Principal Overdue\",\r\n\r\nsum(l.interest_outstanding_derived) as \"Interest Outstanding\",\r\nsum(laa.interest_overdue_derived) as \"Interest Overdue\",\r\n\r\nsum(l.fee_charges_outstanding_derived)  as \"Fees Outstanding\",\r\nsum(laa.fee_charges_overdue_derived) as \"Fees Overdue\",\r\n\r\nsum(penalty_charges_outstanding_derived) as \"Penalties Outstanding\",\r\nsum(laa.penalty_charges_overdue_derived) as \"Penalties Overdue\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin  m_loan l on l.client_id = c.id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join m_product_loan p on p.id = l.product_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by l.currency_code\r\norder by l.currency_code) x','Covers all loans.\r\n\r\nFor larger MFIs … we should add some derived fields on loan (or a 1:1 loan related table like mifos 2.x does)\r\nPrinciple, Interest, Fees, Penalties Outstanding and Overdue (possibly waived and written off too)',1,1),
	(16,'Portfolio at Risk by Branch','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as \"Office/Branch\",\r\nx.Currency, x.`Principal Outstanding`, x.`Principal Overdue`, x.`Interest Outstanding`, x.`Interest Overdue`, \r\nx.`Fees Outstanding`, x.`Fees Overdue`, x.`Penalties Outstanding`, x.`Penalties Overdue`,\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.`Principal Overdue` * 100) / x.`Principal Outstanding`, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding`), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding`), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.`Principal Overdue` + x.`Interest Overdue` + x.`Fees Overdue` + x.`Penalties Overdue`) * 100) / (x.`Principal Outstanding` + x.`Interest Outstanding` + x.`Fees Outstanding` + x.`Penalties Overdue`), 2) as char)\r\n	else \"invalid PAR Type\"\r\n	end) as \"Portfolio at Risk %\"\r\n from m_office mo\r\njoin \r\n(select  ounder.id as \"branch\", ifnull(cur.display_symbol, l.currency_code) as Currency,  \r\n\r\nsum(l.principal_outstanding_derived) as \"Principal Outstanding\",\r\nsum(laa.principal_overdue_derived) as \"Principal Overdue\",\r\n\r\nsum(l.interest_outstanding_derived) as \"Interest Outstanding\",\r\nsum(laa.interest_overdue_derived) as \"Interest Overdue\",\r\n\r\nsum(l.fee_charges_outstanding_derived)  as \"Fees Outstanding\",\r\nsum(laa.fee_charges_overdue_derived) as \"Fees Overdue\",\r\n\r\nsum(penalty_charges_outstanding_derived) as \"Penalties Outstanding\",\r\nsum(laa.penalty_charges_overdue_derived) as \"Penalties Overdue\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin  m_loan l on l.client_id = c.id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_code_value purp on purp.id = l.loanpurpose_cv_id\r\nleft join m_product_loan p on p.id = l.product_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\ngroup by ounder.id, l.currency_code) x on x.branch = mo.id\r\norder by mo.hierarchy, x.Currency','Covers all loans.\r\n\r\nFor larger MFIs … we should add some derived fields on loan (or a 1:1 loan related table like mifos 2.x does)\r\nPrinciple, Interest, Fees, Penalties Outstanding and Overdue (possibly waived and written off too)',1,1),
	(20,'Funds Disbursed Between Dates Summary','Table',NULL,'Fund','select ifnull(f.`name`, \'-\') as Fund,  ifnull(cur.display_symbol, l.currency_code) as Currency, \r\nround(sum(l.principal_amount), 4) as disbursed_amount\r\nfrom m_office ounder \r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_currency cur on cur.`code` = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nwhere disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (l.currency_code = \'${currencyId}\' or \'-1\' = \'${currencyId}\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\ngroup by ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, l.currency_code)\r\norder by ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, l.currency_code)',NULL,1,1),
	(21,'Funds Disbursed Between Dates Summary by Office','Table',NULL,'Fund','select \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\n \n\nifnull(f.`name`, \'-\') as Fund,  ifnull(cur.display_symbol, l.currency_code) as Currency, round(sum(l.principal_amount), 4) as disbursed_amount\r\nfrom m_office o\r\n\n\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c \n\non c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_currency cur on cur.`code` = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\n\n\nwhere disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\nand o.id = ${officeId}\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand \n\n(l.currency_code = \'${currencyId}\' or \'-1\' = \'${currencyId}\')\r\ngroup by ounder.`name`,  ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, \n\nl.currency_code)\r\norder by ounder.`name`,  ifnull(f.`name`, \'-\') , ifnull(cur.display_symbol, l.currency_code)',NULL,1,1),
	(48,'Balance Sheet','Pentaho',NULL,'Accounting',NULL,'Balance Sheet',1,1),
	(49,'Income Statement','Pentaho',NULL,'Accounting',NULL,'Profit and Loss Statement',1,1),
	(50,'Trial Balance','Pentaho',NULL,'Accounting',NULL,'Trial Balance Report',1,1),
	(51,'Written-Off Loans','Table',NULL,'Loan','SELECT \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, ml.currency_code) as Currency,  \r\nc.account_no as \"Client Account No.\",\r\nc.display_name AS \'Client Name\',\r\nml.account_no AS \'Loan Account No.\',\r\nmpl.name AS \'Product Name\',\r\nml.disbursedon_date AS \'Disbursed Date\',\r\nlt.transaction_date AS \'Written Off date\',\r\nml.principal_amount as \"Loan Amount\",\r\nifnull(lt.principal_portion_derived, 0) AS \'Written-Off Principal\',\r\nifnull(lt.interest_portion_derived, 0) AS \'Written-Off Interest\',\r\nifnull(lt.fee_charges_portion_derived,0) AS \'Written-Off Fees\',\r\nifnull(lt.penalty_charges_portion_derived,0) AS \'Written-Off Penalties\',\r\nn.note AS \'Reason For Write-Off\',\r\nIFNULL(ms.display_name,\'-\') AS \'Loan Officer Name\'\r\nFROM m_office o\r\nJOIN m_office ounder ON ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\nJOIN m_client c ON c.office_id = ounder.id\r\nJOIN m_loan ml ON ml.client_id = c.id\r\nJOIN m_product_loan mpl ON mpl.id=ml.product_id\r\nLEFT JOIN m_staff ms ON ms.id=ml.loan_officer_id\r\nJOIN m_loan_transaction lt ON lt.loan_id = ml.id\r\nLEFT JOIN m_note n ON n.loan_transaction_id = lt.id\r\nLEFT JOIN m_currency cur on cur.code = ml.currency_code\r\nWHERE lt.transaction_type_enum = 6 /*write-off */\r\nAND lt.is_reversed is false \r\nAND ml.loan_status_id=601\r\nAND o.id=${officeId}\r\nAND (mpl.id=${loanProductId} OR ${loanProductId}=-1)\r\nAND lt.transaction_date BETWEEN \'${startDate}\' AND \'${endDate}\'\r\nAND (ml.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\") \r\nORDER BY ounder.hierarchy, ifnull(cur.display_symbol, ml.currency_code), ml.account_no','Individual Lending Report. Written Off Loans',1,1),
	(52,'Aging Detail','Table',NULL,'Loan','\r\nSELECT \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, ml.currency_code) as Currency,  \r\nmc.account_no as \"Client Account No.\",\r\n 	mc.display_name AS \"Client Name\",\r\n 	ml.account_no AS \"Account Number\",\r\n 	ml.principal_amount AS \"Loan Amount\",\r\n ml.principal_disbursed_derived AS \"Original Principal\",\r\n ml.interest_charged_derived AS \"Original Interest\",\r\n ml.principal_repaid_derived AS \"Principal Paid\",\r\n ml.interest_repaid_derived AS \"Interest Paid\",\r\n laa.principal_overdue_derived AS \"Principal Overdue\",\r\n laa.interest_overdue_derived AS \"Interest Overdue\",\r\nDATEDIFF(CURDATE(), laa.overdue_since_date_derived) as \"Days in Arrears\",\r\n\r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<7, \'<1\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<8, \' 1\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<15,  \'2\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<22, \' 3\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<29, \' 4\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<36, \' 5\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<43, \' 6\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<50, \' 7\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<57, \' 8\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<64, \' 9\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<71, \'10\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<78, \'11\', \r\n 	IF(DATEDIFF(CURDATE(), laa.overdue_since_date_derived)<85, \'12\', \'12+\')))))))))))) )AS \"Weeks In Arrears Band\",\r\n\r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<31, \'0 - 30\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<61, \'30 - 60\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<91, \'60 - 90\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<181, \'90 - 180\', \r\n		IF(DATEDIFF(CURDATE(),  laa.overdue_since_date_derived)<361, \'180 - 360\', \r\n				 \'> 360\'))))) AS \"Days in Arrears Band\"\r\n\r\n	FROM m_office mo \r\n    JOIN m_office ounder ON ounder.hierarchy like concat(mo.hierarchy, \'%\')\r\n	        AND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n    INNER JOIN m_client mc ON mc.office_id=ounder.id\r\n	    INNER JOIN m_loan ml ON ml.client_id = mc.id\r\n	    INNER JOIN r_enum_value rev ON rev.enum_id=ml.loan_status_id AND rev.enum_name = \'loan_status_id\'\r\n    INNER JOIN m_loan_arrears_aging laa ON laa.loan_id=ml.id\r\n    left join m_currency cur on cur.code = ml.currency_code\r\n	WHERE ml.loan_status_id=300\r\n    AND mo.id=${officeId}\r\nORDER BY ounder.hierarchy, ifnull(cur.display_symbol, ml.currency_code), ml.account_no\r\n','Loan arrears aging (Weeks)',1,1),
	(53,'Aging Summary (Arrears in Weeks)','Table',NULL,'Loan','SELECT \r\n  IFNULL(periods.currencyName, periods.currency) as currency, \r\n  periods.period_no \'Weeks In Arrears (Up To)\', \r\n  IFNULL(ars.loanId, 0) \'No Of Loans\', \r\n  IFNULL(ars.principal,0.0) \'Original Principal\', \r\n  IFNULL(ars.interest,0.0) \'Original Interest\', \r\n  IFNULL(ars.prinPaid,0.0) \'Principal Paid\', \r\n  IFNULL(ars.intPaid,0.0) \'Interest Paid\', \r\n  IFNULL(ars.prinOverdue,0.0) \'Principal Overdue\', \r\n  IFNULL(ars.intOverdue,0.0)\'Interest Overdue\'\r\nFROM \r\n	/* full table of aging periods/currencies used combo to ensure each line represented */\r\n  (SELECT curs.code as currency, curs.name as currencyName, pers.* from\r\n	(SELECT \'On Schedule\' period_no,1 pid UNION\r\n		SELECT \'1\',2 UNION\r\n		SELECT \'2\',3 UNION\r\n		SELECT \'3\',4 UNION\r\n		SELECT \'4\',5 UNION\r\n		SELECT \'5\',6 UNION\r\n		SELECT \'6\',7 UNION\r\n		SELECT \'7\',8 UNION\r\n		SELECT \'8\',9 UNION\r\n		SELECT \'9\',10 UNION\r\n		SELECT \'10\',11 UNION\r\n		SELECT \'11\',12 UNION\r\n		SELECT \'12\',13 UNION\r\n		SELECT \'12+\',14) pers,\r\n	(SELECT distinctrow moc.code, moc.name\r\n  	FROM m_office mo2\r\n   	INNER JOIN m_office ounder2 ON ounder2.hierarchy \r\n				LIKE CONCAT(mo2.hierarchy, \'%\')\r\nAND ounder2.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   	INNER JOIN m_client mc2 ON mc2.office_id=ounder2.id\r\n   	INNER JOIN m_loan ml2 ON ml2.client_id = mc2.id\r\n	INNER JOIN m_organisation_currency moc ON moc.code = ml2.currency_code\r\n	WHERE ml2.loan_status_id=300 /* active */\r\n	AND mo2.id=${officeId}\r\nAND (ml2.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")) curs) periods\r\n\r\n\r\nLEFT JOIN /* table of aging periods per currency with gaps if no applicable loans */\r\n(SELECT \r\n  	z.currency, z.arrPeriod, \r\n	COUNT(z.loanId) as loanId, SUM(z.principal) as principal, SUM(z.interest) as interest, \r\n	SUM(z.prinPaid) as prinPaid, SUM(z.intPaid) as intPaid, \r\n	SUM(z.prinOverdue) as prinOverdue, SUM(z.intOverdue) as intOverdue\r\nFROM\r\n	/*derived table just used to get arrPeriod value (was much slower to\r\n	duplicate calc of minOverdueDate in inner query)\r\nmight not be now with derived fields but didn’t check */\r\n	(SELECT x.loanId, x.currency, x.principal, x.interest, x.prinPaid, x.intPaid, x.prinOverdue, x.intOverdue,\r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<1, \'On Schedule\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<8, \'1\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<15, \'2\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<22, \'3\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<29, \'4\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<36, \'5\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<43, \'6\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<50, \'7\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<57, \'8\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<64, \'9\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<71, \'10\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<78, \'11\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<85, \'12\',\r\n				 \'12+\'))))))))))))) AS arrPeriod\r\n\r\n	FROM /* get the individual loan details */\r\n		(SELECT ml.id AS loanId, ml.currency_code as currency,\r\n   			ml.principal_disbursed_derived as principal, \r\n			   ml.interest_charged_derived as interest, \r\n   			ml.principal_repaid_derived as prinPaid, \r\n			   ml.interest_repaid_derived intPaid,\r\n\r\n			   laa.principal_overdue_derived as prinOverdue,\r\n			   laa.interest_overdue_derived as intOverdue,\r\n\r\n			   IFNULL(laa.overdue_since_date_derived, curdate()) as minOverdueDate\r\n			  \r\n  		FROM m_office mo\r\n   		INNER JOIN m_office ounder ON ounder.hierarchy \r\n				LIKE CONCAT(mo.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   		INNER JOIN m_client mc ON mc.office_id=ounder.id\r\n   		INNER JOIN m_loan ml ON ml.client_id = mc.id\r\n		   LEFT JOIN m_loan_arrears_aging laa on laa.loan_id = ml.id\r\n		WHERE ml.loan_status_id=300 /* active */\r\n     		AND mo.id=${officeId}\r\n     AND (ml.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\n  		GROUP BY ml.id) x\r\n	) z \r\nGROUP BY z.currency, z.arrPeriod ) ars ON ars.arrPeriod=periods.period_no and ars.currency = periods.currency\r\nORDER BY periods.currency, periods.pid','Loan amount in arrears by branch',1,1),
	(54,'Rescheduled Loans','Table',NULL,'Loan','SELECT \r\nconcat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, ml.currency_code) as Currency,  \r\nc.account_no as \"Client Account No.\",\r\nc.display_name AS \'Client Name\',\r\nml.account_no AS \'Loan Account No.\',\r\nmpl.name AS \'Product Name\',\r\nml.disbursedon_date AS \'Disbursed Date\',\r\nlt.transaction_date AS \'Written Off date\',\r\nml.principal_amount as \"Loan Amount\",\r\nifnull(lt.principal_portion_derived, 0) AS \'Rescheduled Principal\',\r\nifnull(lt.interest_portion_derived, 0) AS \'Rescheduled Interest\',\r\nifnull(lt.fee_charges_portion_derived,0) AS \'Rescheduled Fees\',\r\nifnull(lt.penalty_charges_portion_derived,0) AS \'Rescheduled Penalties\',\r\nn.note AS \'Reason For Rescheduling\',\r\nIFNULL(ms.display_name,\'-\') AS \'Loan Officer Name\'\r\nFROM m_office o\r\nJOIN m_office ounder ON ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\nJOIN m_client c ON c.office_id = ounder.id\r\nJOIN m_loan ml ON ml.client_id = c.id\r\nJOIN m_product_loan mpl ON mpl.id=ml.product_id\r\nLEFT JOIN m_staff ms ON ms.id=ml.loan_officer_id\r\nJOIN m_loan_transaction lt ON lt.loan_id = ml.id\r\nLEFT JOIN m_note n ON n.loan_transaction_id = lt.id\r\nLEFT JOIN m_currency cur on cur.code = ml.currency_code\r\nWHERE lt.transaction_type_enum = 7 /*marked for rescheduling */\r\nAND lt.is_reversed is false \r\nAND ml.loan_status_id=602\r\nAND o.id=${officeId}\r\nAND (mpl.id=${loanProductId} OR ${loanProductId}=-1)\r\nAND lt.transaction_date BETWEEN \'${startDate}\' AND \'${endDate}\'\r\nAND (ml.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nORDER BY ounder.hierarchy, ifnull(cur.display_symbol, ml.currency_code), ml.account_no','Individual Lending Report. Rescheduled Loans.  The ability to reschedule (or mark that you have rescheduled the loan elsewhere) is a legacy of the older Mifos product.  Needed for migration.',1,1),
	(55,'Active Loans Passed Final Maturity','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as \"Loan Officer\", \r\nc.display_name as \"Client\", l.account_no as \"Loan Account No.\", pl.`name` as \"Product\", \r\nf.`name` as Fund,  \r\nl.principal_amount as \"Loan Amount\", \r\nl.annual_nominal_interest_rate as \" Annual Nominal Interest Rate\", \r\ndate(l.disbursedon_date) as \"Disbursed Date\", \r\ndate(l.expected_maturedon_date) as \"Expected Matured On\",\r\n\r\nl.principal_repaid_derived as \"Principal Repaid\",\r\nl.principal_outstanding_derived as \"Principal Outstanding\",\r\nlaa.principal_overdue_derived as \"Principal Overdue\",\r\n\r\nl.interest_repaid_derived as \"Interest Repaid\",\r\nl.interest_outstanding_derived as \"Interest Outstanding\",\r\nlaa.interest_overdue_derived as \"Interest Overdue\",\r\n\r\nl.fee_charges_repaid_derived as \"Fees Repaid\",\r\nl.fee_charges_outstanding_derived  as \"Fees Outstanding\",\r\nlaa.fee_charges_overdue_derived as \"Fees Overdue\",\r\n\r\nl.penalty_charges_repaid_derived as \"Penalties Repaid\",\r\nl.penalty_charges_outstanding_derived as \"Penalties Outstanding\",\r\nlaa.penalty_charges_overdue_derived as \"Penalties Overdue\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand l.expected_maturedon_date < curdate()\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no','Individual Client \n\nReport',1,1),
	(56,'Active Loans Passed Final Maturity Summary','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as \"Office/Branch\", x.currency as Currency,\r\n x.client_count as \"No. of Clients\", x.active_loan_count as \"No. Active Loans\", x. arrears_loan_count as \"No. of Loans in Arrears\",\r\nx.principal as \"Total Loans Disbursed\", x.principal_repaid as \"Principal Repaid\", x.principal_outstanding as \"Principal Outstanding\", x.principal_overdue as \"Principal Overdue\",\r\nx.interest as \"Total Interest\", x.interest_repaid as \"Interest Repaid\", x.interest_outstanding as \"Interest Outstanding\", x.interest_overdue as \"Interest Overdue\",\r\nx.fees as \"Total Fees\", x.fees_repaid as \"Fees Repaid\", x.fees_outstanding as \"Fees Outstanding\", x.fees_overdue as \"Fees Overdue\",\r\nx.penalties as \"Total Penalties\", x.penalties_repaid as \"Penalties Repaid\", x.penalties_outstanding as \"Penalties Outstanding\", x.penalties_overdue as \"Penalties Overdue\",\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.principal_overdue * 100) / x.principal_outstanding, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue + x.penalties_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding + x.penalties_overdue), 2) as char)\r\n	else \"invalid PAR Type\"\r\n	end) as \"Portfolio at Risk %\"\r\n from m_office mo\r\njoin \r\n(select ounder.id as branch,\r\nifnull(cur.display_symbol, l.currency_code) as currency,\r\ncount(distinct(c.id)) as client_count, \r\ncount(distinct(l.id)) as  active_loan_count,\r\ncount(distinct(laa.loan_id)  ) as arrears_loan_count,\r\n\r\nsum(l.principal_disbursed_derived) as principal,\r\nsum(l.principal_repaid_derived) as principal_repaid,\r\nsum(l.principal_outstanding_derived) as principal_outstanding,\r\nsum(ifnull(laa.principal_overdue_derived,0)) as principal_overdue,\r\n\r\nsum(l.interest_charged_derived) as interest,\r\nsum(l.interest_repaid_derived) as interest_repaid,\r\nsum(l.interest_outstanding_derived) as interest_outstanding,\r\nsum(ifnull(laa.interest_overdue_derived,0)) as interest_overdue,\r\n\r\nsum(l.fee_charges_charged_derived) as fees,\r\nsum(l.fee_charges_repaid_derived) as fees_repaid,\r\nsum(l.fee_charges_outstanding_derived)  as fees_outstanding,\r\nsum(ifnull(laa.fee_charges_overdue_derived,0)) as fees_overdue,\r\n\r\nsum(l.penalty_charges_charged_derived) as penalties,\r\nsum(l.penalty_charges_repaid_derived) as penalties_repaid,\r\nsum(l.penalty_charges_outstanding_derived) as penalties_outstanding,\r\nsum(ifnull(laa.penalty_charges_overdue_derived,0)) as penalties_overdue\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\n\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand l.expected_maturedon_date < curdate()\r\ngroup by ounder.id, l.currency_code) x on x.branch = mo.id\r\norder by mo.hierarchy, x.Currency',NULL,1,1),
	(57,'Active Loans in last installment','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(lastInstallment.`hierarchy`) - LENGTH(REPLACE(lastInstallment.`hierarchy`, \'.\', \'\')) - 1))), lastInstallment.branch) as \"Office/Branch\",\r\nlastInstallment.Currency,\r\nlastInstallment.`Loan Officer`, \r\nlastInstallment.`Client Account No`, lastInstallment.`Client`, \r\nlastInstallment.`Loan Account No`, lastInstallment.`Product`, \r\nlastInstallment.`Fund`,  lastInstallment.`Loan Amount`, \r\nlastInstallment.`Annual Nominal Interest Rate`, \r\nlastInstallment.`Disbursed`, lastInstallment.`Expected Matured On` ,\r\n\r\nl.principal_repaid_derived as \"Principal Repaid\",\r\nl.principal_outstanding_derived as \"Principal Outstanding\",\r\nlaa.principal_overdue_derived as \"Principal Overdue\",\r\n\r\nl.interest_repaid_derived as \"Interest Repaid\",\r\nl.interest_outstanding_derived as \"Interest Outstanding\",\r\nlaa.interest_overdue_derived as \"Interest Overdue\",\r\n\r\nl.fee_charges_repaid_derived as \"Fees Repaid\",\r\nl.fee_charges_outstanding_derived  as \"Fees Outstanding\",\r\nlaa.fee_charges_overdue_derived as \"Fees Overdue\",\r\n\r\nl.penalty_charges_repaid_derived as \"Penalties Repaid\",\r\nl.penalty_charges_outstanding_derived as \"Penalties Outstanding\",\r\nlaa.penalty_charges_overdue_derived as \"Penalties Overdue\"\r\n\r\nfrom \r\n(select l.id as loanId, l.number_of_repayments, min(r.installment), \r\nounder.id, ounder.hierarchy, ounder.`name` as branch, \r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as \"Loan Officer\", c.account_no as \"Client Account No\",\r\nc.display_name as \"Client\", l.account_no as \"Loan Account No\", pl.`name` as \"Product\", \r\nf.`name` as Fund,  l.principal_amount as \"Loan Amount\", \r\nl.annual_nominal_interest_rate as \"Annual Nominal Interest Rate\", \r\ndate(l.disbursedon_date) as \"Disbursed\", date(l.expected_maturedon_date) as \"Expected Matured On\"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_repayment_schedule r on r.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand r.completed_derived is false\r\nand r.duedate >= curdate()\r\ngroup by l.id\r\nhaving l.number_of_repayments = min(r.installment)) lastInstallment\r\njoin m_loan l on l.id = lastInstallment.loanId\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\norder by lastInstallment.hierarchy, lastInstallment.Currency, lastInstallment.`Client Account No`, lastInstallment.`Loan Account No`','Individual Client \n\nReport',1,1),
	(58,'Active Loans in last installment Summary','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(mo.`hierarchy`) - LENGTH(REPLACE(mo.`hierarchy`, \'.\', \'\')) - 1))), mo.`name`) as \"Office/Branch\", x.currency as Currency,\r\n x.client_count as \"No. of Clients\", x.active_loan_count as \"No. Active Loans\", x. arrears_loan_count as \"No. of Loans in Arrears\",\r\nx.principal as \"Total Loans Disbursed\", x.principal_repaid as \"Principal Repaid\", x.principal_outstanding as \"Principal Outstanding\", x.principal_overdue as \"Principal Overdue\",\r\nx.interest as \"Total Interest\", x.interest_repaid as \"Interest Repaid\", x.interest_outstanding as \"Interest Outstanding\", x.interest_overdue as \"Interest Overdue\",\r\nx.fees as \"Total Fees\", x.fees_repaid as \"Fees Repaid\", x.fees_outstanding as \"Fees Outstanding\", x.fees_overdue as \"Fees Overdue\",\r\nx.penalties as \"Total Penalties\", x.penalties_repaid as \"Penalties Repaid\", x.penalties_outstanding as \"Penalties Outstanding\", x.penalties_overdue as \"Penalties Overdue\",\r\n\r\n	(case\r\n	when ${parType} = 1 then\r\n    cast(round((x.principal_overdue * 100) / x.principal_outstanding, 2) as char)\r\n	when ${parType} = 2 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding), 2) as char)\r\n	when ${parType} = 3 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding), 2) as char)\r\n	when ${parType} = 4 then\r\n    cast(round(((x.principal_overdue + x.interest_overdue + x.fees_overdue + x.penalties_overdue) * 100) / (x.principal_outstanding + x.interest_outstanding + x.fees_outstanding + x.penalties_overdue), 2) as char)\r\n	else \"invalid PAR Type\"\r\n	end) as \"Portfolio at Risk %\"\r\n from m_office mo\r\njoin \r\n(select lastInstallment.branchId as branchId,\r\nlastInstallment.Currency,\r\ncount(distinct(lastInstallment.clientId)) as client_count, \r\ncount(distinct(lastInstallment.loanId)) as  active_loan_count,\r\ncount(distinct(laa.loan_id)  ) as arrears_loan_count,\r\n\r\nsum(l.principal_disbursed_derived) as principal,\r\nsum(l.principal_repaid_derived) as principal_repaid,\r\nsum(l.principal_outstanding_derived) as principal_outstanding,\r\nsum(ifnull(laa.principal_overdue_derived,0)) as principal_overdue,\r\n\r\nsum(l.interest_charged_derived) as interest,\r\nsum(l.interest_repaid_derived) as interest_repaid,\r\nsum(l.interest_outstanding_derived) as interest_outstanding,\r\nsum(ifnull(laa.interest_overdue_derived,0)) as interest_overdue,\r\n\r\nsum(l.fee_charges_charged_derived) as fees,\r\nsum(l.fee_charges_repaid_derived) as fees_repaid,\r\nsum(l.fee_charges_outstanding_derived)  as fees_outstanding,\r\nsum(ifnull(laa.fee_charges_overdue_derived,0)) as fees_overdue,\r\n\r\nsum(l.penalty_charges_charged_derived) as penalties,\r\nsum(l.penalty_charges_repaid_derived) as penalties_repaid,\r\nsum(l.penalty_charges_outstanding_derived) as penalties_outstanding,\r\nsum(ifnull(laa.penalty_charges_overdue_derived,0)) as penalties_overdue\r\n\r\nfrom \r\n(select l.id as loanId, l.number_of_repayments, min(r.installment), \r\nounder.id as branchId, ounder.hierarchy, ounder.`name` as branch, \r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nlo.display_name as \"Loan Officer\", c.id as clientId, c.account_no as \"Client Account No\",\r\nc.display_name as \"Client\", l.account_no as \"Loan Account No\", pl.`name` as \"Product\", \r\nf.`name` as Fund,  l.principal_amount as \"Loan Amount\", \r\nl.annual_nominal_interest_rate as \"Annual Nominal Interest Rate\", \r\ndate(l.disbursedon_date) as \"Disbursed\", date(l.expected_maturedon_date) as \"Expected Matured On\"\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_repayment_schedule r on r.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.loan_status_id = 300\r\nand r.completed_derived is false\r\nand r.duedate >= curdate()\r\ngroup by l.id\r\nhaving l.number_of_repayments = min(r.installment)) lastInstallment\r\njoin m_loan l on l.id = lastInstallment.loanId\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\ngroup by lastInstallment.branchId) x on x.branchId = mo.id\r\norder by mo.hierarchy, x.Currency','Individual Client \n\nReport',1,1),
	(59,'Active Loans by Disbursal Period','Table',NULL,'Loan','select concat(repeat(\"..\",   \r\n   ((LENGTH(ounder.`hierarchy`) - LENGTH(REPLACE(ounder.`hierarchy`, \'.\', \'\')) - 1))), ounder.`name`) as \"Office/Branch\",\r\nifnull(cur.display_symbol, l.currency_code) as Currency,\r\nc.account_no as \"Client Account No\", c.display_name as \"Client\", l.account_no as \"Loan Account No\", pl.`name` as \"Product\", \r\nf.`name` as Fund,  \r\nl.principal_amount as \"Loan Principal Amount\", \r\nl.annual_nominal_interest_rate as \" Annual Nominal Interest Rate\", \r\ndate(l.disbursedon_date) as \"Disbursed Date\", \r\n\r\nl.total_expected_repayment_derived as \"Total Loan (P+I+F+Pen)\",\r\nl.total_repayment_derived as \"Total Repaid (P+I+F+Pen)\",\r\nlo.display_name as \"Loan Officer\"\r\n\r\nfrom m_office o \r\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\r\nand ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\r\njoin m_client c on c.office_id = ounder.id\r\njoin m_loan l on l.client_id = c.id\r\njoin m_product_loan pl on pl.id = l.product_id\r\nleft join m_staff lo on lo.id = l.loan_officer_id\r\nleft join m_currency cur on cur.code = l.currency_code\r\nleft join m_fund f on f.id = l.fund_id\r\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\r\nwhere o.id = ${officeId}\r\nand (l.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\nand (l.product_id = \"${loanProductId}\" or \"-1\" = \"${loanProductId}\")\r\nand (ifnull(l.loan_officer_id, -10) = \"${loanOfficerId}\" or \"-1\" = \"${loanOfficerId}\")\r\nand (ifnull(l.fund_id, -10) = ${fundId} or -1 = ${fundId})\r\nand (ifnull(l.loanpurpose_cv_id, -10) = ${loanPurposeId} or -1 = ${loanPurposeId})\r\nand l.disbursedon_date between \'${startDate}\' and \'${endDate}\'\r\nand l.loan_status_id = 300\r\ngroup by l.id\r\norder by ounder.hierarchy, l.currency_code, c.account_no, l.account_no','Individual Client \n\nReport',1,1),
	(61,'Aging Summary (Arrears in Months)','Table',NULL,'Loan','SELECT \r\n  IFNULL(periods.currencyName, periods.currency) as currency, \r\n  periods.period_no \'Days In Arrears\', \r\n  IFNULL(ars.loanId, 0) \'No Of Loans\', \r\n  IFNULL(ars.principal,0.0) \'Original Principal\', \r\n  IFNULL(ars.interest,0.0) \'Original Interest\', \r\n  IFNULL(ars.prinPaid,0.0) \'Principal Paid\', \r\n  IFNULL(ars.intPaid,0.0) \'Interest Paid\', \r\n  IFNULL(ars.prinOverdue,0.0) \'Principal Overdue\', \r\n  IFNULL(ars.intOverdue,0.0)\'Interest Overdue\'\r\nFROM \r\n	/* full table of aging periods/currencies used combo to ensure each line represented */\r\n  (SELECT curs.code as currency, curs.name as currencyName, pers.* from\r\n	(SELECT \'On Schedule\' period_no,1 pid UNION\r\n		SELECT \'0 - 30\',2 UNION\r\n		SELECT \'30 - 60\',3 UNION\r\n		SELECT \'60 - 90\',4 UNION\r\n		SELECT \'90 - 180\',5 UNION\r\n		SELECT \'180 - 360\',6 UNION\r\n		SELECT \'> 360\',7 ) pers,\r\n	(SELECT distinctrow moc.code, moc.name\r\n  	FROM m_office mo2\r\n   	INNER JOIN m_office ounder2 ON ounder2.hierarchy \r\n				LIKE CONCAT(mo2.hierarchy, \'%\')\r\nAND ounder2.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   	INNER JOIN m_client mc2 ON mc2.office_id=ounder2.id\r\n   	INNER JOIN m_loan ml2 ON ml2.client_id = mc2.id\r\n	INNER JOIN m_organisation_currency moc ON moc.code = ml2.currency_code\r\n	WHERE ml2.loan_status_id=300 /* active */\r\n	AND mo2.id=${officeId}\r\nAND (ml2.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")) curs) periods\r\n\r\n\r\nLEFT JOIN /* table of aging periods per currency with gaps if no applicable loans */\r\n(SELECT \r\n  	z.currency, z.arrPeriod, \r\n	COUNT(z.loanId) as loanId, SUM(z.principal) as principal, SUM(z.interest) as interest, \r\n	SUM(z.prinPaid) as prinPaid, SUM(z.intPaid) as intPaid, \r\n	SUM(z.prinOverdue) as prinOverdue, SUM(z.intOverdue) as intOverdue\r\nFROM\r\n	/*derived table just used to get arrPeriod value (was much slower to\r\n	duplicate calc of minOverdueDate in inner query)\r\nmight not be now with derived fields but didn’t check */\r\n	(SELECT x.loanId, x.currency, x.principal, x.interest, x.prinPaid, x.intPaid, x.prinOverdue, x.intOverdue,\r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<1, \'On Schedule\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<31, \'0 - 30\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<61, \'30 - 60\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<91, \'60 - 90\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<181, \'90 - 180\', \r\n		IF(DATEDIFF(CURDATE(), minOverdueDate)<361, \'180 - 360\', \r\n				 \'> 360\')))))) AS arrPeriod\r\n\r\n	FROM /* get the individual loan details */\r\n		(SELECT ml.id AS loanId, ml.currency_code as currency,\r\n   			ml.principal_disbursed_derived as principal, \r\n			   ml.interest_charged_derived as interest, \r\n   			ml.principal_repaid_derived as prinPaid, \r\n			   ml.interest_repaid_derived intPaid,\r\n\r\n			   laa.principal_overdue_derived as prinOverdue,\r\n			   laa.interest_overdue_derived as intOverdue,\r\n\r\n			   IFNULL(laa.overdue_since_date_derived, curdate()) as minOverdueDate\r\n			  \r\n  		FROM m_office mo\r\n   		INNER JOIN m_office ounder ON ounder.hierarchy \r\n				LIKE CONCAT(mo.hierarchy, \'%\')\r\nAND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n   		INNER JOIN m_client mc ON mc.office_id=ounder.id\r\n   		INNER JOIN m_loan ml ON ml.client_id = mc.id\r\n		   LEFT JOIN m_loan_arrears_aging laa on laa.loan_id = ml.id\r\n		WHERE ml.loan_status_id=300 /* active */\r\n     		AND mo.id=${officeId}\r\n     AND (ml.currency_code = \"${currencyId}\" or \"-1\" = \"${currencyId}\")\r\n  		GROUP BY ml.id) x\r\n	) z \r\nGROUP BY z.currency, z.arrPeriod ) ars ON ars.arrPeriod=periods.period_no and ars.currency = periods.currency\r\nORDER BY periods.currency, periods.pid','Loan amount in arrears by branch',1,1),
	(91,'Loan Account Schedule','Pentaho',NULL,'Loan',NULL,NULL,1,0),
	(92,'Branch Expected Cash Flow','Pentaho',NULL,'Loan',NULL,NULL,1,1),
	(93,'Expected Payments By Date - Basic','Table',NULL,'Loan','SELECT \r\n      ounder.name \'Office\', \r\n      IFNULL(ms.display_name,\'-\') \'Loan Officer\',\r\n	  mc.account_no \'Client Account Number\',\r\n	  mc.display_name \'Name\',\r\n	  mp.name \'Product\',\r\n	  ml.account_no \'Loan Account Number\',\r\n	  mr.duedate \'Due Date\',\r\n	  mr.installment \'Installment\',\r\n	  cu.display_symbol \'Currency\',\r\n	  mr.principal_amount- IFNULL(mr.principal_completed_derived,0) \'Principal Due\',\r\n	  mr.interest_amount- IFNULL(IFNULL(mr.interest_completed_derived,mr.interest_waived_derived),0) \'Interest Due\', \r\n	  IFNULL(mr.fee_charges_amount,0)- IFNULL(IFNULL(mr.fee_charges_completed_derived,mr.fee_charges_waived_derived),0) \'Fees Due\', \r\n	  IFNULL(mr.penalty_charges_amount,0)- IFNULL(IFNULL(mr.penalty_charges_completed_derived,mr.penalty_charges_waived_derived),0) \'Penalty Due\',\r\n      (mr.principal_amount- IFNULL(mr.principal_completed_derived,0)) +\r\n       (mr.interest_amount- IFNULL(IFNULL(mr.interest_completed_derived,mr.interest_waived_derived),0)) + \r\n       (IFNULL(mr.fee_charges_amount,0)- IFNULL(IFNULL(mr.fee_charges_completed_derived,mr.fee_charges_waived_derived),0)) + \r\n       (IFNULL(mr.penalty_charges_amount,0)- IFNULL(IFNULL(mr.penalty_charges_completed_derived,mr.penalty_charges_waived_derived),0)) \'Total Due\', \r\n     mlaa.total_overdue_derived \'Total Overdue\'\r\n										 \r\n FROM m_office mo\r\n  JOIN m_office ounder ON ounder.hierarchy LIKE CONCAT(mo.hierarchy, \'%\')\r\n  \r\n  AND ounder.hierarchy like CONCAT(\'${currentUserHierarchy}\', \'%\')\r\n	\r\n  LEFT JOIN m_client mc ON mc.office_id=ounder.id\r\n  LEFT JOIN m_loan ml ON ml.client_id=mc.id AND ml.loan_status_id=300\r\n  LEFT JOIN m_loan_arrears_aging mlaa ON mlaa.loan_id=ml.id\r\n  LEFT JOIN m_loan_repayment_schedule mr ON mr.loan_id=ml.id AND mr.completed_derived=0\r\n  LEFT JOIN m_product_loan mp ON mp.id=ml.product_id\r\n  LEFT JOIN m_staff ms ON ms.id=ml.loan_officer_id\r\n  LEFT JOIN m_currency cu ON cu.code=ml.currency_code\r\n WHERE mo.id=${officeId}\r\n AND (IFNULL(ml.loan_officer_id, -10) = \"${loanOfficerId}\" OR \"-1\" = \"${loanOfficerId}\")\r\n AND mr.duedate BETWEEN \'${startDate}\' AND \'${endDate}\'\r\n ORDER BY ounder.id,mr.duedate,ml.account_no','Test',1,1),
	(94,'Expected Payments By Date - Formatted','Pentaho',NULL,'Loan',NULL,NULL,1,1),
	(96,'GroupSummaryCounts','Table',NULL,NULL,'\n/*\nActive Client is a client linked to the \'group\' via m_group_client\nand with an active \'status_enum\'.)\nActive Borrowers - Borrower may be a client or a \'group\'\n*/\nselect x.*\nfrom m_office o,\nm_group g,\n\n(select a.activeClients,\n(b.activeClientLoans + c.activeGroupLoans) as activeLoans,\nb.activeClientLoans, c.activeGroupLoans,\n(b.activeClientBorrowers + c.activeGroupBorrowers) as activeBorrowers,\nb.activeClientBorrowers, c.activeGroupBorrowers,\n(b.overdueClientLoans +  c.overdueGroupLoans) as overdueLoans,\nb.overdueClientLoans, c.overdueGroupLoans\nfrom\n(select count(*) as activeClients\nfrom m_group topgroup\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_group_client gc on gc.group_id = g.id\njoin m_client c on c.id = gc.client_id\nwhere topgroup.id = ${groupId}\nand c.status_enum = 300) a,\n\n(select count(*) as activeClientLoans,\ncount(distinct(l.client_id)) as activeClientBorrowers,\nifnull(sum(if(laa.loan_id is not null, 1, 0)), 0) as overdueClientLoans\nfrom m_group topgroup\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_loan l on l.group_id = g.id and l.client_id is not null\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nwhere topgroup.id = ${groupId}\nand l.loan_status_id = 300) b,\n\n(select count(*) as activeGroupLoans,\ncount(distinct(l.group_id)) as activeGroupBorrowers,\nifnull(sum(if(laa.loan_id is not null, 1, 0)), 0) as overdueGroupLoans\nfrom m_group topgroup\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_loan l on l.group_id = g.id and l.client_id is null\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nwhere topgroup.id = ${groupId}\nand l.loan_status_id = 300) c\n) x\n\nwhere g.id = ${groupId}\nand o.id = g.office_id\nand o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\n','Utility query for getting group summary count details for a group_id',1,0),
	(97,'GroupSummaryAmounts','Table',NULL,NULL,'\nselect ifnull(cur.display_symbol, l.currency_code) as currency,\nifnull(sum(l.principal_disbursed_derived),0) as totalDisbursedAmount,\nifnull(sum(l.principal_outstanding_derived),0) as totalLoanOutstandingAmount,\ncount(laa.loan_id) as overdueLoans, ifnull(sum(laa.total_overdue_derived), 0) as totalLoanOverdueAmount\nfrom m_group topgroup\njoin m_office o on o.id = topgroup.office_id and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_loan l on l.group_id = g.id\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_currency cur on cur.code = l.currency_code\nwhere topgroup.id = ${groupId}\nand l.disbursedon_date is not null\ngroup by l.currency_code\n','Utility query for getting group summary currency amount details for a group_id',1,0),
	(106,'TxnRunningBalances','Table',NULL,'Transaction','\nselect date(\'${startDate}\') as \'Transaction Date\', \'Opening Balance\' as `Transaction Type`, null as Office,\n	null as \'Loan Officer\', null as `Loan Account No`, null as `Loan Product`, null as `Currency`,\n	null as `Client Account No`, null as Client,\n	null as Amount, null as Principal, null as Interest,\n@totalOutstandingPrincipal :=\nifnull(round(sum(\n	if (txn.transaction_type_enum = 1 /* disbursement */,\n		ifnull(txn.amount,0.00),\n		ifnull(txn.principal_portion_derived,0.00) * -1))\n			,2),0.00)  as \'Outstanding Principal\',\n\n@totalInterestIncome :=\nifnull(round(sum(\n	if (txn.transaction_type_enum in (2,5,8) /* repayment, repayment at disbursal, recovery repayment */,\n		ifnull(txn.interest_portion_derived,0.00),\n		0))\n			,2),0.00) as \'Interest Income\',\n\n@totalWriteOff :=\nifnull(round(sum(\n	if (txn.transaction_type_enum = 6 /* write-off */,\n		ifnull(txn.principal_portion_derived,0.00),\n		0))\n			,2),0.00) as \'Principal Write Off\'\nfrom m_office o\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\n                          and ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\njoin m_loan l on l.client_id = c.id\njoin m_product_loan lp on lp.id = l.product_id\njoin m_loan_transaction txn on txn.loan_id = l.id\nleft join m_currency cur on cur.code = l.currency_code\nwhere txn.is_reversed = false\nand txn.transaction_type_enum not in (10,11)\nand o.id = ${officeId}\nand txn.transaction_date < date(\'${startDate}\')\n\nunion all\n\nselect x.`Transaction Date`, x.`Transaction Type`, x.Office, x.`Loan Officer`, x.`Loan Account No`, x.`Loan Product`, x.`Currency`,\n	x.`Client Account No`, x.Client, x.Amount, x.Principal, x.Interest,\ncast(round(\n	if (x.transaction_type_enum = 1 /* disbursement */,\n		@totalOutstandingPrincipal := @totalOutstandingPrincipal + x.`Amount`,\n		@totalOutstandingPrincipal := @totalOutstandingPrincipal - x.`Principal`)\n			,2) as decimal(19,2)) as \'Outstanding Principal\',\ncast(round(\n	if (x.transaction_type_enum in (2,5,8) /* repayment, repayment at disbursal, recovery repayment */,\n		@totalInterestIncome := @totalInterestIncome + x.`Interest`,\n		@totalInterestIncome)\n			,2) as decimal(19,2)) as \'Interest Income\',\ncast(round(\n	if (x.transaction_type_enum = 6 /* write-off */,\n		@totalWriteOff := @totalWriteOff + x.`Principal`,\n		@totalWriteOff)\n			,2) as decimal(19,2)) as \'Principal Write Off\'\nfrom\n(select txn.transaction_type_enum, txn.id as txn_id, txn.transaction_date as \'Transaction Date\',\ncast(\n	ifnull(re.enum_message_property, concat(\'Unknown Transaction Type Value: \' , txn.transaction_type_enum))\n	as char) as \'Transaction Type\',\nounder.`name` as Office, lo.display_name as \'Loan Officer\',\nl.account_no  as \'Loan Account No\', lp.`name` as \'Loan Product\',\nifnull(cur.display_symbol, l.currency_code) as Currency,\nc.account_no as \'Client Account No\', c.display_name as \'Client\',\nifnull(txn.amount,0.00) as Amount,\nifnull(txn.principal_portion_derived,0.00) as Principal,\nifnull(txn.interest_portion_derived,0.00) as Interest\nfrom m_office o\njoin m_office ounder on ounder.hierarchy like concat(o.hierarchy, \'%\')\n                          and ounder.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_client c on c.office_id = ounder.id\njoin m_loan l on l.client_id = c.id\nleft join m_staff lo on lo.id = l.loan_officer_id\njoin m_product_loan lp on lp.id = l.product_id\njoin m_loan_transaction txn on txn.loan_id = l.id\nleft join m_currency cur on cur.code = l.currency_code\nleft join r_enum_value re on re.enum_name = \'transaction_type_enum\'\n						and re.enum_id = txn.transaction_type_enum\nwhere txn.is_reversed = false\nand txn.transaction_type_enum not in (10,11)\nand (ifnull(l.loan_officer_id, -10) = \'${loanOfficerId}\' or \'-1\' = \'${loanOfficerId}\')\nand o.id = ${officeId}\nand txn.transaction_date >= date(\'${startDate}\')\nand txn.transaction_date <= date(\'${endDate}\')\norder by txn.transaction_date, txn.id) x\n','Running Balance Txn report for Individual Lending.\nSuitable for small MFI\'s.  Larger could use it using the branch or other parameters.\nBasically, suck it and see if its quick enough for you out-of-te box or whether it needs performance work in your situation.\n',0,0),
	(107,'FieldAgentStats','Table',NULL,'Quipo','\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff fa\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id\njoin m_client c on c.id = l.client_id\nwhere fa.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n','Field Agent Statistics',0,0),
	(108,'FieldAgentPrograms','Table',NULL,'Quipo','\nselect pgm.id, pgm.display_name as `name`, sts.enum_message_property as status\n from m_group pgm\n join m_office o on o.id = pgm.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\n left join r_enum_value sts on sts.enum_name = \'status_enum\' and sts.enum_id = pgm.status_enum\n where pgm.staff_id = ${staffId}\n','List of Field Agent Programs',0,0),
	(109,'ProgramDetails','Table',NULL,'Quipo','\n select l.id as loanId, l.account_no as loanAccountNo, c.id as clientId, c.account_no as clientAccountNo,\n pgm.display_name as programName,\n\n(select count(*)\nfrom m_loan cy\nwhere cy.group_id = pgm.id and cy.client_id =c.id\nand cy.disbursedon_date <= l.disbursedon_date) as loanCycleNo,\n\nc.display_name as clientDisplayName,\n ifnull(cur.display_symbol, l.currency_code) as Currency,\nifnull(l.principal_repaid_derived,0.0) as loanRepaidAmount,\nifnull(l.principal_outstanding_derived, 0.0) as loanOutstandingAmount,\nifnull(lpa.principal_in_advance_derived,0.0) as LoanPaidInAdvance,\n\nifnull(laa.principal_overdue_derived, 0.0) as loanInArrearsAmount,\nif(ifnull(laa.principal_overdue_derived, 0.00) > 0, \'Yes\', \'No\') as inDefault,\n\nif(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)  as portfolioAtRisk\n\n from m_group pgm\n join m_office o on o.id = pgm.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\n join m_loan l on l.group_id = pgm.id and l.client_id is not null\n left join m_currency cur on cur.code = l.currency_code\n join m_client c on c.id = l.client_id\n left join m_loan_arrears_aging laa on laa.loan_id = l.id\n left join m_loan_paid_in_advance lpa on lpa.loan_id = l.id\n where pgm.id = ${programId}\n and l.loan_status_id = 300\norder by c.display_name, l.account_no\n\n','List of Loans in a Program',0,0),
	(110,'ChildrenStaffList','Table',NULL,'Quipo','\n select s.id, s.display_name,\ns.firstname, s.lastname, s.organisational_role_enum,\ns.organisational_role_parent_staff_id,\nsp.display_name as `organisational_role_parent_staff_display_name`\nfrom m_staff s\njoin m_staff sp on s.organisational_role_parent_staff_id = sp.id\nwhere s.organisational_role_parent_staff_id = ${staffId}\n','Get Next Level Down Staff',0,0),
	(111,'CoordinatorStats','Table',NULL,'Quipo','\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff coord\njoin m_staff fa on fa.organisational_role_parent_staff_id = coord.id\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id\njoin m_client c on c.id = l.client_id\nwhere coord.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n','Coordinator Statistics',0,0),
	(112,'BranchManagerStats','Table',NULL,'Quipo','\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff bm\njoin m_staff coord on coord.organisational_role_parent_staff_id = bm.id\njoin m_staff fa on fa.organisational_role_parent_staff_id = coord.id\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id\njoin m_client c on c.id = l.client_id\nwhere bm.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n','Branch Manager Statistics',0,0),
	(113,'ProgramDirectorStats','Table',NULL,'Quipo','\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_staff pd\njoin m_staff bm on bm.organisational_role_parent_staff_id = pd.id\njoin m_staff coord on coord.organisational_role_parent_staff_id = bm.id\njoin m_staff fa on fa.organisational_role_parent_staff_id = coord.id\njoin m_office o on o.id = fa.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group pgm on pgm.staff_id = fa.id\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id\njoin m_client c on c.id = l.client_id\nwhere pd.id = ${staffId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n','Program DirectorStatistics',0,0),
	(114,'ProgramStats','Table',NULL,'Quipo','\nselect ifnull(cur.display_symbol, l.currency_code) as Currency,\n/*This query will return more than one entry if more than one currency is used */\ncount(distinct(c.id)) as activeClients, count(*) as activeLoans,\nsum(l.principal_disbursed_derived) as disbursedAmount,\nsum(l.principal_outstanding_derived) as loanOutstandingAmount,\nround((sum(l.principal_outstanding_derived) * 100) /  sum(l.principal_disbursed_derived),2) as loanOutstandingPC,\nsum(ifnull(lpa.principal_in_advance_derived,0.0)) as LoanPaidInAdvance,\nsum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) as portfolioAtRisk,\n\nround((sum(\n	if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n		l.principal_outstanding_derived,0)) * 100) / sum(l.principal_outstanding_derived), 2) as portfolioAtRiskPC,\n\ncount(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) as clientsInDefault,\nround((count(distinct(\n		if(date_sub(curdate(), interval 28 day) > ifnull(laa.overdue_since_date_derived, curdate()),\n			c.id,null))) * 100) / count(distinct(c.id)),2) as clientsInDefaultPC,\n(sum(l.principal_disbursed_derived) / count(*))  as averageLoanAmount\nfrom m_group pgm\njoin m_office o on o.id = pgm.office_id\n			and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_loan l on l.group_id = pgm.id and l.client_id is not null\nleft join m_currency cur on cur.code = l.currency_code\nleft join m_loan_arrears_aging laa on laa.loan_id = l.id\nleft join m_loan_paid_in_advance lpa on lpa.loan_id = l.id\njoin m_client c on c.id = l.client_id\nwhere pgm.id = ${programId}\nand l.loan_status_id = 300\ngroup  by l.currency_code\n','Program Statistics',0,0),
	(115,'ClientSummary ','Table',NULL,NULL,'SELECT x.* FROM m_client c, m_office o, \n(\n       SELECT a.loanCycle, a.activeLoans, b.lastLoanAmount, d.activeSavings, d.totalSavings FROM \n	(SELECT IFNULL(MAX(l.loan_counter),0) AS loanCycle, COUNT(l.id) AS activeLoans FROM m_loan l WHERE l.loan_status_id=300 AND l.client_id=${clientId}) a, \n	(SELECT count(l.id), IFNULL(l.principal_amount,0) AS \'lastLoanAmount\' FROM m_loan l WHERE l.client_id=${clientId} AND l.disbursedon_date = (SELECT IFNULL(MAX(disbursedon_date),NOW()) FROM m_loan where client_id=${clientId} and loan_status_id=300)) b, \n	(SELECT COUNT(s.id) AS \'activeSavings\', IFNULL(SUM(s.account_balance_derived),0) AS \'totalSavings\' FROM m_savings_account s WHERE s.status_enum=300 AND s.client_id=${clientId}) d\n) x\nWHERE c.id=${clientId} AND o.id = c.office_id AND o.hierarchy LIKE CONCAT(\'${currentUserHierarchy}\', \'%\')','Utility query for getting the client summary details',1,0),
	(116,'LoanCyclePerProduct','Table',NULL,NULL,'SELECT lp.name AS \'productName\', MAX(l.loan_product_counter) AS \'loanProductCycle\' FROM m_loan l JOIN m_product_loan lp ON l.product_id=lp.id WHERE lp.include_in_borrower_cycle=1 AND l.loan_product_counter IS NOT NULL AND l.client_id=${clientId} GROUP BY l.product_id','Utility query for getting the client loan cycle details',1,0),
	(117,'GroupSavingSummary','Table',NULL,NULL,'select ifnull(cur.display_symbol, sa.currency_code) as currency,\ncount(sa.id) as totalSavingAccounts, ifnull(sum(sa.account_balance_derived),0) as totalSavings\nfrom m_group topgroup\njoin m_office o on o.id = topgroup.office_id and o.hierarchy like concat(\'${currentUserHierarchy}\', \'%\')\njoin m_group g on g.hierarchy like concat(topgroup.hierarchy, \'%\')\njoin m_savings_account sa on sa.group_id = g.id\nleft join m_currency cur on cur.code = sa.currency_code\nwhere topgroup.id = ${groupId}\nand sa.activatedon_date is not null\ngroup by sa.currency_code','Utility query for getting group or center saving summary details for a group_id',1,0),
	(118,'Savings Transactions','Pentaho',NULL,'Savings',NULL,NULL,0,1),
	(119,'Client Savings Summary','Pentaho',NULL,'Savings',NULL,NULL,0,1),
	(120,'Active Loans - Details(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(121,'Active Loans - Summary(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(122,'Active Loans by Disbursal Period(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(123,'Active Loans in last installment Summary(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(124,'Active Loans in last installment(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(125,'Active Loans Passed Final Maturity Summary(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(126,'Active Loans Passed Final Maturity(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(127,'Aging Detail(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(128,'Aging Summary (Arrears in Months)(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(129,'Aging Summary (Arrears in Weeks)(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(130,'Client Listing(Pentaho)','Pentaho',NULL,'Client','(NULL)','(NULL)',1,1),
	(131,'Client Loans Listing(Pentaho)','Pentaho',NULL,'Client','(NULL)','(NULL)',1,1),
	(132,'Expected Payments By Date - Basic(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(133,'Funds Disbursed Between Dates Summary by Office(Pentaho)','Pentaho',NULL,'Fund','(NULL)','(NULL)',1,1),
	(134,'Funds Disbursed Between Dates Summary(Pentaho)','Pentaho',NULL,'Fund','(NULL)','(NULL)',1,1),
	(135,'Loans Awaiting Disbursal Summary by Month(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(136,'Loans Awaiting Disbursal Summary(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(137,'Loans Awaiting Disbursal(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(138,'Loans Pending Approval(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(139,'Obligation Met Loans Details(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(140,'Obligation Met Loans Summary(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(141,'Portfolio at Risk by Branch(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(142,'Portfolio at Risk(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(143,'Rescheduled Loans(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(144,'TxnRunningBalances(Pentaho)','Pentaho',NULL,'Transaction','(NULL)','(NULL)',1,1),
	(145,'Written-Off Loans(Pentaho)','Pentaho',NULL,'Loan','(NULL)','(NULL)',1,1),
	(146,'Client Saving Transactions','Pentaho',NULL,'Savings',NULL,NULL,0,0),
	(147,'Client Loan Account Schedule','Pentaho',NULL,'Loans',NULL,NULL,0,0),
	(148,'GroupNamesByStaff','Table','','','Select gr.id as id, gr.display_name as name from m_group gr where gr.level_id=1 and gr.staff_id = ${staffId}','',1,0),
	(149,'ClientTrendsByDay','Table','','Client','SELECT 	COUNT(cl.id) AS count, \n		cl.activation_date AS days\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n	AND (cl.activation_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 DAY) AND DATE(NOW()- INTERVAL 1 DAY))\nGROUP BY days','Retrieves the number of clients joined in last 12 days',1,0),
	(150,'ClientTrendsByWeek','Table','','Client','SELECT 	COUNT(cl.id) AS count, \n		WEEK(cl.activation_date) AS Weeks\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n	AND (cl.activation_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 WEEK) AND DATE(NOW()))\nGROUP BY Weeks','',1,0),
	(151,'ClientTrendsByMonth','Table','','Client','SELECT 	COUNT(cl.id) AS count, \n		MONTHNAME(cl.activation_date) AS Months\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n	AND (cl.activation_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND DATE(NOW()))\nGROUP BY Months','',1,0),
	(152,'LoanTrendsByDay','Table','','Loan','SELECT 	COUNT(ln.id) AS lcount, \n		ln.disbursedon_date AS days\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\n	LEFT JOIN m_loan ln on cl.id = ln.client_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n	AND (ln.disbursedon_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 DAY) AND DATE(NOW()- INTERVAL 1 DAY))\nGROUP BY days','Retrieves Number of loans disbursed for last 12 days',1,0),
	(153,'LoanTrendsByWeek','Table','','Loan','SELECT 	COUNT(ln.id) AS lcount, \n		WEEK(ln.disbursedon_date) AS Weeks\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\n	LEFT JOIN m_loan ln on cl.id = ln.client_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n	AND (ln.disbursedon_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 WEEK) AND DATE(NOW()))\nGROUP BY Weeks','',1,0),
	(154,'LoanTrendsByMonth','Table','','Loan','SELECT 	COUNT(ln.id) AS lcount, \n		MONTHNAME(ln.disbursedon_date) AS Months\nFROM m_office of \n	LEFT JOIN m_client cl on of.id = cl.office_id\n	LEFT JOIN m_loan ln on cl.id = ln.client_id\nWHERE of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n	AND (ln.disbursedon_date BETWEEN DATE_SUB(CURDATE(), INTERVAL 12 MONTH) AND DATE(NOW()))\nGROUP BY Months','',1,0),
	(155,'Demand_Vs_Collection','Table','','Loan','select amount.AmountDue-amount.AmountPaid as AmountDue, amount.AmountPaid as AmountPaid from\n(SELECT \n(IFNULL(SUM(ls.principal_amount),0) - IFNULL(SUM(ls.principal_writtenoff_derived),0)\n + IFNULL(SUM(ls.interest_amount),0) - IFNULL(SUM(ls.interest_writtenoff_derived),0) \n - IFNULL(SUM(ls.interest_waived_derived),0)\n + IFNULL(SUM(ls.fee_charges_amount),0) - IFNULL(SUM(ls.fee_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.fee_charges_waived_derived),0)\n + IFNULL(SUM(ls.penalty_charges_amount),0) - IFNULL(SUM(ls.penalty_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.penalty_charges_waived_derived),0)\n) AS AmountDue, \n\n(IFNULL(SUM(ls.principal_completed_derived),0) - IFNULL(SUM(ls.principal_writtenoff_derived),0) + IFNULL(SUM(ls.interest_completed_derived),0) - IFNULL(SUM(ls.interest_writtenoff_derived),0) \n - IFNULL(SUM(ls.interest_waived_derived),0)\n + IFNULL(SUM(ls.fee_charges_completed_derived),0) - IFNULL(SUM(ls.fee_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.fee_charges_waived_derived),0)\n + IFNULL(SUM(ls.penalty_charges_completed_derived),0) - IFNULL(SUM(ls.penalty_charges_writtenoff_derived),0) \n - IFNULL(SUM(ls.penalty_charges_waived_derived),0)\n) AS AmountPaid\nFROM m_office of\nLEFT JOIN m_client cl ON of.id = cl.office_id\nLEFT JOIN m_loan ln ON cl.id = ln.client_id\nLEFT JOIN m_loan_repayment_schedule ls ON ln.id = ls.loan_id\nWHERE ls.duedate = DATE(NOW()) AND \n (of.hierarchy LIKE CONCAT((\nSELECT ino.hierarchy\nFROM m_office ino\nWHERE ino.id = ${officeId}),\"%\"))) as amount','Demand Vs Collection',1,0),
	(156,'Disbursal_Vs_Awaitingdisbursal','Table','','Loan','select awaitinddisbursal.amount-disbursedAmount.amount as amountToBeDisburse, disbursedAmount.amount as disbursedAmount from \n(\nSELECT 	COUNT(ln.id) AS noOfLoans, \n			IFNULL(SUM(ln.principal_amount),0) AS amount\nFROM \nm_office of\nLEFT JOIN m_client cl ON cl.office_id = of.id\nLEFT JOIN m_loan ln ON cl.id = ln.client_id\nWHERE \nln.expected_disbursedon_date = DATE(NOW()) AND \n(ln.loan_status_id=200 OR ln.loan_status_id=300) AND\n of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" )\n) awaitinddisbursal,\n(\nSELECT 	COUNT(ltrxn.id) as count, \n			IFNULL(SUM(ltrxn.amount),0) as amount \nFROM \nm_office of\nLEFT JOIN m_client cl ON cl.office_id = of.id\nLEFT JOIN m_loan ln ON cl.id = ln.client_id\nLEFT JOIN m_loan_transaction ltrxn ON ln.id = ltrxn.loan_id\nWHERE \nltrxn.transaction_date = DATE(NOW()) AND \nltrxn.is_reversed = 0 AND\nltrxn.transaction_type_enum=1 AND\n of.hierarchy like concat((select ino.hierarchy from m_office ino where ino.id = ${officeId}),\"%\" ) \n) disbursedAmount','Disbursal_Vs_Awaitingdisbursal',1,0),
	(157,'Savings Transaction Receipt','Pentaho',NULL,NULL,NULL,NULL,0,1),
	(158,'Loan Transaction Receipt','Pentaho',NULL,NULL,NULL,NULL,0,1),
	(159,'Staff Assignment History','Pentaho',NULL,NULL,NULL,NULL,0,1),
	(160,'GeneralLedgerReport','Pentaho',NULL,'Accounting',NULL,NULL,0,1),
	(161,'Active Loan Summary per Branch','Pentaho',NULL,'Loans',NULL,NULL,0,1),
	(162,'Balance Outstanding','Pentaho',NULL,'Loans',NULL,NULL,0,1),
	(163,'Collection Report','Pentaho',NULL,'Loans',NULL,NULL,0,1),
	(164,'Disbursal Report','Pentaho',NULL,'Loans',NULL,NULL,0,1),
	(165,'Savings Accounts Dormancy Report','Table',NULL,'Savings','select cl.display_name as \'Client Display Name\',\r\nsa.account_no as \'Account Number\',\r\ncl.mobile_no as \'Mobile Number\',\r\n@lastdate:=(select IFNULL(max(sat.transaction_date),sa.activatedon_date) \r\n            from m_savings_account_transaction as sat \r\n            where sat.is_reversed = 0 \r\n            and sat.transaction_type_enum in (1,2) \r\n            and sat.savings_account_id = sa.id) as \'Date of Last Activity\',\r\nDATEDIFF(now(), @lastdate) as \'Days Since Last Activity\'\r\nfrom m_savings_account as sa \r\ninner join m_savings_product as sp on (sa.product_id = sp.id and sp.is_dormancy_tracking_active = 1) \r\nleft join m_client as cl on sa.client_id = cl.id \r\nwhere sa.sub_status_enum = ${subStatus}\r\nand cl.office_id = ${officeId}',NULL,1,1),
	(166,'Daily Teller Cash Report (Pentaho)','Pentaho',NULL,NULL,NULL,'Daily Teller Cash Report',1,1);

/*!40000 ALTER TABLE `stretchy_report` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table stretchy_report_parameter
# ------------------------------------------------------------

DROP TABLE IF EXISTS `stretchy_report_parameter`;

CREATE TABLE `stretchy_report_parameter` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` int(11) NOT NULL,
  `parameter_id` int(11) NOT NULL,
  `report_parameter_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `report_parameter_unique` (`report_id`,`parameter_id`),
  KEY `fk_report_parameter_001_idx` (`report_id`),
  KEY `fk_report_parameter_002_idx` (`parameter_id`),
  CONSTRAINT `fk_report_parameter_001` FOREIGN KEY (`report_id`) REFERENCES `stretchy_report` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_report_parameter_002` FOREIGN KEY (`parameter_id`) REFERENCES `stretchy_parameter` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `stretchy_report_parameter` WRITE;
/*!40000 ALTER TABLE `stretchy_report_parameter` DISABLE KEYS */;

INSERT INTO `stretchy_report_parameter` (`id`, `report_id`, `parameter_id`, `report_parameter_name`)
VALUES
	(1,1,5,NULL),
	(2,2,5,NULL),
	(3,2,6,NULL),
	(4,2,10,NULL),
	(5,2,20,NULL),
	(6,2,25,NULL),
	(7,2,26,NULL),
	(8,5,5,NULL),
	(9,5,6,NULL),
	(10,5,10,NULL),
	(11,5,20,NULL),
	(12,5,25,NULL),
	(13,5,26,NULL),
	(14,6,5,NULL),
	(15,6,6,NULL),
	(16,6,10,NULL),
	(17,6,20,NULL),
	(18,6,25,NULL),
	(19,6,26,NULL),
	(20,7,5,NULL),
	(21,7,6,NULL),
	(22,7,10,NULL),
	(23,7,20,NULL),
	(24,7,25,NULL),
	(25,7,26,NULL),
	(26,8,5,NULL),
	(27,8,6,NULL),
	(28,8,10,NULL),
	(29,8,25,NULL),
	(30,8,26,NULL),
	(31,11,5,NULL),
	(32,11,6,NULL),
	(33,11,10,NULL),
	(34,11,20,NULL),
	(35,11,25,NULL),
	(36,11,26,NULL),
	(37,11,100,NULL),
	(38,12,5,NULL),
	(39,12,6,NULL),
	(40,12,10,NULL),
	(41,12,20,NULL),
	(42,12,25,NULL),
	(43,12,26,NULL),
	(44,13,1,NULL),
	(45,13,2,NULL),
	(46,13,3,NULL),
	(47,13,5,NULL),
	(48,13,6,NULL),
	(49,13,10,NULL),
	(50,13,20,NULL),
	(51,13,25,NULL),
	(52,13,26,NULL),
	(53,14,1,NULL),
	(54,14,2,NULL),
	(55,14,3,NULL),
	(56,14,5,NULL),
	(57,14,6,NULL),
	(58,14,10,NULL),
	(59,14,20,NULL),
	(60,14,25,NULL),
	(61,14,26,NULL),
	(62,15,5,NULL),
	(63,15,6,NULL),
	(64,15,10,NULL),
	(65,15,20,NULL),
	(66,15,25,NULL),
	(67,15,26,NULL),
	(68,15,100,NULL),
	(69,16,5,NULL),
	(70,16,6,NULL),
	(71,16,10,NULL),
	(72,16,20,NULL),
	(73,16,25,NULL),
	(74,16,26,NULL),
	(75,16,100,NULL),
	(76,20,1,NULL),
	(77,20,2,NULL),
	(78,20,10,NULL),
	(79,20,20,NULL),
	(80,21,1,NULL),
	(81,21,2,NULL),
	(82,21,5,NULL),
	(83,21,10,NULL),
	(84,21,20,NULL),
	(85,48,5,'branch'),
	(86,48,2,'date'),
	(87,49,5,'branch'),
	(88,49,1,'fromDate'),
	(89,49,2,'toDate'),
	(90,50,5,'branch'),
	(91,50,1,'fromDate'),
	(92,50,2,'toDate'),
	(93,51,1,NULL),
	(94,51,2,NULL),
	(95,51,5,NULL),
	(96,51,10,NULL),
	(97,51,25,NULL),
	(98,52,5,NULL),
	(99,53,5,NULL),
	(100,53,10,NULL),
	(101,54,1,NULL),
	(102,54,2,NULL),
	(103,54,5,NULL),
	(104,54,10,NULL),
	(105,54,25,NULL),
	(106,55,5,NULL),
	(107,55,6,NULL),
	(108,55,10,NULL),
	(109,55,20,NULL),
	(110,55,25,NULL),
	(111,55,26,NULL),
	(112,56,5,NULL),
	(113,56,6,NULL),
	(114,56,10,NULL),
	(115,56,20,NULL),
	(116,56,25,NULL),
	(117,56,26,NULL),
	(118,56,100,NULL),
	(119,57,5,NULL),
	(120,57,6,NULL),
	(121,57,10,NULL),
	(122,57,20,NULL),
	(123,57,25,NULL),
	(124,57,26,NULL),
	(125,58,5,NULL),
	(126,58,6,NULL),
	(127,58,10,NULL),
	(128,58,20,NULL),
	(129,58,25,NULL),
	(130,58,26,NULL),
	(131,58,100,NULL),
	(132,59,1,NULL),
	(133,59,2,NULL),
	(134,59,5,NULL),
	(135,59,6,NULL),
	(136,59,10,NULL),
	(137,59,20,NULL),
	(138,59,25,NULL),
	(139,59,26,NULL),
	(140,61,5,NULL),
	(141,61,10,NULL),
	(142,92,1,'fromDate'),
	(143,92,5,'selectOffice'),
	(144,92,2,'toDate'),
	(145,93,1,NULL),
	(146,93,2,NULL),
	(147,93,5,NULL),
	(148,93,6,NULL),
	(149,94,2,'endDate'),
	(150,94,6,'loanOfficerId'),
	(151,94,5,'officeId'),
	(152,94,1,'startDate'),
	(256,106,2,NULL),
	(257,106,6,NULL),
	(258,106,5,NULL),
	(259,106,1,NULL),
	(263,118,1,'fromDate'),
	(264,118,2,'toDate'),
	(265,118,1004,'accountNo'),
	(266,119,1,'fromDate'),
	(267,119,2,'toDate'),
	(268,119,5,'selectOffice'),
	(269,119,1005,'selectProduct'),
	(270,120,5,'branch'),
	(271,120,6,'loanOfficer'),
	(272,120,10,'currencyId'),
	(273,120,20,'fundId'),
	(274,120,25,'loanProductId'),
	(275,120,26,'loanPurposeId'),
	(276,121,5,'Branch'),
	(277,121,6,'loanOfficer'),
	(278,121,10,'CurrencyId'),
	(279,121,20,'fundId'),
	(280,121,25,'loanProductId'),
	(281,121,26,'loanPurposeId'),
	(282,121,100,'parType'),
	(283,122,5,'Branch'),
	(284,122,6,'loanOfficer'),
	(285,122,10,'CurrencyId'),
	(286,122,20,'fundId'),
	(287,122,25,'loanProductId'),
	(288,122,26,'loanPurposeId'),
	(289,122,1,'startDate'),
	(290,122,2,'endDate'),
	(291,123,5,'Branch'),
	(292,123,6,'Loan Officer'),
	(293,123,10,'CurrencyId'),
	(294,123,20,'fundId'),
	(295,123,25,'loanProductId'),
	(296,123,26,'loanPurposeId'),
	(297,123,100,'parType'),
	(298,124,5,'Branch'),
	(299,124,6,'Loan Officer'),
	(300,124,10,'CurrencyId'),
	(301,124,20,'fundId'),
	(302,124,25,'loanProductId'),
	(303,124,26,'loanPurposeId'),
	(304,125,5,'Branch'),
	(305,125,6,'Loan Officer'),
	(306,125,10,'CurrencyId'),
	(307,125,20,'fundId'),
	(308,125,25,'loanProductId'),
	(309,125,26,'loanPurposeId'),
	(310,125,100,'parType'),
	(311,126,5,'Branch'),
	(312,126,6,'Loan Officer'),
	(313,126,10,'CurrencyId'),
	(314,126,20,'fundId'),
	(315,126,25,'loanProductId'),
	(316,126,26,'loanPurposeId'),
	(317,127,5,'Branch'),
	(318,128,5,'Branch'),
	(319,128,10,'CurrencyId'),
	(320,129,5,'Branch'),
	(321,129,10,'CurrencyId'),
	(322,130,5,'selectOffice'),
	(323,131,5,'Branch'),
	(324,131,6,'Loan Officer'),
	(325,131,10,'CurrencyId'),
	(326,131,20,'fundId'),
	(327,131,25,'loanProductId'),
	(328,131,26,'loanPurposeId'),
	(329,132,5,'Branch'),
	(330,132,6,'Loan Officer'),
	(331,132,1,'startDate'),
	(332,132,2,'endDate'),
	(333,133,5,'Branch'),
	(334,133,10,'CurrencyId'),
	(335,133,20,'fundId'),
	(336,133,1,'startDate'),
	(337,133,2,'endDate'),
	(338,134,10,'CurrencyId'),
	(339,134,20,'fundId'),
	(340,134,1,'startDate'),
	(341,134,2,'endDate'),
	(342,135,5,'Branch'),
	(343,135,6,'Loan Officer'),
	(344,135,10,'CurrencyId'),
	(345,135,20,'fundId'),
	(346,135,25,'loanProductId'),
	(347,135,26,'loanPurposeId'),
	(348,136,5,'Branch'),
	(349,136,6,'Loan Officer'),
	(350,136,10,'CurrencyId'),
	(351,136,20,'fundId'),
	(352,136,25,'loanProductId'),
	(353,136,26,'loanPurposeId'),
	(354,137,5,'Branch'),
	(355,137,6,'Loan Officer'),
	(356,137,10,'CurrencyId'),
	(357,137,20,'fundId'),
	(358,137,25,'loanProductId'),
	(359,137,26,'loanPurposeId'),
	(360,138,5,'Branch'),
	(361,138,6,'Loan Officer'),
	(362,138,10,'CurrencyId'),
	(363,138,20,'fundId'),
	(364,138,25,'loanProductId'),
	(365,138,26,'loanPurposeId'),
	(366,139,5,'Branch'),
	(367,139,6,'Loan Officer'),
	(368,139,10,'CurrencyId'),
	(369,139,20,'fundId'),
	(370,139,25,'loanProductId'),
	(371,139,26,'loanPurposeId'),
	(372,139,1,'startDate'),
	(373,139,2,'endDate'),
	(374,139,3,'obligDateType'),
	(375,140,5,'Branch'),
	(376,140,6,'Loan Officer'),
	(377,140,10,'CurrencyId'),
	(378,140,20,'fundId'),
	(379,140,25,'loanProductId'),
	(380,140,26,'loanPurposeId'),
	(381,140,1,'Startdate'),
	(382,140,2,'Enddate'),
	(383,140,3,'obligDateType'),
	(384,141,5,'Branch'),
	(385,141,6,'Loan Officer'),
	(386,141,10,'CurrencyId'),
	(387,141,20,'fundId'),
	(388,141,25,'loanProductId'),
	(389,141,26,'loanPurposeId'),
	(390,141,100,'parType'),
	(391,142,5,'Branch'),
	(392,142,6,'loanOfficer'),
	(393,142,10,'CurrencyId'),
	(394,142,20,'fundId'),
	(395,142,25,'loanProductId'),
	(396,142,26,'loanPurposeId'),
	(397,142,100,'parType'),
	(398,143,5,'Branch'),
	(399,143,10,'CurrencyId'),
	(400,143,25,'loanProductId'),
	(401,143,1,'startDate'),
	(402,143,2,'endDate'),
	(403,144,5,'Branch'),
	(404,144,6,'Loan Officer'),
	(405,144,1,'startDate'),
	(406,144,2,'endDate'),
	(407,145,5,'Branch'),
	(408,145,10,'CurrencyId'),
	(409,145,25,'loanProductId'),
	(410,145,1,'startDate'),
	(411,145,2,'endDate'),
	(412,146,1,'startDate'),
	(413,146,2,'endDate'),
	(414,146,1004,'accountNo'),
	(415,147,1,'startDate'),
	(416,147,2,'endDate'),
	(417,147,1004,'selectLoan'),
	(418,149,5,''),
	(419,150,5,''),
	(420,151,5,''),
	(421,152,5,''),
	(422,153,5,''),
	(423,154,5,''),
	(424,155,5,''),
	(425,156,5,''),
	(426,157,1006,'transactionId'),
	(427,158,1006,'transactionId'),
	(428,159,1007,'centerId'),
	(429,160,1008,'account'),
	(430,160,1,'fromDate'),
	(431,160,2,'toDate'),
	(432,160,5,'branch'),
	(433,162,5,'branch'),
	(434,162,1009,'ondate'),
	(435,163,5,'branch'),
	(436,163,1,'fromDate'),
	(437,163,2,'toDate'),
	(438,164,5,'branch'),
	(439,164,1,'fromDate'),
	(440,164,2,'toDate'),
	(441,165,1010,NULL),
	(442,165,5,NULL),
	(443,166,5,'officeId'),
	(444,166,1011,'tellerId'),
	(445,166,1012,'cashierId'),
	(446,166,1013,'currencyCode'),
	(447,166,1009,'asOnDate');

/*!40000 ALTER TABLE `stretchy_report_parameter` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table x_registered_table
# ------------------------------------------------------------

DROP TABLE IF EXISTS `x_registered_table`;

CREATE TABLE `x_registered_table` (
  `registered_table_name` varchar(50) NOT NULL,
  `application_table_name` varchar(50) NOT NULL,
  `category` int(11) NOT NULL DEFAULT '100',
  PRIMARY KEY (`registered_table_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



# Dump of table x_table_column_code_mappings
# ------------------------------------------------------------

DROP TABLE IF EXISTS `x_table_column_code_mappings`;

CREATE TABLE `x_table_column_code_mappings` (
  `column_alias_name` varchar(50) NOT NULL,
  `code_id` int(10) NOT NULL,
  PRIMARY KEY (`column_alias_name`),
  KEY `FK_x_code_id` (`code_id`),
  CONSTRAINT `FK_x_code_id` FOREIGN KEY (`code_id`) REFERENCES `m_code` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;




--
-- Dumping routines (PROCEDURE) for database 'fineract_default_dev'
--
DELIMITER ;;

# Dump of PROCEDURE CashierTransactionSummary
# ------------------------------------------------------------

/*!50003 DROP PROCEDURE IF EXISTS `CashierTransactionSummary` */;;
/*!50003 SET SESSION SQL_MODE="STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION"*/;;
/*!50003 CREATE*/ /*!50020 DEFINER=`fineract_default`@`%`*/ /*!50003 PROCEDURE `CashierTransactionSummary`(
	IN `officeId` BIGINT,
	IN `tellerId` BIGINT,
	IN `cashierId` BIGINT,
	IN `currencyCode` TEXT,
	IN `asOnDate` DATE
)
BEGIN


-- Create temporary table
CREATE TEMPORARY TABLE temp_cashier_transactions(
`transaction_date` DATE,
`transaction_type` VARCHAR(20), 
`amount` DECIMAL(19,6));

-- Insert result set into temporary table
INSERT INTO temp_cashier_transactions 
SELECT cashier_txn.txn_date AS transaction_date, 
CASE 
WHEN cashier_txn.txn_type = 101
	THEN 'cash_allocated'
WHEN cashier_txn.txn_type = 102
	THEN 'cash_settled'
END AS transaction_type,
	cashier_txn.txn_amount AS transaction_amount
FROM m_cashier_transactions cashier_txn
LEFT JOIN m_cashiers cashier ON cashier.id = cashier_txn.cashier_id
LEFT JOIN m_tellers teller ON teller.id = cashier.teller_id
WHERE cashier.teller_id = tellerId
	AND cashier_txn.cashier_id = cashierId
	AND cashier_txn.currency_code = currencyCode 

UNION ALL

SELECT savings_txn.transaction_date AS transaction_date, 
CASE 
WHEN (((savings_txn.payment_detail_id IS NULL OR payType.is_cash_payment = 1) 
		AND acnttrans.id IS NULL)
	AND renum.enum_value IN ('deposit','withdrawal fee', 'Pay Charge', 'Annual Fee')) 
	THEN 'cash_in'
WHEN (((savings_txn.payment_detail_id IS NULL OR payType.is_cash_payment = 1) 
		AND acnttrans.id IS NULL)
	AND renum.enum_value IN ('withdrawal', 'Waive Charge', 'Interest Posting', 'Overdraft Interest')) 
	THEN 'cash_out'
WHEN acnttrans.id IS NOT NULL AND acnttrans.from_savings_transaction_id IS NOT NULL
	THEN 'transfers'
WHEN ((payType.is_cash_payment = 0) 
	AND renum.enum_value IN ('deposit','withdrawal fee', 'Pay Charge', 'Annual Fee')) 
	THEN CONCAT(payType.value, '_in')
WHEN ((payType.is_cash_payment = 0) 
	AND renum.enum_value IN ('withdrawal', 'Waive Charge', 'Interest Posting', 'Overdraft Interest')) 
	THEN CONCAT(payType.value, '_out')
END AS transaction_type,
savings_txn.amount AS transaction_amount
FROM m_savings_account_transaction savings_txn
LEFT JOIN r_enum_value renum 
		ON savings_txn.transaction_type_enum = renum.enum_id 
		AND renum.enum_name = 'savings_transaction_type_enum'
LEFT JOIN m_payment_detail payDetails ON payDetails.id = savings_txn.payment_detail_id
LEFT JOIN m_payment_type payType ON payType.id = payDetails.payment_type_id
LEFT JOIN m_account_transfer_transaction acnttrans 
		ON (acnttrans.from_savings_transaction_id = savings_txn.id 
				OR acnttrans.to_savings_transaction_id = savings_txn.id)
LEFT JOIN m_savings_account savings ON savings_txn.savings_account_id = savings.id
LEFT JOIN m_appuser au ON savings_txn.appuser_id = au.id
LEFT JOIN m_staff s ON au.staff_id = s.id
LEFT JOIN m_cashiers c ON c.staff_id = s.id
LEFT JOIN m_tellers t ON t.id = c.teller_id
WHERE savings_txn.is_reversed = 0 
	AND c.teller_id = tellerId
	AND c.id = cashierId
	AND savings.currency_code = currencyCode 
	AND renum.enum_value IN ('deposit','withdrawal fee', 'Pay Charge', 'Annual Fee', 'withdrawal', 
										'Waive Charge', 'Interest Posting', 'Overdraft Interest')


UNION ALL


SELECT loan_txn.transaction_date AS transaction_date, 
CASE 
WHEN (((loan_txn.payment_detail_id IS NULL OR payType.is_cash_payment = 1) 
		AND acnttrans.id IS NULL)
	AND renum.enum_value IN ('REPAYMENT_AT_DISBURSEMENT','REPAYMENT', 'RECOVERY_REPAYMENT', 'CHARGE_PAYMENT')) 
	THEN 'cash_in'
WHEN (((loan_txn.payment_detail_id IS NULL OR payType.is_cash_payment = 1) 
		AND acnttrans.id IS NULL)
	AND renum.enum_value IN ('DISBURSEMENT', 'WAIVE_INTEREST', 'WRITEOFF', 'WAIVE_CHARGES')) 
	THEN 'cash_out'
WHEN acnttrans.id IS NOT NULL AND acnttrans.from_loan_transaction_id IS NOT NULL
	THEN 'transfers'
WHEN ((payType.is_cash_payment = 0) 
	AND renum.enum_value IN ('REPAYMENT_AT_DISBURSEMENT','REPAYMENT', 'RECOVERY_REPAYMENT', 'CHARGE_PAYMENT')) 
	THEN CONCAT(payType.value, '_in')
WHEN ((payType.is_cash_payment = 0) 
	AND renum.enum_value IN ('DISBURSEMENT', 'WAIVE_INTEREST', 'WRITEOFF', 'WAIVE_CHARGES')) 
	THEN CONCAT(payType.value, '_out')
END AS transaction_type,
loan_txn.amount AS transaction_amount
FROM m_loan_transaction loan_txn
LEFT JOIN r_enum_value renum ON loan_txn.transaction_type_enum = renum.enum_id 
	AND renum.enum_name = 'loan_transaction_type_enum'
LEFT JOIN m_payment_detail payDetails ON payDetails.id = loan_txn.payment_detail_id
LEFT JOIN m_payment_type payType ON payType.id = payDetails.payment_type_id
LEFT JOIN m_account_transfer_transaction acnttrans 
			ON (acnttrans.from_loan_transaction_id = loan_txn.id
					OR acnttrans.to_loan_transaction_id = loan_txn.id)
LEFT JOIN m_loan loan ON loan_txn.loan_id = loan.id
LEFT JOIN m_appuser au ON loan_txn.appuser_id = au.id
LEFT JOIN m_staff s ON au.staff_id = s.id
LEFT JOIN m_cashiers c ON c.staff_id = s.id
LEFT JOIN m_tellers t ON t.id = c.teller_id
WHERE loan_txn.is_reversed = 0 
	AND c.id = cashierId
	AND c.teller_id = tellerId
	AND loan.currency_code = currencyCode 
	AND renum.enum_value IN ('REPAYMENT_AT_DISBURSEMENT','REPAYMENT', 'RECOVERY_REPAYMENT', 
										'CHARGE_PAYMENT', 'DISBURSEMENT', 'WAIVE_INTEREST', 'WRITEOFF', 'WAIVE_CHARGES')


UNION ALL


SELECT client_txn.transaction_date AS transaction_date, 
CASE 
WHEN ((client_txn.payment_detail_id IS NULL OR payType.is_cash_payment = 1) 
	AND renum.enum_value IN ('PAY_CHARGE')) 
	THEN 'cash_in' 
WHEN ((client_txn.payment_detail_id IS NULL OR payType.is_cash_payment = 1) 
	AND renum.enum_value IN ('WAIVE_CHARGE')) 
	THEN 'cash_out' 
WHEN ((payType.is_cash_payment = 0) 
	AND renum.enum_value IN ('PAY_CHARGE')) 
	THEN CONCAT(payType.value, '_in') 
WHEN ((payType.is_cash_payment = 0) 
	AND renum.enum_value IN ('WAIVE_CHARGE')) 
	THEN CONCAT(payType.value, '_out') ELSE 'invalid'
END AS transaction_type, 
client_txn.amount AS transaction_amount
FROM m_client_transaction client_txn
LEFT JOIN r_enum_value renum ON client_txn.transaction_type_enum = renum.enum_id 
	AND renum.enum_name = 'client_transaction_type_enum'
LEFT JOIN m_payment_detail payDetails ON payDetails.id = client_txn.payment_detail_id
LEFT JOIN m_payment_type payType ON payType.id = payDetails.payment_type_id
LEFT JOIN m_appuser au ON client_txn.appuser_id = au.id
LEFT JOIN m_staff s ON au.staff_id = s.id
LEFT JOIN m_cashiers c ON c.staff_id = s.id
LEFT JOIN m_tellers t ON t.id = c.teller_id
WHERE client_txn.is_reversed = 0 
	AND c.id = cashierId
	AND c.teller_id = tellerId
	AND client_txn.currency_code = currencyCode 
	AND renum.enum_value IN ('PAY_CHARGE', 'WAIVE_CHARGE');

-- SELECT * FROM temp_cashier_transactions;


-- Create final temporary table one
CREATE TEMPORARY TABLE final_temp_cashier_report(
`Row Title` VARCHAR(50),
`Row Value` CHAR(50), 
`Verification` VARCHAR(20));


-- Insert office into final temporary table
INSERT INTO final_temp_cashier_report SELECT 'Office' AS '', 
o.name AS '', '' AS ''
FROM m_office o
WHERE o.id = officeId;


-- Insert teller into final temporary table
INSERT INTO final_temp_cashier_report SELECT 'Teller' AS '', 
t.name AS '', '' AS ''
FROM m_tellers t
WHERE t.id = tellerId;

-- Insert teller into final temporary table
INSERT INTO final_temp_cashier_report SELECT 'Cashier' AS '', 
s.display_name AS '', '' AS ''
FROM m_cashiers c
JOIN m_tellers mt ON mt.id = c.teller_id
JOIN m_staff s ON s.id = c.staff_id
WHERE c.teller_id = tellerId
AND c.id = cashierId;

-- Insert currency into final temporary table
INSERT INTO final_temp_cashier_report VALUES ('Currency', currencyCode, '');

-- Insert date into final temporary table
INSERT INTO final_temp_cashier_report VALUES ('As On Date', asOnDate, '');

-- Insert opening balance into final temporary table
INSERT INTO final_temp_cashier_report 
SELECT 'Beginning cash drawer balance' AS '', 
CAST(SUM(CASE
WHEN (transaction_type = 'cash_allocated' AND transaction_date < asOnDate) THEN amount
WHEN (transaction_type = 'cash_settled' AND transaction_date < asOnDate) THEN (-1 * amount)
WHEN (transaction_type = 'cash_in' AND transaction_date < asOnDate) THEN amount
WHEN (transaction_type = 'cash_out' AND transaction_date < asOnDate) THEN (-1 * amount)
ELSE 0
END) AS CHAR) AS '', '' AS '' 
FROM temp_cashier_transactions;

-- Insert ending balance into final temporary table
INSERT INTO final_temp_cashier_report 
SELECT 'Ending cash drawer balance' AS '', 
CAST(SUM(CASE
WHEN (transaction_type = 'cash_allocated' AND transaction_date <= asOnDate) THEN amount
WHEN (transaction_type = 'cash_settled' AND transaction_date <= asOnDate) THEN (-1 * amount)
WHEN (transaction_type = 'cash_in' AND transaction_date <= asOnDate) THEN amount
WHEN (transaction_type = 'cash_out' AND transaction_date <= asOnDate) THEN (-1 * amount)
ELSE 0
END) AS CHAR) AS '', '' AS '' 
FROM temp_cashier_transactions;

-- Insert cash-in into final temporary table
INSERT INTO final_temp_cashier_report 
SELECT 'Total cash disbursed' AS '', 
SUM(CASE
WHEN (transaction_type = 'cash_out' AND transaction_date BETWEEN asOnDate AND  asOnDate) THEN amount
ELSE 0
END) AS '', '' AS ''
FROM temp_cashier_transactions;

-- Insert cash-out into final temporary table
INSERT INTO final_temp_cashier_report 
SELECT 'Total cash received' AS '', 
SUM(CASE
WHEN (transaction_type = 'cash_in' AND transaction_date BETWEEN asOnDate AND  asOnDate) THEN amount
ELSE 0
END) AS '', '' AS ''
FROM temp_cashier_transactions;

-- Insert cash allocated into final temporary table
INSERT INTO final_temp_cashier_report SELECT 'Cash Allocated' AS '', 
SUM(CASE
WHEN (transaction_type = 'cash_allocated' AND transaction_date BETWEEN asOnDate AND  asOnDate) THEN amount
ELSE 0
END) AS '', '' AS ''
FROM temp_cashier_transactions;

-- Insert cash settled into final temporary table
INSERT INTO final_temp_cashier_report SELECT 'Cash Settled' AS '', 
SUM(CASE
WHEN (transaction_type = 'cash_settled' AND transaction_date BETWEEN asOnDate AND  asOnDate) THEN amount
ELSE 0
END) AS '', '' AS ''
FROM temp_cashier_transactions;

-- Insert cash settled into final temporary table
INSERT INTO final_temp_cashier_report 
SELECT 'Account Transfers' AS '', 
SUM(CASE
WHEN (transaction_type = 'transfers' AND transaction_date BETWEEN asOnDate AND  asOnDate) THEN amount
ELSE 0
END) AS '', '' AS ''
FROM temp_cashier_transactions;

-- Insert other payment type  into final temporary table
INSERT INTO final_temp_cashier_report 
SELECT replace(transaction_type, '_', ' ') AS '', 
SUM(CASE
WHEN (transaction_type LIKE '%_in') THEN amount
WHEN (transaction_type LIKE '%_out') THEN amount
ELSE 0
END) AS '', '' AS ''
FROM temp_cashier_transactions
WHERE transaction_type NOT IN ('cash_allocated', 'cash_settled', 'cash_in', 'cash_out', 'transfers') 
AND transaction_date BETWEEN asOnDate AND  asOnDate
GROUP BY transaction_type;

-- SELECT * FROM temp_cashier_transactions;
SELECT * FROM final_temp_cashier_report;

-- Dropping at the end
DROP TEMPORARY TABLE IF EXISTS temp_cashier_transactions;

-- Dropping at the end
DROP TEMPORARY TABLE IF EXISTS final_temp_cashier_report;

END */;;

/*!50003 SET SESSION SQL_MODE=@OLD_SQL_MODE */;;
DELIMITER ;

/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;