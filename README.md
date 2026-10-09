# Parch & Posey Sales Analysis

SQL analysis of a fictional paper company's sales, customer and web-engagement data. The project examines customer value, sales-representative performance, regional revenue and digital interaction patterns across a five-table relational database.

![Parch & Posey entity-relationship diagram](https://github.com/M3tz43/Parsh_and_Posey_Database/assets/107323458/20df9635-ca8a-4abf-8296-28e4e57a7fb7)

## Business questions

- Which customers generate the highest lifetime revenue?
- How can customers be segmented by purchasing value?
- Which sales representatives and regions perform best?
- Which sales and ordering patterns change over time?
- How do customers engage through different web channels?

## Dataset

| Table | Contents |
| --- | --- |
| `accounts` | Customer accounts and primary contacts |
| `orders` | Order quantities, dates and revenue |
| `sales_reps` | Sales representatives assigned to accounts |
| `region` | U.S. sales regions |
| `web_events` | Customer interactions by digital channel |

The dataset represents Parch & Posey, a fictional paper company with 50 sales representatives operating across four U.S. regions.

## SQL techniques demonstrated

- Multi-table joins
- Aggregation and grouped analysis
- Common table expressions (CTEs)
- Nested subqueries
- Conditional logic with `CASE`
- Date-based analysis with `DATE_TRUNC`
- Customer segmentation and ranking
- String transformation

## Repository structure

- `Parsh and posey Questions.sql` — analysis questions and PostgreSQL queries
- `Parsh_and_posey_tables/` — CSV files for the five source tables

## Running the analysis

1. Create a PostgreSQL database.
2. Create the five tables according to the entity-relationship diagram.
3. Import the CSV files from `Parsh_and_posey_tables/`.
4. Open `Parsh and posey Questions.sql` in pgAdmin or another PostgreSQL client.
5. Run the queries individually to reproduce the analyses.

## Data source

The Parch & Posey dataset is an educational dataset used in Udacity's SQL coursework and originally provided through Mode Analytics.

