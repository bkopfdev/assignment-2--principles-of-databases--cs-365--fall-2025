DROP DATABASE IF EXISTS passwords;
CREATE DATABASE passwords;
USE passwords;

SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('my secret passphrase', 512));
SET @init_vector = RANDOM_BYTES(16);

CREATE TABLE IF NOT EXISTS users (
  userId      SMALLINT(5)     NOT NULL,
  username    VARCHAR(128)    NOT NULL,
  fname       VARCHAR(128)    NOT NULL,
  lname       VARCHAR(128)    NOT NULL,
  email       VARCHAR(128)    NOT NULL,

    PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS websites (
  webId       SMALLINT(5)     NOT NULL,
  webName     VARCHAR(128)    NOT NULL,
  webUrl      VARCHAR(255)    NOT NULL,

    PRIMARY KEY (webs_id)
);

CREATE TABLE IF NOT EXISTS passwords (
  passId      SMALLINT(5)     NOT NULL,
  password    VARBINARY(512)  NOT NULL,
  comment     TEXT NOT NULL,
  time_stamp DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (pass_id)
);

CREATE TABLE IF NOT EXISTS log_passwords (
  passId      SMALLINT(5)     NOT NULL,
  webId       SMALLINT(5)     NOT NULL,
  userId      SMALLINT(5)     NOT NULL,

    PRIMARY KEY (pass_id, webs_id, user_id)
);

INSERT INTO users
VALUES
  (00001, "userone", "John", "Yousir", "johnsir@user.org"),
  (00002, "usertwo", "Michael", "Smith", "mike@user.org");

INSERT INTO websites
VALUES
  (00001, "Youtube", "https://youtube.com/"),
  (00002, "Club Penguin", "https://clubpenguin.com/");

INSERT INTO passwords
VALUES
(00001, AES_ENCRYPT("pass1234", @key_str, @init_vector), "don't forget this password!!"),
(00002, AES_ENCRYPT("word5678", @key_str, @init_vector), "");

INSERT INTO log_passwords
VALUES
(00001, 00001, 00001),
(00002, 00002, 00002);
