# Inlämning 2

## Fortsättning på en liten bokhandel av Lucas Wenehult YH25
Jag har under denna uppgift fortsatt på bokhandeln och lagt in mer data i databasen. Jag har under denna uppgift fått lära mig mer om databaser och hur man kan börja automatisera funktioner. Jag har då skapat olika triggers som uppdaterar tabeller vid vissa scenarion. 

Databasen innehåller:

* Kunder
* Beställningar
* Böcker
* Orderrader
* Kundlogg

Utöver de fyra som fanns tidigare har jag fått lägga till tabellen kundlogg för att ha en tabel där nya kunder loggas.

Det ligger en hel del kommandon och data i sql koden för att få fram och testa funktionaliteten.

## Backup & Återsällning från backup
Backup skapades med: mysqldump -u root -p Bokhandel > bokhandel_backup.sql
Därefter kan jag återställa med: mysql -u root -p Bokhandel < bokhandel_backup.sql

## Funktionalitet

* CRUD (INSERT, SELECT, UPDATE, DELETE)
* JOINs (INNER JOIN, LEFT JOIN)
* GROUP BY och HAVING
* Transaktioner med ROLLBACK
* Index på e-post
* Constraint för pris > 0
* Triggers:

  * Minskar lager vid order
  * Loggar nya kunder

## Lärdommar och reflektioner från uppgiften
Har dragit lärdommen att man kan ha en tabel som inte har några dragna relationer. Då kunlogger inte har en foreginkey till kunder för stt inte hämta kundid. Detta gör man för att undvika att ta bort data  eller händelser.  


![ER-Diagram](Images/ERDiagram.png)
