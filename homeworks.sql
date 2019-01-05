show databases;
use sakila;
show tables;

select * from actor;

/* show first and last name*/
select first_name, last_name from actor;
/*show the first and ;as*/
select CONCAT(UCASE(first_name)," ",UCASE(last_name)) as "Actor_Name" from actor;

select actor_id ,first_name, last_name from actor where first_name="joe";

select * from actor where last_name LIKE '%gen%';

select * from actor where last_name LIKE '%LI%' ORDER by last_name, first_name;

select * from country where country in ('Afghanistan', 'Bangladesh', 'China');


alter table actor
Add column Description blob after last_name;
select * from actor limit 10;

alter table actor drop column Description;

select last_name ,count(last_name) as 'Number of actors'
from actor 
group by last_name;

SELECT last_name, COUNT(last_name) AS 'Number of Actors' 
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

update actor
set first_name ="Harpo" 
where first_name="GROUCHO " and  last_name="williams"
;

UPDATE actor
SET first_name = 
	CASE 
		WHEN first_name = "HARPO"
			THEN "GROUCHO"
	END;

/*   5 */
SHOW COLUMNS from sakila.address;
show create table sakila.address;

/* 6 */
select first_name, last_name, address
 from staff s
 inner join address a on s.address_id = a.address_id ;
 
/*6b. Use JOIN to display the total amount rung
 up by each staff member in August of 2005. Use tables staff and payment.*/
 
select first_name, last_name,sum(amount) from staff s 
inner join payment p on s.staff_id= p.staff_id
where p.payment_date like '%2005%'
GROUP BY s.staff_id;

/*6c. List each film and the number of actors who are listed for that film.
 Use tables film_actor and film. Use inner join.*/
select title, count(fi.actor_id) 
from film f 
inner join film_actor fi on f.film_id=fi.film_id
group by f.film_id;

/*6d. How many copies of the film Hunchback Impossible exist in the inventory system?
*/

select count(title), title
from film f 
inner join inventory i on f.film_id=i.film_id
where title="Hunchback impossible"
group by f.title;

/*Using the tables payment and customer and the JOIN command,
 list the total paid by each customer.
 List the customers alphabetically by last name:*/

select first_name, last_name, sum(amount)
from customer c
inner join payment p on  c.customer_id = p.customer_id 
group by c.customer_id
order by last_name;

/*The music of Queen and Kris Kristofferson have seen an unlikely
 resurgence. As an unintended consequence, films starting with the
 letters K and Q have also soared in popularity. Use subqueries to
 display the titles of movies starting with the letters K and Q 
 whose language is English.*/

select title from film
where language_id in
( select language_id from language
where name = "English")
and title like 'Q%' or title like 'k%';

/*Use subqueries to display all actors who appear in the film Alone Trip*/

select first_name, last_name from actor
where actor_id in (select actor_id from film_actor
where film_id in
(select film_id from film
 where title="Alone trip"));

/*You want to run an email marketing campaign in Canada, 
for which you will need the names and email addresses of 
all Canadian customers. Use joins to retrieve this information*/
select first_name, last_name,email from customer 
where address_id in
(select address_id from address
where city_id in 
(select city_id from city 
where country_id in
(select country_id from country
where country="Canada")));

/* Sales have been lagging among young families,
 and you wish to target all family movies for a promotion. 
 Identify all movies categorized as family films.*/
 SELECT * from film
 where film_id in
(SELECT film_id FROM film_category	WHERE category_id IN
(SELECT category_id FROM category	WHERE name = "Family"));

/*Display the most frequently rented movies in descending order.*/
select f.title, count(r.rental_id) from film f
right join inventory i
on f.film_id=i.film_id
join rental r 
on r.inventory_id=i.inventory_id
group by f.title
order by count(r.rental_id) desc;

/*7f. Write a query to display how much business, in dollars, each store brought in.*/

SELECT s.store_id, sum(amount) as "Revenue" FROM store s
RIGHT JOIN staff st
ON s.store_id = st.store_id
LEFT JOIN payment p
ON st.staff_id = p.staff_id
GROUP BY s.store_id;

/*7g. Write a query to display for each store its store ID, city, and country.*/
SELECT s.store_id, ci.city, co.country FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city ci
ON a.city_id = ci.city_id
JOIN country co
ON ci.country_id = co.country_id;

/*7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: 
category, film_category, inventory, payment, and rental.)*/
SELECT c.name, sum(p.amount) as "Revenue per Category" FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name;

/*8a. In your new role as an executive, you would like to have an easy
 way of viewing the Top five genres by gross revenue. Use the solution
 from the problem above to create a view. If you haven't solved 7h, you
 can substitute another query to create a view.*/
 CREATE VIEW top_5_by_genre AS
SELECT c.name, sum(p.amount) as "Revenue per Category" FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id
JOIN inventory i
ON fc.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN payment p
ON p.rental_id = r.rental_id
GROUP BY name
ORDER BY SUM(p.amount) DESC
LIMIT 5;

/* 8b. How would you display the view that you created in 8a? */
SELECT * FROM top_5_by_genre;

/* 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. */
DROP VIEW top_5_by_genre;