#1.	How many songs are there in the playlist “Grunge”?
SELECT COUNT(*)
FROM playlist
         LEFT JOIN playlisttrack on playlist.PlaylistId = playlisttrack.PlaylistId
WHERE Name = "Grunge";

#2.	Show information about artists whose name includes the text “Jack” and about artists whose name includes the text “John”, but not the text “Martin”.
SELECT *
FROM artist
WHERE Name LIKE '%Jack%'
  OR Name LIKE '%John%';

#3.	For each country where some invoice has been issued, show the total invoice monetary
# amount, but only for countries where at least $100 have been invoiced. Sort the information from higher to lower monetary amount.
SELECT Total
FROM invoice
WHERE BillingCountry IS NOT NULL
  AND Total > 100
ORDER BY Total DESC;

SELECT *
FROM invoiceline
ORDER BY UnitPrice DESC, Quantity DESC;

SELECT Total
FROM invoice
ORDER BY total DESC;

#4.	Get the phone number of the boss of those employees who have given support to clients who have bought some song composed by
# “Miles Davis” in “MPEG Audio File” format.
SELECT Phone
FROM employee
WHERE EmployeeId in
      (SELECT ReportsTo
       FROM employee
       WHERE (EmployeeId in
              (SELECT SupportRepId
               FROM customer
               WHERE CustomerId in
                     (SELECT CustomerId
                      FROM invoice
                      WHERE InvoiceId in
                            (SELECT InvoiceId
                             FROM invoiceline
                             WHERE TrackId in
                                   (SELECT TrackId
                                    FROM track
                                    WHERE Composer = "Miles Davis"
                                      AND MediaTypeId =
                                          (SELECT MediaTypeId FROM mediatype WHERE Name = "MPEG Audio File")))))));

#5.	Show the information, without repeated records, of all albums that feature songs of the “Bossa Nova”
# genre whose title starts by the word “Samba”.
SELECT *
FROM album
         LEFT JOIN track on album.AlbumId = track.AlbumID
WHERE track.GenreID = '11'
    AND track.Name LIKE '%Samba%';

#6.	For each genre, show the average length of its songs in minutes (without indicating seconds). Use the headers “Genre”
# and “Minutes”, and include only genres that have any song longer than half an hour.
select distinct Genre.Name as 'Genre', round(avg(Track.Milliseconds / 60000), 0) as 'Minutes'
from track,
     genre
where genre.GenreId = Track.GenreId
group by genre.GenreId
having Minutes > 30;

#7.	How many client companies have no state?
select count(*)
from customer
where state is null;

#8.

select CONCAT(Employee.FirstName, ' ', Employee.LastName), count(*) Clients
from employee left join customer customer on employee.EmployeeId = customer.SupportRepId
where customer.Country in ('USA', 'Canada' , 'Mexico')
group by Employee.FirstName, Employee.LastName
having count(*)> 6
order by count(*) desc;

#9.
select Country,
       LastName,
       FirstName,
       Fax,
       CONCAT(LastName, ', ', FirstName, ', ', if(Fax is null, "S/he has no fax", Fax))
from customer
where Country = 'USA'
order by LastName;

#10.	For each employee, show his/her first name, last name, and their age at the time they were hired.
select FirstName, LastName, extract(year from HireDate) - extract(year from BirthDate) "Age Hired"
from employee;
