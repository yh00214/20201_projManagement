use pmDB;

SET foreign_key_checks = 0;
drop view POST_LIST CASCADE;
drop table COMMENT_NOTI CASCADE;
drop table COMMENT_SML CASCADE;
drop table COMMENT_MID CASCADE;
drop table COMMENT_BIG CASCADE;
drop table POST_NOTI CASCADE;
drop table POST_SML CASCADE;
drop table POST_MID CASCADE;
drop table POST_BIG CASCADE;
drop table ATTENDENCE CASCADE;
drop table PROJECT CASCADE;
drop table STATUS_INFO CASCADE;
drop table USER CASCADE;
drop table INVITE CASCADE;
drop table SEARCH CASCADE;
drop table COMPANY CASCADE;
drop table AFFILIATION CASCADE;
drop table ALARM CASCADE;
SET foreign_key_checks = 1;

CREATE TABLE USER(
    USER_ID VARCHAR(20),
    USER_PW VARCHAR(512),
    SALT VARCHAR(512),
    NAME VARCHAR(50),
    DEPT VARCHAR(50),
    TOKEN VARCHAR(255),
    PRIMARY KEY(USER_ID)
);

CREATE TABLE STATUS_INFO(
    STATUS_DESC VARCHAR(20),
    STATUS INT(1),
    PRIMARY KEY(STATUS)
);
INSERT STATUS_INFO VALUES("ONGOING", 0);
INSERT STATUS_INFO VALUES("COMPLETE", 1);
INSERT STATUS_INFO VALUES("ERASED", -1);

CREATE TABLE INVITE (
    PROJ_ID INT(11),
    SEND_USER_ID VARCHAR(20),
    RECV_USER_ID VARCHAR(20),
    ISPM BOOLEAN,
    PRIMARY KEY(PROJ_ID, SEND_USER_ID,RECV_USER_ID)
);



CREATE TABLE PROJECT(
    PROJ_ID INT(11) UNSIGNED AUTO_INCREMENT,
    PROJ_MGR_UID varchar(20),
    PROJ_NAME VARCHAR(200),
    PROJ_PROGRESS FLOAT(5,2),
    PROJ_START DATETIME,
    PROJ_END DATETIME,
    PROJ_DESC TEXT,
    PROJ_STATUS INT(1),
    PROJ_URL VARCHAR(512),
    SALT VARCHAR(512),
    FOREIGN KEY(PROJ_STATUS) REFERENCES STATUS_INFO (STATUS),
    FOREIGN KEY(PROJ_MGR_UID) REFERENCES USER (USER_ID),
    PRIMARY KEY(PROJ_ID)
);

CREATE TABLE ALARM(
    PROJ_ID INT(11) UNSIGNED,
    PROJ_COLOR VARCHAR(30),
    TOTAL_WEIGHT INT(11),
    COMPLETE_WEIGHT INT(11),
    YELLOW_BIT BOOLEAN,
    FOREIGN KEY(PROJ_ID) REFERENCES PROJECT (PROJ_ID),
    PRIMARY KEY (PROJ_ID)
);

CREATE TABLE ATTENDENCE(
    PROJ_ID INT(11) UNSIGNED,
    USER_ID VARCHAR(20),
    ATTENDENCE_ROLE VARCHAR(200),
    ISPM BOOLEAN,
    -- FOREIGN KEY (USER_ID) REFERENCES USER (USER_ID),
    FOREIGN KEY (PROJ_ID) REFERENCES PROJECT (PROJ_ID),
    PRIMARY KEY(USER_ID, PROJ_ID)
);

CREATE TABLE COMPANY(
    COMP_ID INT(11) UNSIGNED AUTO_INCREMENT,
    COMP_NAME VARCHAR(200),
    COMP_TEL VARCHAR(30),
    COMP_ADDRESS TEXT,
    COMP_CATEGORY VARCHAR(100),
    COMP_REPRESENTATIVE VARCHAR(200),
    COMP_RELATIVE VARCHAR(200),
    COMP_DESCRIPTION TEXT,
    PRIMARY KEY(COMP_ID)
);

CREATE TABLE AFFILIATION(
    COMP_ID INT(11) UNSIGNED,
    USER_ID VARCHAR(20),
    AFFILIATION_ROLE VARCHAR(200),
    FOREIGN KEY (COMP_ID) REFERENCES COMPANY (COMP_ID),
    FOREIGN KEY (USER_ID) REFERENCES USER (USER_ID),
    PRIMARY KEY(COMP_ID, USER_ID)
);


