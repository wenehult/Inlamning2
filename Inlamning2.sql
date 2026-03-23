-- Inlämning 2 

-- Här skapar jag Databasen och väljer att använda den
CREATE DATABASE Bokhandel;
USE Bokhandel;

-- Här skappas första tabellen och här för jag in vilken information som ska finnas i den 
CREATE TABLE Kunder ( 
    KundID INT AUTO_INCREMENT PRIMARY KEY,
    Namn VARCHAR(100) NOT NULL,
    Epost VARCHAR(255) NOT NULL UNIQUE,
    Telefon VARCHAR(30) NOT NULL,
    Adress VARCHAR(100) NOT NULL
);

-- Här skapas Tabellen för beställningar
CREATE TABLE Bestallningar (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT NOT NULL,
    Datum DATE NOT NULL,
    Totalbelopp DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (KundID) REFERENCES Kunder(KundID)
);

-- Här Skapas tabellen för böcker
CREATE TABLE Bocker (
    ISBN BIGINT PRIMARY KEY,
    Titel VARCHAR(100) NOT NULL,
    Forfattare VARCHAR(100) NOT NULL,
    Pris DECIMAL(10,2) NOT NULL,
    Lagerstatus INT NOT NULL,
    CONSTRAINT chk_pris_positivt CHECK (Pris > 0)
);

-- här skapas tabellen för orderrader 
CREATE TABLE Orderrader (
    OrderradID INT AUTO_INCREMENT PRIMARY KEY, 
    OrderID INT NOT NULL,
    ISBN BIGINT NOT NULL,
    Antal INT NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Bestallningar(OrderID),
    FOREIGN KEY (ISBN) REFERENCES Bocker(ISBN)
);

-- Tabell för loggning av nya kunder
CREATE TABLE KundLogg (
    LoggID INT AUTO_INCREMENT PRIMARY KEY,
    KundID INT,
    Namn VARCHAR(100),
    Epost VARCHAR(255),
    Registrerad DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- här skapas ett epost index 
CREATE INDEX idx_epost ON Kunder(Epost);

-- här för jag in information om några kunder 
INSERT INTO Kunder (Namn, Epost, Telefon, Adress) VALUES
('Adam Stensson', 'adam@epost.se', '070000000', 'Storavägen 23'),
('Stefan Berg', 'stefan@epost.se', '070000001', 'Storavägen 24'),
('Robert', 'robert@epost.se', '070000002', 'gatan 4'),
('Lena', 'lena@epost.se', '070000003', 'gatan 5');

-- Här la jag till böckerna som finns i min bokhandel 
INSERT INTO Bocker (ISBN, Titel, Forfattare, Pris, Lagerstatus) VALUES
(9780261103344, 'Hobbit', 'J.R.R. Tolkien', 299.99, 10),
(9780261102385, 'Sagan om ringen', 'J.R.R. Tolkien', 299.99, 20),
(9780261103597, 'Konungens återkomst', 'J.R.R. Tolkien', 299.99, 15);

-- Här kom de första beställningarna, äntligen börjar man tjäna pengar!!
INSERT INTO Bestallningar (KundID, Datum, Totalbelopp) VALUES
(1, '2026-03-01', 299.99),
(1, '2026-03-02', 599.98),
(2, '2026-03-03', 299.99),
(3, '2026-03-04', 299.99),
(1, '2026-03-05', 299.99);

-- Här lägger jag till information i orderrader 
INSERT INTO Orderrader (OrderID, ISBN, Antal) VALUES
(1, 9780261103344, 1),
(2, 9780261102385, 2),
(3, 9780261103597, 1),
(4, 9780261103344, 1),
(5, 9780261102385, 1);

-- här ska jag börja jobba med triggers 

DELIMITER //

CREATE TRIGGER trg_minska_lager
AFTER INSERT ON Orderrader
FOR EACH ROW
BEGIN
    UPDATE Bocker
    SET Lagerstatus = Lagerstatus - NEW.Antal
    WHERE ISBN = NEW.ISBN;
END//

CREATE TRIGGER trg_logga_ny_kund
AFTER INSERT ON Kunder
FOR EACH ROW
BEGIN
    INSERT INTO KundLogg (KundID, Namn, Epost)
    VALUES (NEW.KundID, NEW.Namn, NEW.Epost);
END//

DELIMITER ;

-- Nu har jag skapat databasen och fört in all information och ska börja testa den så vi vet att Databasen funkar och man får upp all information 

-- Testa kundlogg trigger
SELECT * FROM Kundlogg;

INSERT INTO Kunder (Namn, Epost, Telefon, Adress) VALUES 
('Test Kund', 'test@epost.se', '070999999', 'Testgatan 1');

SELECT * FROM Kundlogg;

-- Kör flera SELECT kommandon för att se olika saker från tabellerna. 
SELECT * FROM Kunder;

SELECT * FROM Kunder
WHERE Namn LIKE '%Robert%';

SELECT * FROM Kunder
WHERE Epost LIKE '%epost.se';

SELECT * FROM Bocker ORDER BY Pris ASC;

-- Här uppdaterar jag en epost och kom på att jag gjorde fel och ångra mig.
START TRANSACTION;

UPDATE Kunder SET Epost = 'adam.ny@epost.se' WHERE KundID = 1;

SELECT * FROM Kunder WHERE KundID = 1;

ROLLBACK;

SELECT * FROM Kunder WHERE KundID = 1;

-- Här gör jag en transaktion där jag ska ta bort en kund vi inte ska ha längre men kom på att jag tog bort fel kund
START TRANSACTION;

DELETE FROM Kunder WHERE KundID = 4;

SELECT * FROM Kunder;

ROLLBACK;

SELECT * FROM Kunder;

-- Här gör jag lite olika joins 

SELECT K.KundID, K.Namn, B.OrderID, B.Datum, B.Totalbelopp
FROM Kunder K
INNER JOIN Bestallningar B ON K.KundID = B.KundID;

SELECT K.KundID, K.Namn, B.OrderID, B.Datum, B.Totalbelopp
FROM Kunder K
LEFT JOIN Bestallningar B ON K.KundID = B.KundID;

SELECT K.KundID, K.Namn, COUNT(B.OrderID) AS AntalBestallningar
FROM Kunder K
LEFT JOIN Bestallningar B ON K.KundID = B.KundID
GROUP BY K.KundID, K.Namn;

SELECT K.KundID, K.Namn, COUNT(B.OrderID) AS AntalBestallningar
FROM Kunder K
INNER JOIN Bestallningar B ON K.KundID = B.KundID
GROUP BY K.KundID, K.Namn
HAVING COUNT(B.OrderID) > 2;


SELECT * FROM Bocker;
SELECT * FROM KundLogg;

INSERT INTO Orderrader (OrderID, ISBN, Antal) VALUES
(1, 9780261103344, 1),
(2, 9780261102385, 2);

SELECT * FROM Bocker;
