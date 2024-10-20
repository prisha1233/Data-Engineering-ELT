# Kaggle Data Processing and Analysis

This project involves downloading data from Kaggle, processing it using Jupyter Notebook, and performing data analysis with SQL and Python. The focus is on cleaning and analyzing a dataset related to movies and TV shows.

## Table of Contents

- [Features](#features)
- [Technologies Used](#technologies-used)
- [Usage](#usage)
- [Data Cleaning Steps](#data-cleaning-steps)
- [Data Analysis](#data-analysis)
- [License](#license)

## Features

- Download and load data from Kaggle into a MySQL database using SQLAlchemy.
- Clean and preprocess the data:
  - Explore null values and data integrity.
  - Remove duplicate records and titles.
  - Transform lists into multiple rows and save them in new tables.
  - Handle missing values effectively.
  - Drop unnecessary columns.
- Perform comprehensive data analysis to extract insights:
  - Count of movies and shows by each director.
  - Identify countries with the highest number of comedy movies.
  - Determine the director with the most releases per year.
  - Calculate average duration of movies by genre.
  - Find directors who have created both horror and comedy movies.

## Technologies Used

- Jupyter Notebook
- Python
- SQL
- Data Modeling
- SQLAlchemy

## Data Cleaning Steps

1. Download data from Kaggle using Jupyter Notebook.
2. Load data into MySQL using SQLAlchemy.
3. Modify data types and define primary keys.
4. Explore null values for each column.
5. Validate that titles are loaded correctly, checking for null values.
6. Remove duplicate records from the dataset.
7. Identify and remove records with duplicate titles.
8. Convert the `listed_in` list into multiple rows and save as `genre_by_show`.
9. Convert the `directors` list into multiple rows and save as `director_by_show`.
10. Convert the `countries` list into multiple rows and save as `country_by_show`.
11. Handle null values for countries at the show level by updating with existing director information.
12. Correct duration entries misclassified in the rating column.
13. Drop unnecessary columns: `director`, `listed_in`, and `country`.

## Data Analysis

1. Count the number of movies and TV shows created by each director.
2. Identify the country with the highest number of comedy movies.
3. For each year, find the director with the maximum number of movies released.
4. Calculate the average duration of movies by genre.
5. List directors who have created both horror and comedy movies, displaying the count of each genre.

## License

This project is licensed under the MIT License. See the LICENSE file for details.


