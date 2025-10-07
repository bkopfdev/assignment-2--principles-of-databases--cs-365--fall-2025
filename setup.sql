DROP DATABASE IF EXISTS passwords;
CREATE DATABASE passwords;
USE passwords;

SET block_encryption_mode = 'aes-256-cbc';
SET @key_str = UNHEX(SHA2('my secret passphrase', 512));
SET @init_vector = RANDOM_BYTES(16);

-- users table stores the user information, and uses its id as its primary key
CREATE TABLE IF NOT EXISTS users (
  userId      SMALLINT(5)     NOT NULL AUTO_INCREMENT,
  username    VARCHAR(128)    NOT NULL,
  fname       VARCHAR(128)    NOT NULL,
  lname       VARCHAR(128)    NOT NULL,
  email       VARCHAR(128)    NOT NULL,

  PRIMARY KEY (userId)
);

-- websites table stores website name and URL, using its id as its primary key
CREATE TABLE IF NOT EXISTS websites (
  webId       SMALLINT(5)     NOT NULL AUTO_INCREMENT,
  webName     VARCHAR(128)    NOT NULL,
  webUrl      VARCHAR(255)    NOT NULL,

  PRIMARY KEY (webId)
);

-- accounts table is to have relation between the users and websites, and add the encrypted password and comment
CREATE TABLE IF NOT EXISTS accounts (
  userId      SMALLINT(5)     NOT NULL,
  webId       SMALLINT(5)     NOT NULL,
  password    VARBINARY(512)  NOT NULL,
  comment     VARCHAR(512),
  timeStamp DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (userId, webId) -- Same user cant have the same user information for the same website
);

-- Insert initial data that will make up 10 entries
INSERT INTO users (username, fname, lname, email)
VALUES
  ("userone", "John", "Yousir", "johnsir@user.org"),
  ("usertwo", "Michael", "Smith", "mike@user.org"),
  ("userthree", "Ally", "Jones", "ajones@gmail.com"),
  ("userfour", "Mary", "Smith", "marymary@yahoo.org"),
  ("userfive", "John", "Michaels", "jman2@gmail.com"),
  ("usersix", "Natalie", "Night", "nn123@user.org");

-- Websites to use for initial data
INSERT INTO websites (webName, webUrl)
VALUES
  ("Youtube", "https://youtube.com/"),
  ("Club Penguin", "https://clubpenguin.com/"),
  ("Facebook", "https://facebook.com/"),
  ("X", "https://x.com/"),
  ("Reddit", "https://reddit.com/"),
  ("Instagram", "https://instagram.com/"),
  ("LinkedIn", "https://linkedin.com/");

-- The initial 10 entries into the database
INSERT INTO accounts (userId, webId, password, comment)
VALUES
(1, 1, AES_ENCRYPT("pass1234", @key_str, @init_vector), "don't forget this password!!"),
(1, 3, AES_ENCRYPT("johnuserspass1234", @key_str, @init_vector), "My facebook one"),
(2, 2, AES_ENCRYPT("word5678", @key_str, @init_vector), NULL),
(2, 6, AES_ENCRYPT("mikeinsta!23", @key_str, @init_vector), "I upload pics here!"),
(3, 3, AES_ENCRYPT("RonDog1111", @key_str, @init_vector), "Name of my pet!"),
(3, 7, AES_ENCRYPT("allyallyli222", @key_str, @init_vector), NULL),
(4, 2, AES_ENCRYPT("maryrocks!", @key_str, @init_vector), "I miss club penguin.."),
(4, 3, AES_ENCRYPT("maryfb!123",  @key_str, @init_vector), NULL),
(5, 4, AES_ENCRYPT("johnybgoode#$%", @key_str, @init_vector), NULL),
(6, 5, AES_ENCRYPT("natalie2003", @key_str, @init_vector), ".. Maybe I update this one.");
