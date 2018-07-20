DROP TABLE IF EXISTS visits;
DROP TABLE IF EXISTS service_users;
DROP TABLE IF EXISTS workers;

CREATE TABLE service_users(
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  weekly_budget DECIMAL(8,2)
);

CREATE TABLE workers(
  id SERIAL8 PRIMARY KEY,
  name VARCHAR(255),
  gender CHAR(1),
  can_drive BOOLEAN,
  hourly_rate DECIMAL(5,2),
  experience TEXT
);

CREATE TABLE visits(
  id SERIAL8 PRIMARY KEY,
  service_user_id INT8 REFERENCES service_users(id) ON DELETE CASCADE,
  worker_id INT8 REFERENCES workers(id) ON DELETE CASCADE
);
