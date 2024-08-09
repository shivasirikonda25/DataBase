create table customers (
	customer_id serial primary key,
	first_name varchar(20),
	last_name varchar(20),
	date_of_birth date,
	gender char,
	contact_number int,
	email varchar(20),
	address varchar(20)
);

insert into customers(first_name, last_name, date_of_birth, gender, contact_number, email) values (
	'Shiva', 'Sirikonda', '25-11-02', 'M', 93102, 'shiva6@gmail.com'
);

insert into customers(first_name, last_name, date_of_birth, gender, contact_number, email) values (
	'susma', 'debnath', '30-08-99', 'F', 93102, 'susma@gmail.com'
);


create table policies (
	policy_id serial primary key,
	policy_name varchar(20),
	policy_type varchar(10),
	coverage_details varchar(30),
	premium int,
	start_date date,
	end_date date
);

insert into policies(policy_title, policy_type, coverage_details, premium, start_date, end_date) values (
	'LIC', 'Health', 'health insurance', 450000, '01-08-2024', '01-08-2029'
);
insert into policies(policy_title, policy_type, coverage_details, premium, start_date, end_date) values (
	'Godigit', 'Life', 'life insurance', 50000, '01-08-2024', '01-08-2029'
);

create table claims (
	claim_id serial primary key,
	claim_date date,
	claim_amount int,
	approved_amount int,
	claim_status varchar(10),
	policy_id int,
	customer_id int,
	CONSTRAINT FK_claims_policy FOREIGN KEY 
    (policy_id)REFERENCES policies(policy_id),
	CONSTRAINT FK_claims_customer FOREIGN KEY 
    (customer_id)REFERENCES customers(customer_id)
);

insert into claims(claim_date, claim_amount, approved_amount, claim_status, policy_id, customer_id) values (
	'21-01-2002', 30000, 20000, 'claimed', 1, 1
);

insert into claims(claim_date, claim_amount, approved_amount, claim_status, policy_id, customer_id) values (
	'31-01-2002', 35000, 25000, 'unclaimed', 2, 2
);

create table agents (
	agent_id serial primary key,
	first_name varchar(10),
	last_name varchar(10),
	contact_number int,
	email varchar(20),
	hire_date date
);

create table assignments (
	agent_id serial primary key,
	customer_id int,
	policy_id int,
	start_date date,
	end_date date,
	constraint fk_assignments_customer foreign key
	(customer_id) references customers (customer_id),
	constraint fk_assignments_policy foreign key
	(policy_id) references policies (policy_id)
);

insert into assignments (customer_id, policy_id, start_date, end_date) values (
	1, 1, '21-01-2022', '21-05-2023'
);

create table processing (
	processing_id serial primary key,
	claim_id int,
	processing_date date,
	payment_amount int,
	payment_date date,
	constraint fk_assignments_claims foreign key
	(claim_id) references claims (claim_id)
);

-- DDL QUERIES

alter table agents add agent_address varchar(30);

alter table policies rename column policy_name to policy_title;

alter table customers drop column address;

update policies set premium = 45000 WHERE premium = 50000;

delete from claims where claim_status = 'claimed';

insert into assignments (customer_id, policy_id, start_date, end_date) values (
	2, 2, '21-01-2002', '21-01-2023'
);

select 
	c.customer_id,
	c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
	p.policy_id,
	p.policy_title, 
	a.agent_id, 
	a.first_name AS agent_first_name,
	a.last_name AS agent_last_name
from
	customers c
join 
	assignments pa ON c.customer_id=pa.customer_id
join
	policies p ON pa.policy_id = p.policy_id
join
	agents a ON p.policy_id=a.agent_id;

select
cl.claim_id,
cl.claim_date, 
cl.claim_amount, 
cl.claim_status, 
p.policy_id, 
p.policy_title,
p.policy_type,
p.coverage_details
from 
claims cl
join
policies p ON cl.policy_id = p.policy_id;

select
cl.claim_id,
cl.claim_date,
cl.claim_amount,
cl.approved_amount,
cl.claim_status,
c.customer_id,
c.first_name,
c.last_name,
c.contact_number,
c.email
from
claims cl
join
customers c ON cl.customer_id=c.customer_id;

select
p.policy_type,
COUNT(cl.claim_id) AS number_of_claims,
SUM(cl.claim_amount) AS total_claim_amount
from claims cl
join
policies p ON cl.policy_id=p.policy_id
group by
p.policy_type;

select
c.customer_id,
c.first_name,
c.last_name,
cl.claim_id,
claim_date
from
customers c
join claims cl ON c.customer_id = cl.customer_id
where 
cl.claim_date = (select max(cl2.claim_date) from claims cl2 where cl2.customer_id = c.customer_id);