CREATE TABLE POST_BIG(
    BIG_ID INT(11) UNSIGNED AUTO_INCREMENT,
    PROJ_ID INT(11) UNSIGNED,
    BIG_LEVEL INT(30),
    BIG_TITLE VARCHAR(200),
    BIG_DESC TEXT,
    BIG_ATTACHMENT TEXT,
    BIG_AUTHOR VARCHAR(20),
    BIG_PROGRESS FLOAT(5,2),
    FOREIGN KEY (PROJ_ID) REFERENCES PROJECT (PROJ_ID),
    FOREIGN KEY (BIG_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (BIG_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(BIG_ID)
);

CREATE TABLE POST_MID(
    MID_ID INT(11) UNSIGNED AUTO_INCREMENT,
    BIG_ID INT(11) UNSIGNED,
    MID_LEVEL INT(30),
    MID_TITLE VARCHAR(200),
    MID_DESC TEXT,
    MID_ATTACHMENT TEXT,
    MID_STATUS INT(1),
    MID_AUTHOR VARCHAR(20),
    MID_CREATED DATETIME,
    FOREIGN KEY (BIG_ID) REFERENCES POST_BIG (BIG_ID),
    FOREIGN KEY (MID_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (MID_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(MID_ID)
);

CREATE TABLE POST_SML(
    SML_ID INT(11) UNSIGNED AUTO_INCREMENT,
    MID_ID INT(11) UNSIGNED,
    SML_TITLE VARCHAR(200),
    SML_START DATETIME,
    SML_END DATETIME,
    SML_DESC TEXT,
    SML_ATTACHMENT TEXT,
    SML_STATUS INT(1),
    SML_AUTHOR VARCHAR(20),
    SML_CREATED DATETIME,
    SML_WEIGHT INT(3),
    FOREIGN KEY (MID_ID) REFERENCES POST_MID (MID_ID),
    FOREIGN KEY (SML_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (SML_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(SML_ID)
);

CREATE TABLE POST_NOTI(
    NOTI_ID INT(11) UNSIGNED AUTO_INCREMENT,
    PROJ_ID INT(11) UNSIGNED,
    NOTI_TITLE VARCHAR(200),
    NOTI_DESC TEXT,
    NOTI_STATUS INT(1),
    NOTI_AUTHOR VARCHAR(20),
    NOTI_CREATED DATETIME,
    FOREIGN KEY (PROJ_ID) REFERENCES PROJECT (PROJ_ID),
    FOREIGN KEY (NOTI_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (NOTI_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(NOTI_ID)
);

CREATE TABLE COMMENT_BIG(
    BIGC_ID INT(11) UNSIGNED AUTO_INCREMENT,
    BIG_ID INT(11) UNSIGNED,
    BIGC_AUTHOR VARCHAR(20),
    BIGC_COMMENT TEXT,
    BIGC_TIME DATETIME,
    BIGC_STATUS INT(1),
    FOREIGN KEY (BIG_ID) REFERENCES POST_BIG (BIG_ID),
    FOREIGN KEY (BIGC_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (BIGC_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(BIGC_ID)
);

CREATE TABLE COMMENT_MID(
    MIDC_ID INT(11) UNSIGNED AUTO_INCREMENT,
    MID_ID INT(11) UNSIGNED,
    MIDC_AUTHOR VARCHAR(20),
    MIDC_COMMENT TEXT,
    MIDC_TIME DATETIME,
    MIDC_STATUS INT(1),
    FOREIGN KEY (MID_ID) REFERENCES POST_MID (MID_ID),
    FOREIGN KEY (MIDC_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (MIDC_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(MIDC_ID)
);

CREATE TABLE COMMENT_SML(
    SMLC_ID INT(11) UNSIGNED AUTO_INCREMENT,
    SML_ID INT(11) UNSIGNED,
    SMLC_AUTHOR VARCHAR(20),
    SMLC_COMMENT TEXT,
    SMLC_TIME DATETIME,
    SMLC_STATUS INT(1),
    FOREIGN KEY (SML_ID) REFERENCES POST_SML (SML_ID),
    FOREIGN KEY (SMLC_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (SMLC_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(SMLC_ID)
);

CREATE TABLE COMMENT_NOTI(
    NOTIC_ID INT(11) UNSIGNED AUTO_INCREMENT,
    NOTI_ID INT(11) UNSIGNED,
    NOTIC_AUTHOR VARCHAR(20),
    NOTIC_COMMENT TEXT,
    NOTIC_TIME DATETIME,
    NOTIC_STATUS INT(1),
    FOREIGN KEY (NOTI_ID) REFERENCES POST_NOTI (NOTI_ID),
    FOREIGN KEY (NOTIC_AUTHOR) REFERENCES USER (USER_ID),
    FOREIGN KEY (NOTIC_STATUS) REFERENCES STATUS_INFO (STATUS),
    PRIMARY KEY(NOTIC_ID)
);



CREATE TABLE SEARCH(
   PROJ_ID INT(11) UNSIGNED,
    WORD varchar(255),
    FILE_PATHS varchar(512),
    foreign key (PROJ_ID) references PROJECT(PROJ_ID),
    PRIMARY KEY(PROJ_ID, WORD)
);