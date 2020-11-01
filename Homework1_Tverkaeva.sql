-- Удаляем таблицы если они уже есть.
drop table if exists temp_data;
drop table if exists person2content;
drop table if exists films;
drop table if exists persons;

-- Создаем таблицу 'films'.
create table films (
  id serial primary key,
  title varchar(128),
  country varchar(64),
  box_office bigint,
  release_date date
);
 
-- Создаем таблицу 'persons'.
create table persons (
  id serial primary key,
  fio varchar(128) unique
);

-- Создаем таблицу 'person2person'.
create table person2content (
  person_id int not null,
  film_id int not null,
  person_type varchar(64),
  primary key(person_id, film_id, person_type),
  foreign key(person_id) references persons (id),
  foreign key(film_id) references films (id)
);

-- Создаем временную таблицу 'kinopoisk_data'.
create temp table temp_data(
  id serial primary key,
  title varchar(128),
  person_fio varchar(128),
  person_type varchar(64)
);

-- Добавление данных по фильму.
insert into films(title, country, box_office, release_date) values
  ('Catch Me If You Can', 'USA, Canada', 164615351, to_date('16 Dec 2002', 'DD Mon YYYY'))
  ,('The Aviator', 'Germany, USA', 102610330, to_date('14 Dec 2004', 'DD Mon YYYY'))
  ,('Meet Joe Black', 'USA', 44619100, to_date('02 Nov 1998', 'DD Mon YYYY'))
  ,('Intouchables (1+1)', 'France', 10198820, to_date('23 Sep 2011', 'DD Mon YYYY'))
  ,('Forrest Gump', 'USA', 329694499, to_date('23 Jun 1994', 'DD Mon YYYY'));

-- Создание временные данные.
with persons_in_films(title, person_type, fio) as(values
  ('Catch Me If You Can', 'Film director', 'Steven Spielberg')
  ,('Catch Me If You Can', 'Actor', 'Leonardo DiCaprio')
  ,('Catch Me If You Can', 'Actor', 'Tom Hanks')
  ,('Catch Me If You Can', 'Actor', 'Christopher Walken')
  ,('Catch Me If You Can', 'Actor', 'Martin Sheen')
  ,('Catch Me If You Can', 'Actress', 'Natalie Bai')
  ,('Catch Me If You Can', 'Actress', 'Amy Adams')
  ,('Catch Me If You Can', 'Actor', 'James Brolin')
  ,('Catch Me If You Can', 'Actor', 'Brian Howe')
  ,('Catch Me If You Can', 'Actor', 'Frank John Hughes')
  ,('Catch Me If You Can', 'Actor', 'Steve Eastin')
  ,('The Aviator', 'Film director', 'Martin Scorsese')
  ,('The Aviator', 'Actor', 'Leonardo DiCaprio')
  ,('The Aviator', 'Actress', 'Cate Blanchett')
  ,('The Aviator', 'Actor', 'Matt Ross')
  ,('The Aviator', 'Actor', 'John C. Riley')
  ,('The Aviator', 'Actor', 'Alan Alda')
  ,('The Aviator', 'Actress', 'Kate Beckinsale')
  ,('The Aviator', 'Actor', 'Alec Baldwin')
  ,('The Aviator', 'Actor', 'Ian Holm') 
  ,('The Aviator', 'Actor', 'Adam Scott')
  ,('The Aviator', 'Actor', 'Danny Houston')
  ,('Meet Joe Black', 'Film director', 'Martin Brest')
  ,('Meet Joe Black','Actor','Brad Pitt')
  ,('Meet Joe Black','Actor','Anthony Hopkins')
  ,('Meet Joe Black','Actress','Claire Forlani')
  ,('Meet Joe Black','Actor','Jake Weber')
  ,('Meet Joe Black','Actress','Marsha Gay Harden')
  ,('Meet Joe Black','Actor','Jeffrey Tambor')
  ,('Meet Joe Black','Actor','David S. Howard')
  ,('Meet Joe Black','Actress','Louis Kelly-Miller')
  ,('Meet Joe Black','Actress','Gianni St. John')
  ,('Meet Joe Black','Actor','Richard Clarke')
  ,('Intouchables (1+1)','Film director','Olivier Nakash')
  ,('Intouchables (1+1)','Film director','Eric Toledano')
  ,('Intouchables (1+1)','Actor','Francois Cluzet')
  ,('Intouchables (1+1)','Actor','Omar Si')
  ,('Intouchables (1+1)','Actress','Anne Le Nee')
  ,('Intouchables (1+1)','Actress','Audrey Flero')
  ,('Intouchables (1+1)','Actress','Josephine de Meaux')
  ,('Intouchables (1+1)','Actress','Clotilde Mollet')
  ,('Intouchables (1+1)','Actress','Alba Gaia Creede Of Bellugi')
  ,('Intouchables (1+1)','Actor','Cyril Mendy')
  ,('Intouchables (1+1)','Actress','Salimata Kamate')
  ,('Intouchables (1+1)','Actress','Absa Dyatu Tour')
  ,('Forrest Gump','Film director','Robert Zemeckis')
  ,('Forrest Gump','Actor','Tom Hanks')
  ,('Forrest Gump','Actress','Robin Wright')
  ,('Forrest Gump','Actress','Sally Field')
  ,('Forrest Gump','Actor','Gary Sinise')
  ,('Forrest Gump','Actor','Mykelti Williamson')
  ,('Forrest Gump','Actor','Michael Conner Humphrey')
  ,('Forrest Gump','Actress','Hannah R. Hall')
  ,('Forrest Gump','Actor','Sam Anderson')
  ,('Forrest Gump','Actress','Shawan Fallon')
  ,('Forrest Gump','Actress','Rebecca Williams')
)


-- Заполняем временную таблицу 'kinopoisk_data' значениями (Название фильма, тип персоны, ФИО персоны)
insert into temp_data(title, person_type, person_fio)  
  select pif.title, pif.person_type, pif.fio from persons_in_films pif;

-- Заполняем таблицу 'persons'.
insert into persons(fio) 
  select td.person_fio from temp_data td on conflict(fio) do nothing;

-- Заполнение таблицы 'person2person'.
insert into person2content(film_id, person_id, person_type)
  select films.id, persons.id, td.person_type
    from temp_data td
    left join films on films.title = td.title
    left join persons on persons.fio = td.person_fio
