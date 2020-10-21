-- Lab 21 Oct. | SQL Subqueries


-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(*)
from (
select film.title 
from inventory, film
where inventory.film_id=film.film_id 
and film.title='Hunchback Impossible'
) sub1 ;

-- List all films longer than the average.
select title, length
from film
where length > (
select avg(length) 
from film
) 
order by length asc ; 

-- Use subqueries to display all actors who appear in the film Alone Trip.
select * 
from (
select film_actor.actor_id, film_actor.film_id, film.title 
from film_actor, film 
where film_actor.film_id=film.film_id
) sub1
where title='Alone Trip' ; 

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select film.film_id, film.title, category.name
from category, film_category, film
where category.category_id=film_category.category_id
and film_category.film_id=film.film_id
and category.name='Family'; 

-- Get name and email from customers from Canada using subqueries. Do the same with joins.

-- with sub
select first_name, last_name, email 
from customer
where address_id IN (
select address_id 
from address 
where city_id IN (
select city_id
from city
where country_id IN (
select country_id 
from country
where country='Canada'))); 

-- with join
select first_name, last_name, email
from customer
join address on customer.address_id = address.address_id
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id
where country="Canada";

-- Which are films starred by the most prolific actor?
select actor_id
from (
select actor_id, count(*) as count 
from film_actor
group by actor_id
order by count desc
) as c 
limit 1;

-- Films rented by most profitable customer.
select customer_id 
from (
select customer_id, sum(amount) as spent
from payment
group by customer_id) as sub
where sub.spent = (
select max(spent) 
from (
select customer_id, sum(amount) as spent
from payment
group by customer_id) as sub2);


-- Customers who spent more than the average.

select payment.customer_id, sum(amount) as amount_spend 
from payment
join customer on payment.customer_id = customer.customer_id
group by customer.customer_id
having amount_spend > (
select round(avg(amount_spend), 2) 
from (
select customer_id, sum(amount) as amount_spend 
from payment
group by customer_id) as sub);