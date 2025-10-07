-- Command 1: Create a new entry into the database, which already has your ten initial entries.

/*First command will create a new user for code-warrior (hey that's you!).
  Second will add GitHub as a new website.
  Third will add the relation between the two, and password.*/
INSERT INTO users (username, fname, lname, email)
VALUES
  ("code-warrior", "Roy", "Vanegas", "codewarrior@github.org");

INSERT INTO websites (webName, webUrl)
VALUES
  ("GitHub", "github.com");

INSERT INTO accounts (userId, webId, password, comment)
VALUES
  (7, 8, AES_ENCRYPT("roysPass1234", @key_str, @init_vector), "The safest password ever!");


-- Command 2: Get the password associated with the URL of one of your ten entries.

/*I am casting the decrypted password as a CHAR to make it readable in the output
  I'm using LIMIT 1 to only get one entry, as the command specifies, but you may remove that line to see all results for that url*/
SELECT CAST(AES_DECRYPT(password, @key_str, @init_vector) AS CHAR) AS "First Pass for https://facebook.com/"
  FROM accounts
  JOIN websites USING (webId)
  WHERE webUrl = "https://facebook.com/"
  LIMIT 1;


-- Command 3: Get all the password-related data, including the *decrypted* password, associated with URLs that have `https` in two of your ten entries.

/*I am casting the decrypted password again, like in command 2
  Getting the username from users table for more context in the passwords, and referencing the webUrl from websites table
  I added LIMIT 2 because this command specifies "in two of your ten entries". However, you may remove that line to see all results*/
SELECT CAST(AES_DECRYPT(password, @key_str, @init_vector) AS CHAR) AS "2 Passwords for https URLS",
  users.username,
  accounts.userId,
  accounts.webId,
  accounts.comment,
  accounts.timeStamp
  FROM accounts
  JOIN websites USING (webId)
  JOIN users USING (userId)
  WHERE webUrl LIKE "https%"
  LIMIT 2;


-- Command 4: Change a URL associated with one of the passwords in your ten entries.

-- Although a little backwards, this script changes the URL and website name from X to Twitter.
UPDATE websites SET webUrl = "https://twitter.com/" WHERE webUrl = "https://x.com/";
UPDATE websites SET webName = "Twitter" WHERE webName = "X";


-- Command 5: Change the password to any entry.

-- This will change the first user's (userId 1) password for Youtube (webId 1)
UPDATE accounts
  SET password = AES_ENCRYPT("newPassword!", @key_str, @init_vector)
  WHERE userId = 1
  AND webId = 1;


-- Command 6: Remove a tuple based on a URL.

-- Removes all tuples (account entries) that are for Club Penguin, because Club Penguin doesn't exist anymore :(
DELETE FROM accounts
  WHERE webId = (SELECT webId FROM websites WHERE webUrl = "https://clubpenguin.com/");


-- Command 7: Remove a tuple based on a password.

-- Will remove the tuple entry for code-warrior that was made in command 1 (sorry!)
DELETE FROM accounts
  WHERE password = AES_ENCRYPT("roysPass1234", @key_str, @init_vector);
