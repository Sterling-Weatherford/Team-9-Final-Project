
-- Up
CREATE TABLE AuthTokens
(
    id INTEGER PRIMARY KEY,
    token STRING,
    userId INTEGER,
    FOREIGN KEY (UserID) REFERENCES tblUsers (UserID)
);

CREATE TABLE tblUsers
(
    UserID INTEGER PRIMARY KEY,
    FirstName STRING NOT NULL,
    LastName STRING NOT NULL,
    Email STRING UNIQUE NOT NULL,
    Username STRING UNIQUE NOT NULL,
    password STRING NOT NULL
);

CREATE TABLE tblBooks
(
    BookID INTEGER PRIMARY KEY,
    BookName STRING,
    Review STRING,
    Rating REAL,
    CreatorID INT,
    FOREIGN KEY (CreatorID) REFERENCES tblCreators (CreatorID)
);

INSERT INTO tblBooks (BookName, CreatorID, Review, Rating)
VALUES ('Film For Her', 1, 'Film for Her captures clear, intimate moments of a life and gives the reader an up-close look. It reads like a rose-colored diary, or a handful of dreams- it romanticizes beautiful, hopeful, and tragic memories.', 4),
('Patsy', 2, 'Such a powerful, well-written novel about Patsy, a woman who leaves Jamaica and her daughter behind to pursue an independent life in America, only to encounter a fractured version of the American dream full of challenges.', 5),
('The Vanishing Half', 3, 'Wowza! This is unique! This is impeccable! This is perfectly written and I wished it never ended, pushed myself to read it slower, rereading some chapters over and over! It’s phenomenal and one of the best readings of the year!', 5);

CREATE TABLE tblCreators
(
    CreatorID INTEGER PRIMARY KEY,
    FirstName STRING,
    LastName STRING,
    TypeID INT,
    FOREIGN KEY (TypeID) REFERENCES tblMediaType (TypeID)
);

INSERT INTO tblCreators (FirstName, LastName, TypeId)
VALUES
('Playdead', NULL, 5),
('Motion Twin', NULL, 5),
('Toby Fox', NULL, 5),
('House House', NULL, 5),
('Infinite Fall', NULL, 5),
('Night School Studio', NULL, 5),
('CocernedApe', NULL, 5),
('Fullbright', NULL, 5),
('Mediatonic', NULL, 5),
('Subset Games', NULL, 5);


INSERT INTO tblCreators (FirstName, LastName, TypeId)
VALUES
('Elliot', 'Smith', 3),
('Sonic', 'Youth', 3),
('Tennis', NULL, 3),
('Sufjan', 'Stevens', 3),
('Alexandra', 'Savior', 3),
('The', 'Strokes', 3),
('The', 'Microphones', 3),
('Fleet', 'Foxes', 3),
('Beach', 'House', 3),
('SAULT', NULL, 3);


INSERT INTO tblCreators (FirstName, LastName, TypeId)
VALUES
('Fred', 'Armisen', 4),
('Duffer', 'Brothers', 4),
('Michael', 'Schur', 4),
('Mark', 'Gatiss', 4),
('Matthew', 'Weiner', 4);


INSERT INTO tblCreators (FirstName, LastName, TypeId)
VALUES
('Damien', 'Chazelle', 1),
('Spike', 'Jonze', 1),
('James', 'Mangold', 1),
('Richard', 'Ayoade', 1),
('Sean', 'Penn', 1);


INSERT INTO tblCreators (FirstName, LastName, TypeId)
VALUES
('Orion', 'Carloto', 2),
('Nicole', 'Dennis-Benn', 2),
('Brit', 'Bennett', 2),
('Morya', 'Davey', 2),
('Eileen', 'Myles', 2);

CREATE TABLE tblMediaType
(
    TypeID INTEGER PRIMARY KEY,
    Type STRING
);

INSERT INTO tblMediaType (Type)
VALUES (Movie), (Book), (Song), (TVShow), (Game);

CREATE TABLE tblMovies
(
    MovieID INTEGER PRIMARY KEY,
    MovieName STRING,
    Review STRING,
    Rating REAL,
    CreatorID INT,
    FOREIGN KEY (CreatorID) REFERENCES tblCreators (CreatorID)
);

INSERT INTO tblMovies(MovieTitle, CreatorID, Review, Rating)
VALUES
('Whiplash', 26, 'Really underrated movie', 4),
('Her', 27, 'Made me rethink technology', 5),
('Girl, Interrupterd', 28, 'Leo was not in it so its bad', 4),
('Submarine', 29, 'Had nothing to do with going underwater', 3),
('Into The Wild', 30, 'Surprised me with a lot of twists', 7);

CREATE TABLE tblSongs
(
    SongID INTEGER PRIMARY KEY,
    SongName STRING,
    Review STRING,
    Rating REAL,
    CreatorID INT,
    FOREIGN KEY (CreatorID) REFERENCES tblCreators (CreatorID)
);
INSERT INTO tblSongs (SongName, CreatorID, Review, Rating)
VALUES ('Something', 5, 'Whatever', 10);

CREATE TABLE tblTVShows
(
    ShowID INTEGER PRIMARY KEY,
    ShowName STRING,
    Review STRING,
    Rating REAL,
    CreatorID INT,
    FOREIGN KEY (CreatorID) REFERENCES tblCreators (CreatorID)
);

INSERT INTO tblTVShows (TVShow, CreatorID, Review, Rating)
VALUES
('Portlandia', 1, 'This is my favorite show', 10),
('Stranger Things', 2, 'This show was crazy', 10),
('Parks and Rec', 3, 'What a twist', 8);

CREATE TABLE tblGames
(
    GameID INTEGER PRIMARY KEY,
    GameName STRING,
    Review STRING,
    Rating REAL,
    CreatorID INT,
    FOREIGN KEY (CreatorID) REFERENCES tblCreators (CreatorID)
);

INSERT INTO tblGames (GameName, CreatorID, Review, Rating)
VALUES 
('Inside', 1, 'This is an awesome game. I love it!', 5),
('Dead Cells', 2, 'This has an amazing plot twist.', 5),
('Undertale', 3, 'How have I not heard of this game before?', 5);

-- Down
DROP TABLE AuthTokens;

DROP TABLE tblUsers;
DROP TABLE tblBooks;
DROP TABLE tblCreators;
DROP TABLE tblMediaType;
DROP TABLE tblMovies;
DROP TABLE tblSongs;
DROP TABLE tblTVShows;
DROP TABLE tblGames;