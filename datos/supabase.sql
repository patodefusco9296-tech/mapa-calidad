-- 1) Tabla
create table if not exists public.puntos (
  id          bigint primary key,
  nombre      text not null,
  categoria   text not null check (categoria in ('Buena','Moderada','Mala')),
  latitud     double precision not null,
  longitud    double precision not null,
  valor       numeric(5,1) not null,  -- PM2.5 en µg/m³
  temperatura numeric(4,1),
  humedad     integer,
  fecha       timestamptz,
  descripcion text  -- barrio
);

-- 2) Lectura pública (la app usa la clave pública/anon)
alter table public.puntos enable row level security;
drop policy if exists "Lectura publica" on public.puntos;
create policy "Lectura publica" on public.puntos for select to anon, authenticated using (true);

-- 3) Datos (60 sensores)
insert into public.puntos (id,nombre,categoria,latitud,longitud,valor,temperatura,humedad,fecha,descripcion) values
(1,'Sensor 01 - Av. Corrientes y Callao','Moderada',-34.6043,-58.3921,29.5,21.7,66,'2026-10-20T17:30:00-03:00','Balvanera'),
(2,'Sensor 02 - Plaza Miserere','Moderada',-34.609,-58.406,24.2,23.2,69,'2026-10-20T11:15:00-03:00','Balvanera'),
(3,'Sensor 03 - Microcentro - Florida','Mala',-34.6037,-58.3765,36.3,21.4,75,'2026-10-20T13:00:00-03:00','San Nicolás'),
(4,'Sensor 04 - Obelisco - 9 de Julio','Moderada',-34.6037,-58.3816,32.3,23.6,70,'2026-10-20T14:15:00-03:00','San Nicolás'),
(5,'Sensor 05 - Plaza de Mayo','Mala',-34.6083,-58.3712,39.3,20.4,74,'2026-10-20T12:45:00-03:00','Montserrat'),
(6,'Sensor 06 - Plaza Constitución','Mala',-34.6275,-58.3815,37.4,21.3,69,'2026-10-20T19:00:00-03:00','Constitución'),
(7,'Sensor 07 - Terminal Retiro','Moderada',-34.589,-58.374,30.1,20.6,66,'2026-10-20T11:00:00-03:00','Retiro'),
(8,'Sensor 08 - Av. Pueyrredón y Santa Fe','Mala',-34.5958,-58.402,36.8,24.6,78,'2026-10-20T19:15:00-03:00','Recoleta'),
(9,'Sensor 09 - Parque Las Heras','Moderada',-34.585,-58.407,22.8,20.6,76,'2026-10-20T08:00:00-03:00','Recoleta'),
(10,'Sensor 10 - Plaza Italia','Moderada',-34.581,-58.421,32.5,22.5,60,'2026-10-20T19:00:00-03:00','Palermo'),
(11,'Sensor 11 - Bosques de Palermo','Buena',-34.571,-58.417,12.6,19.5,67,'2026-10-20T18:00:00-03:00','Palermo'),
(12,'Sensor 12 - Palermo Hollywood','Moderada',-34.583,-58.437,20.8,20.5,63,'2026-10-20T08:45:00-03:00','Palermo'),
(13,'Sensor 13 - Reserva Ecológica','Buena',-34.613,-58.356,8.0,20.4,75,'2026-10-20T13:45:00-03:00','Puerto Madero'),
(14,'Sensor 14 - Dique 3','Buena',-34.614,-58.365,11.6,18.8,59,'2026-10-20T14:30:00-03:00','Puerto Madero'),
(15,'Sensor 15 - Parque Lezama','Moderada',-34.628,-58.37,23.3,23.3,64,'2026-10-20T15:30:00-03:00','San Telmo'),
(16,'Sensor 16 - Caminito','Mala',-34.639,-58.363,45.5,23.2,69,'2026-10-20T18:30:00-03:00','La Boca'),
(17,'Sensor 17 - Puente Pueyrredón','Mala',-34.651,-58.386,37.5,21.8,67,'2026-10-20T11:45:00-03:00','Barracas'),
(18,'Sensor 18 - Av. Montes de Oca','Moderada',-34.64,-58.378,27.7,19.8,61,'2026-10-20T09:30:00-03:00','Barracas'),
(19,'Sensor 19 - Parque Patricios - Caseros','Buena',-34.637,-58.401,15.0,22.1,68,'2026-10-20T17:45:00-03:00','Parque Patricios'),
(20,'Sensor 20 - Av. Sáenz','Mala',-34.65,-58.418,44.8,23.4,77,'2026-10-20T18:45:00-03:00','Nueva Pompeya'),
(21,'Sensor 21 - Riachuelo - Puente Alsina','Moderada',-34.656,-58.411,26.7,21.5,63,'2026-10-20T11:15:00-03:00','Nueva Pompeya'),
(22,'Sensor 22 - Av. San Juan y Boedo','Moderada',-34.625,-58.417,34.3,24.5,58,'2026-10-20T12:30:00-03:00','Boedo'),
(23,'Sensor 23 - Av. Jujuy','Moderada',-34.623,-58.404,32.6,23.6,62,'2026-10-20T09:45:00-03:00','San Cristóbal'),
(24,'Sensor 24 - Abasto','Moderada',-34.604,-58.411,34.9,24.5,70,'2026-10-20T18:30:00-03:00','Almagro'),
(25,'Sensor 25 - Parque Centenario','Buena',-34.607,-58.435,7.6,21.9,63,'2026-10-20T07:15:00-03:00','Caballito'),
(26,'Sensor 26 - Primera Junta','Mala',-34.62,-58.441,39.9,21.9,74,'2026-10-20T13:00:00-03:00','Caballito'),
(27,'Sensor 27 - Parque Rivadavia','Moderada',-34.619,-58.434,21.1,18.9,70,'2026-10-20T12:45:00-03:00','Caballito'),
(28,'Sensor 28 - Av. Corrientes y Dorrego','Moderada',-34.598,-58.44,24.8,19.9,62,'2026-10-20T20:15:00-03:00','Villa Crespo'),
(29,'Sensor 29 - Estación Chacarita','Moderada',-34.587,-58.455,33.9,24.1,67,'2026-10-20T15:30:00-03:00','Chacarita'),
(30,'Sensor 30 - Parque Los Andes','Moderada',-34.585,-58.452,17.4,20.3,72,'2026-10-20T09:30:00-03:00','Chacarita'),
(31,'Sensor 31 - Av. Cabildo y Juramento','Moderada',-34.562,-58.456,25.1,20.3,59,'2026-10-20T13:30:00-03:00','Belgrano'),
(32,'Sensor 32 - Barrancas de Belgrano','Buena',-34.56,-58.45,10.1,21.8,71,'2026-10-20T15:45:00-03:00','Belgrano'),
(33,'Sensor 33 - Colegiales - Federico Lacroze','Moderada',-34.574,-58.448,16.9,21.4,78,'2026-10-20T10:15:00-03:00','Colegiales'),
(34,'Sensor 34 - Av. Libertador y Udaondo','Moderada',-34.544,-58.456,28.1,23.9,74,'2026-10-20T20:45:00-03:00','Núñez'),
(35,'Sensor 35 - Costanera Norte','Buena',-34.54,-58.444,12.2,20.3,73,'2026-10-20T12:30:00-03:00','Núñez'),
(36,'Sensor 36 - Parque Saavedra','Buena',-34.554,-58.487,8.9,18.9,65,'2026-10-20T15:45:00-03:00','Saavedra'),
(37,'Sensor 37 - Av. General Paz - Saavedra','Mala',-34.548,-58.495,38.4,20.7,72,'2026-10-20T11:45:00-03:00','Saavedra'),
(38,'Sensor 38 - Plaza Coghlan','Moderada',-34.56,-58.475,16.9,22.9,60,'2026-10-20T08:15:00-03:00','Coghlan'),
(39,'Sensor 39 - Av. Triunvirato','Moderada',-34.573,-58.487,20.7,23.1,64,'2026-10-20T17:15:00-03:00','Villa Urquiza'),
(40,'Sensor 40 - Villa Ortúzar','Moderada',-34.58,-58.468,20.8,21.6,58,'2026-10-20T20:15:00-03:00','Villa Ortúzar'),
(41,'Sensor 41 - Parque Chas','Buena',-34.585,-58.479,14.9,20.3,69,'2026-10-20T15:30:00-03:00','Parque Chas'),
(42,'Sensor 42 - Agronomía - FAUBA','Buena',-34.5925,-58.483,11.5,22.3,65,'2026-10-20T16:00:00-03:00','Agronomía'),
(43,'Sensor 43 - La Paternal','Moderada',-34.598,-58.47,19.7,22.8,66,'2026-10-20T12:00:00-03:00','La Paternal'),
(44,'Sensor 44 - Villa Pueyrredón','Buena',-34.581,-58.504,14.8,21.2,67,'2026-10-20T20:00:00-03:00','Villa Pueyrredón'),
(45,'Sensor 45 - Plaza Arenales','Buena',-34.601,-58.515,12.2,22.4,69,'2026-10-20T11:30:00-03:00','Villa Devoto'),
(46,'Sensor 46 - Villa del Parque','Buena',-34.604,-58.493,14.4,19.9,72,'2026-10-20T09:30:00-03:00','Villa del Parque'),
(47,'Sensor 47 - Av. Rivadavia y Nazca','Moderada',-34.628,-58.463,26.0,24.3,76,'2026-10-20T11:00:00-03:00','Flores'),
(48,'Sensor 48 - Plaza Flores','Moderada',-34.629,-58.464,28.8,20.5,58,'2026-10-20T19:30:00-03:00','Flores'),
(49,'Sensor 49 - Floresta','Moderada',-34.629,-58.484,23.0,21.7,75,'2026-10-20T11:15:00-03:00','Floresta'),
(50,'Sensor 50 - Vélez Sarsfield','Buena',-34.631,-58.491,14.0,19.7,67,'2026-10-20T16:30:00-03:00','Vélez Sarsfield'),
(51,'Sensor 51 - Monte Castro','Buena',-34.619,-58.505,11.3,18.8,61,'2026-10-20T09:15:00-03:00','Monte Castro'),
(52,'Sensor 52 - Versalles','Moderada',-34.631,-58.521,23.3,23.1,70,'2026-10-20T19:15:00-03:00','Versalles'),
(53,'Sensor 53 - Liniers - Av. General Paz','Moderada',-34.642,-58.528,25.8,22.2,59,'2026-10-20T19:15:00-03:00','Liniers'),
(54,'Sensor 54 - Mataderos - Mercado','Moderada',-34.66,-58.503,33.6,24.2,68,'2026-10-20T09:45:00-03:00','Mataderos'),
(55,'Sensor 55 - Parque Avellaneda','Buena',-34.647,-58.479,6.3,21.3,79,'2026-10-20T10:00:00-03:00','Parque Avellaneda'),
(56,'Sensor 56 - Parque Chacabuco','Moderada',-34.636,-58.438,16.4,22.6,62,'2026-10-20T09:30:00-03:00','Parque Chacabuco'),
(57,'Sensor 57 - Villa Soldati - Autódromo','Mala',-34.664,-58.443,41.9,24.3,76,'2026-10-20T15:00:00-03:00','Villa Soldati'),
(58,'Sensor 58 - Villa Lugano - Av. Roca','Mala',-34.676,-58.472,42.0,21.0,73,'2026-10-20T13:30:00-03:00','Villa Lugano'),
(59,'Sensor 59 - Villa Riachuelo','Mala',-34.693,-58.47,45.9,20.0,72,'2026-10-20T16:00:00-03:00','Villa Riachuelo'),
(60,'Sensor 60 - Parque Indoamericano','Buena',-34.669,-58.452,7.1,22.8,69,'2026-10-20T09:30:00-03:00','Villa Soldati')
on conflict (id) do nothing;

-- 4) Verificación
select categoria, count(*) as sensores, round(avg(valor),1) as pm25_promedio from public.puntos group by categoria order by 3;
