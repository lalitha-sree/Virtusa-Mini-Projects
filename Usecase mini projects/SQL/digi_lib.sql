CREATE TABLE Books (
    BookID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    Author VARCHAR(150) NOT NULL,
    Category VARCHAR(50) NOT NULL
);

CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    FullName VARCHAR(150) NOT NULL,
    Email VARCHAR(150) UNIQUE NOT NULL,
    EnrollDate DATE NOT NULL
);

CREATE TABLE IssuedBooks (
    IssueID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT NOT NULL,
    BookID INT NOT NULL,
    IssueDate DATE NOT NULL,
    ReturnDate DATE DEFAULT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID)
);

INSERT INTO Books (Title, Author, Category) VALUES
('To Kill a Mockingbird', 'Harper Lee', 'Fiction'),
('A Brief History of Time', 'Stephen Hawking', 'Science'),
('Sapiens', 'Yuval Noah Harari', 'History'),
('1984', 'George Orwell', 'Fiction'),
('The Selfish Gene', 'Richard Dawkins', 'Science'),
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction'),
('Guns Germs and Steel', 'Jared Diamond', 'History'),
('Cosmos', 'Carl Sagan', 'Science');

INSERT INTO Students (FullName, Email, EnrollDate) VALUES
('Alice Johnson', 'alice@college.edu', '2022-06-01'),
('Bob Smith', 'bob@college.edu', '2021-03-15'),
('Carol White', 'carol@college.edu', '2023-01-10'),
('David Brown', 'david@college.edu', '2020-07-20'),
('Eva Martinez', 'eva@college.edu', '2019-09-05'),
('Frank Lee', 'frank@college.edu', '2018-11-30');

INSERT INTO IssuedBooks (StudentID, BookID, IssueDate, ReturnDate) VALUES
(1, 1, CURDATE() - INTERVAL 20 DAY, NULL),
(2, 3, CURDATE() - INTERVAL 30 DAY, NULL),
(3, 5, CURDATE() - INTERVAL 16 DAY, NULL),
(1, 2, CURDATE() - INTERVAL 10 DAY, CURDATE() - INTERVAL 3 DAY),
(4, 4, CURDATE() - INTERVAL 5 DAY, CURDATE()),
(1, 1, '2022-08-01', '2022-08-10'),
(2, 1, '2022-09-01', '2022-09-12'),
(5, 6, '2021-05-01', '2021-05-14'),
(6, 7, '2020-02-01', '2020-02-15'),
(4, 3, '2023-06-01', '2023-06-10'),
(3, 2, '2024-01-15', '2024-01-25'),
(1, 8, CURDATE() - INTERVAL 2 DAY, NULL);

SELECT 
    s.StudentID, s.FullName, s.Email, b.Title AS BookTitle, b.Category, ib.IssueDate,
    DATEDIFF(CURDATE(), ib.IssueDate) AS DaysOverdue
FROM IssuedBooks ib
JOIN Students s ON ib.StudentID = s.StudentID
JOIN Books b ON ib.BookID = b.BookID
WHERE ib.ReturnDate IS NULL
AND DATEDIFF(CURDATE(), ib.IssueDate) > 14
ORDER BY DaysOverdue DESC;

SELECT
    b.Category,COUNT(ib.IssueID) AS TotalBorrows
FROM IssuedBooks ib
JOIN Books b ON ib.BookID = b.BookID
GROUP BY b.Category
ORDER BY TotalBorrows DESC;

SELECT
    s.StudentID, s.FullName, s.Email,
    MAX(ib.IssueDate) AS LastBorrowDate
FROM Students s
LEFT JOIN IssuedBooks ib ON s.StudentID = ib.StudentID
GROUP BY s.StudentID, s.FullName, s.Email
HAVING MAX(ib.IssueDate) < CURDATE() - INTERVAL 3 YEAR
OR MAX(ib.IssueDate) IS NULL;

DELETE FROM Students
WHERE StudentID NOT IN (
    SELECT DISTINCT StudentID
    FROM IssuedBooks
    WHERE IssueDate >= CURDATE() - INTERVAL 3 YEAR
);
