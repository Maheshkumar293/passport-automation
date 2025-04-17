CREATE DATABASE passport;
USE passport;
-- Table: Users (Website Registration)
CREATE TABLE users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: States
CREATE TABLE states (
  state_id INT PRIMARY KEY AUTO_INCREMENT,
  state_name VARCHAR(100) NOT NULL UNIQUE
);

-- Table: Districts
CREATE TABLE districts (
  district_id INT PRIMARY KEY AUTO_INCREMENT,
  district_name VARCHAR(100) NOT NULL,
  state_id INT,
  FOREIGN KEY (state_id) REFERENCES states(state_id)
);

-- Table: Passport Registration (Form)
CREATE TABLE passport_registrations (
  registration_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  full_name VARCHAR(100) NOT NULL,
  gender ENUM('Male','Female','Other') NOT NULL,
  dob DATE NOT NULL,
  address TEXT NOT NULL,
  state_id INT,
  district_id INT,
  region ENUM('North','South','East','West') NOT NULL,
  documents TEXT,
  status ENUM(
    'Pending',
    'Transferred to Regional Admin',
    'Transferred to Police',
    'Police Verified',
    'Regional Verified',
    'Rejected',
    'Approved'
  ) DEFAULT 'Pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (state_id) REFERENCES states(state_id),
  FOREIGN KEY (district_id) REFERENCES districts(district_id)
);

-- Table: Admins
CREATE TABLE admins (
  admin_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
   email VARCHAR(100) UNIQUE NOT NULL
);

-- Table: Regional Admins
CREATE TABLE regional_admins (
  regional_admin_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  region ENUM('North','South','East','West') NOT NULL,
   email VARCHAR(100) UNIQUE NOT NULL
);

-- Table: Police Officers
CREATE TABLE police_officers (
  police_id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(50) UNIQUE NOT NULL,
  password VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  district_id INT,
   email VARCHAR(100) UNIQUE NOT NULL,
  FOREIGN KEY (district_id) REFERENCES districts(district_id)
);

-- Table: Admin Transfer to Regional Admin
CREATE TABLE admin_to_regional (
  transfer_id INT PRIMARY KEY AUTO_INCREMENT,
  registration_id INT,
  admin_id INT,
  regional_admin_id INT,
  transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (registration_id) REFERENCES passport_registrations(registration_id),
  FOREIGN KEY (admin_id) REFERENCES admins(admin_id),
  FOREIGN KEY (regional_admin_id) REFERENCES regional_admins(regional_admin_id)
);

-- Table: Regional Transfer to Police
CREATE TABLE regional_to_police (
  transfer_id INT PRIMARY KEY AUTO_INCREMENT,
  registration_id INT,
  regional_admin_id INT,
  police_id INT,
  transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (registration_id) REFERENCES passport_registrations(registration_id),
  FOREIGN KEY (regional_admin_id) REFERENCES regional_admins(regional_admin_id),
  FOREIGN KEY (police_id) REFERENCES police_officers(police_id)
);

-- Table: Police Verification
CREATE TABLE police_verifications (
  verification_id INT PRIMARY KEY AUTO_INCREMENT,
  registration_id INT,
  police_id INT,
  status ENUM('Verified','Rejected') NOT NULL,
  remarks TEXT,
  verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (registration_id) REFERENCES passport_registrations(registration_id),
  FOREIGN KEY (police_id) REFERENCES police_officers(police_id)
);

-- Table: Regional Final Verification
CREATE TABLE regional_verifications (
  verification_id INT PRIMARY KEY AUTO_INCREMENT,
  registration_id INT,
  regional_admin_id INT,
  status ENUM('Verified','Rejected') NOT NULL,
  remarks TEXT,
  verified_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (registration_id) REFERENCES passport_registrations(registration_id),
  FOREIGN KEY (regional_admin_id) REFERENCES regional_admins(regional_admin_id)
);

-- Table: Admin Final Decision
CREATE TABLE admin_approvals (
  approval_id INT PRIMARY KEY AUTO_INCREMENT,
  registration_id INT,
  admin_id INT,
  status ENUM('Approved', 'Rejected') NOT NULL,
  remarks TEXT,
  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (registration_id) REFERENCES passport_registrations(registration_id),
  FOREIGN KEY (admin_id) REFERENCES admins(admin_id)
);

-- Table: Appointments
CREATE TABLE appointments (
  appointment_id INT PRIMARY KEY AUTO_INCREMENT,
  registration_id INT,
  appointment_date DATE NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (registration_id) REFERENCES passport_registrations(registration_id)
);
USE  passport;
SHOW TABLES;
SELECT * FROM admin_approvals;