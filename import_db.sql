CREATE TABLE users
(id INTEGER PRIMARY KEY,
	fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255)
);

CREATE TABLE questions
(id INTEGER PRIMARY KEY,
	title VARCHAR(255),
	body TEXT NOT NULL,
	author_id INTEGER NOT NULL,
	CONSTRAINT author_id
		FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers
(id INTEGER PRIMARY KEY,
	user_id INTEGER NOT NULL,
	question_id INTEGER NOT NULL,
	CONSTRAINT fk_user_id
		FOREIGN KEY (user_id) REFERENCES users(id),
	CONSTRAINT fk_question_id
		FOREIGN KEY (question_id) REFERENCES questions(id)
);

CREATE TABLE replies
(id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	parent_id INTEGER,
	user_id INTEGER NOT NULL,
	body TEXT,
	CONSTRAINT fk_question_id
		FOREIGN KEY (question_id) REFERENCES questions(id),
	CONSTRAINT fk_parent_id
		FOREIGN KEY (parent_id) REFERENCES replies(id),
	CONSTRAINT fk_user_id
		FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes
(id INTEGER PRIMARY KEY,
	user_id INTEGER  NOT NULL,
	question_id INTEGER  NOT NULL,
	CONSTRAINT fk_user_id
		FOREIGN KEY (user_id) REFERENCES users(id),
	CONSTRAINT fk_question_id
		FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
	users (fname, lname)
VALUES
	('Jessie', 'Douglas'),
	('Mike', 'Williamson'),
	('Sennacy', 'Tamboer');

INSERT INTO
	questions (title, body, author_id)
VALUES
	('Hi', 'Whats up?', 1),
	('Hello', 'How are you today?', 2),
	('Meow', 'Meow?', 3),
	('Weather', 'Is it raining?', 1);

INSERT INTO
	question_followers (user_id, question_id)
VALUES
	(2, 3),
	(2, 4),
	(3, 1),
	(3, 2),
	(3, 3),
	(3, 4);

INSERT INTO
	replies (question_id, parent_id, user_id, body)
VALUES
	(1, NULL, 2, 'Meow'),
	(2, NULL, 1, 'Pretty good. How are you?'),
	(2, 2, 2, 'Im very well thank you');

INSERT INTO
	question_likes (user_id, question_id)
VALUES
	(1, 1),
	(1, 4),
	(2, 3);