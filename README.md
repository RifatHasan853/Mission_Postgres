# What is PostgreSQL?
**PostgreSQL** is a free, open-source database system that supports both **relational (SQL)** and **non-relational (JSON)** queries.
It is widely used as a **back-end database** for dynamic websites and web applications due to its reliability, performance, and extensibility.
## Key Features
- Supports both **SQL** and **JSON** queries
- ACID-compliant and highly scalable
- Open-source with 35+ years of active development
## Language Support
PostgreSQL is compatible with many popular programming languages, including:
- Python
- Java  
- C / C++  
- C#  
- Node.js  
- Go  
- Ruby  
- Perl  
- Tcl

##  Primary Key and Foreign Key in PostgreSQL

Understanding **Primary Key** and **Foreign Key** constraints is essential for designing a reliable and relational PostgreSQL database.
---
###  Primary Key

A **Primary Key** uniquely identifies each record in a table. It ensures that no two rows have the same value in the key column(s) and that the column(s) are **not null**.

####  Key Characteristics:
- Must be **unique**
- Cannot contain **NULL** values
- Automatically creates a **unique index**

####  Example:

```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);

---

### Foreign Key

A **Foreign Key** is a column or group of columns in a table that **links to the Primary Key** in another table. It is used to enforce **referential integrity**, ensuring that the relationship between records in different tables remains consistent.

#### Key Characteristics:
- References a **Primary Key** in another table
- Ensures that the referenced value **exists**
- Can be used to **model relationships** between tables (e.g., one-to-many, many-to-one)
- Supports optional actions like:
  - `ON DELETE CASCADE`
  - `ON UPDATE CASCADE`
  - `SET NULL`, `RESTRICT`, etc.

#### Example:

```sql
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

