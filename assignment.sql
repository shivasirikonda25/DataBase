create table books (
	book_id serial primary key,
	title varchar(20),
	author_id serial,
	publication_year int,
	genre varchar(10),
	isbn int,
	available_copies int,
	CONSTRAINT FK_books FOREIGN KEY 
    (author_id)REFERENCES authors(author_id)
);

insert into books(title, author_id, publication_year, genre, isbn, available_copies) values (
	'Earth', 1, 2020, 'knowledge', 12234, 5
)
create table authors (
	author_id serial primary key,
	first_name varchar(10),
	last_name varchar(10),
	date_of_birth date,
	nationality varchar(10)
);

insert into authors(first_name, last_name, date_of_birth, nationality) values (
	'JK', 'Rollings', '23-12-1975', 'Australian'
);
insert into authors(first_name, last_name, date_of_birth, nationality) values (
	'Arundhati', 'Roy', '12-08-1965', 'Indian'
);

create table members (
	member_id serial primary key,
	first_name varchar(10),
	last_name varchar(10),
	date_of_birth date,
	contact_number int,
	email varchar(10),
	membership_date date
);
insert into members(first_name, last_name, date_of_birth, contact_number, membership_date) values (
	'Archit', 'Saxena', '15-12-2002', 12345, '09-08-2024'
);
insert into members(first_name, last_name, date_of_birth, contact_number, membership_date) values (
	'Vasu', 'Dandona', '27-07-2002', 12345, '05-08-2024'
);

create table loans (
	loan_id serial primary key,
	book_id int,
	member_id int,
	loan_date date,
	return_date date,
	actual_return_date date,
	constraint fk_loans_book foreign key
	(book_id) references books (book_id),
	constraint fk_loans_member foreign key
	(member_id) references members (member_id)
);

insert into loans(book_id, member_id, loan_date, return_date, actual_return_date) values (
	2, 1, '08-07-2024', '08-08-2024', '09-08-2024'
);
insert into loans(book_id, member_id, loan_date, return_date, actual_return_date) values (
	3, 2, '15-07-2024', '26-08-2024', '26-08-2024'
);

create table staff (
	staff_id serial primary key,
	first_name varchar(10),
	last_name varchar(10),
	position varchar(10),
	contact_number int,
	email varchar(10),
	hire_date date
);

insert into staff (first_name, last_name, contact_number, email, hire_date) values (
	'Birla', 'Don', 54321, 'birla@gm', '21-01-2002'
);
insert into staff (first_name, last_name, contact_number, email, hire_date) values (
	'Shiva', 'Don', 12345, 'shiva@gm', '25-11-2002'
);


-- DDL QUERIES

alter table books add weight int;

alter table staff rename column position to job_title;

alter table members drop column email;

-- DML QUERIES

insert into books (title, author_id, publication_year, genre, isbn, available_copies) values (
	'Planet of the apes', 001, 2005, 'thriller', 12345, 4
);

update members set contact_number = 54321 WHERE contact_number = 12345;

delete from loans where book_id = 3;

insert into loans(book_id, member_id, loan_date, return_date, actual_return_date) values (
	3, 2, '15-07-2024', '26-08-2024', '26-08-2024'
);

--JOI QUERIES

select
b.book_id,
b.title,
a.author_id,
a.first_name,
a.last_name
from
books b
join
authors a ON b.author_id = a.author_id;

select 
l.loan_id,
b.book_id,
b.title,
m.member_id,
m.first_name,
m.last_name,
l.loan_date,
l.return_date
from
loans l
join
books b ON l.book_id = b.book_id
join
members m ON l.member_id = m.member_id
where
l.actual_return_date IS NULL;

select
genre,
count(book_id) as total_books,
sum(available_copies) as total_available_copies
from
books
group by
genre;