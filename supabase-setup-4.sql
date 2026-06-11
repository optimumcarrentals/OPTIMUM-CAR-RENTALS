-- ============================================================
-- OPTIMUM CAR RENTALS — admin backend setup
-- Paste this whole file into Supabase: SQL Editor → New query → Run
-- ============================================================

-- 1. TABLES -------------------------------------------------

create table if not exists fleet (
  id     bigint generated always as identity primary key,
  name   text not null,
  cls    text not null,
  seats  int  not null default 5,
  trans  text not null default 'Automatic',
  fuel   text not null default 'Gas',
  rate   numeric not null,
  avail  boolean not null default true,
  img    text,            -- optional photo URL
  sort   int not null default 100
);

create table if not exists extras (
  id    bigint generated always as identity primary key,
  label text not null,
  note  text,
  rate  numeric not null,
  sort  int not null default 100
);

create table if not exists protection (
  id    bigint generated always as identity primary key,
  label text not null,
  ded   int,              -- deductible in dollars
  rate  numeric not null, -- per day
  note  text,
  sort  int not null default 100
);

-- 2. SECURITY (RLS) -----------------------------------------
-- Anyone can READ (the website needs this).
-- Only a logged-in admin can ADD / EDIT / DELETE.

alter table fleet      enable row level security;
alter table extras     enable row level security;
alter table protection enable row level security;

create policy "public read fleet"      on fleet      for select using (true);
create policy "public read extras"     on extras     for select using (true);
create policy "public read protection" on protection for select using (true);

create policy "admin write fleet"      on fleet      for all to authenticated using (true) with check (true);
create policy "admin write extras"     on extras     for all to authenticated using (true) with check (true);
create policy "admin write protection" on protection for all to authenticated using (true) with check (true);

-- 3. SEED DATA (your current fleet) -------------------------

insert into fleet (name, cls, seats, trans, fuel, rate, avail, sort) values
('Nissan Versa',        'Economy',         5, 'Automatic', 'Gas',    45,  true,  10),
('Kia Rio',             'Economy',         5, 'Automatic', 'Gas',    45,  true,  20),
('Toyota Corolla',      'Standard',        5, 'Automatic', 'Gas',    55,  true,  30),
('Nissan Sentra',       'Standard',        5, 'Automatic', 'Gas',    55,  true,  40),
('Honda Civic',         'Standard',        5, 'Automatic', 'Gas',    58,  true,  50),
('Toyota Camry',        'Full Size Sedan', 5, 'Automatic', 'Gas',    69,  true,  60),
('Nissan Altima',       'Full Size Sedan', 5, 'Automatic', 'Gas',    69,  true,  70),
('Toyota RAV4',         'SUV',             5, 'Automatic', 'Hybrid', 79,  true,  80),
('Honda CR-V',          'SUV',             5, 'Automatic', 'Gas',    79,  true,  90),
('Toyota Highlander',   'Full Size SUV',   7, 'Automatic', 'Gas',    99,  true, 100),
('Dodge Grand Caravan', '7-8 Seater',      7, 'Automatic', 'Gas',    95,  true, 110),
('Kia Carnival',        '7-8 Seater',      8, 'Automatic', 'Gas',   105,  true, 120),
('BMW 5 Series',        'Premium',         5, 'Automatic', 'Gas',   159,  true, 130),
('Mercedes-Benz GLE',   'Premium',         5, 'Automatic', 'Gas',   179,  false,140),
('Ford F-150',          'Pickup Truck',    5, 'Automatic', 'Gas',   119,  true, 150);

insert into extras (label, note, rate, sort) values
('Additional driver',        'Share the wheel — second licensed driver', 12.99, 10),
('Child / booster seat',     'Installed and ready at pickup',            14.99, 20),
('GPS navigation',           'Dedicated unit, no roaming needed',        10.99, 30),
('Tire & windshield waiver', 'Covers chips, cracks and flats',           10.99, 40),
('Young driver (23-24)',     'Required fee for drivers under 25',        21.99, 50),
('Liability coverage',       'Third-party liability top-up',              8.99, 60);

insert into protection (label, ded, rate, note, sort) values
('Basic shield', 3000, 15.99, '$3,000 deductible if claimed', 10),
('Plus shield',  2000, 19.99, '$2,000 deductible if claimed', 20),
('Super shield', 1500, 24.99, '$1,500 deductible if claimed', 30),
('Max shield',   1000, 29.99, '$1,000 deductible — lowest risk', 40);
