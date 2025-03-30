# Welcome to my Walmart Data Analysis project!
![Walmart Logo](walmart_logo.png)

## Project Overview

### Getting the data
The data for this project was downloaded using the Kaggle API. To do so, I used an API key that was saved as a JSON file. If you wish to download the dataset in the same way, follow these steps:
1. Obtain your Kaggle API key by visiting [Kaggle's API page](https://www.kaggle.com/docs/api).
2. Download the `kaggle.json` file and place it in the following directory: `C:\users\your_user_name\.kaggle\kaggle.json`.
3. To download the dataset, run the following command in your terminal:

   ```bash
   kaggle datasets download -d username_of_the_dataset_provider/name_of_the_dataset_on_kaggle

### Database
For this project, I used PostgreSQL as the database to store and manage the data. The SQL queries used for data extraction and transformation can be found in the `sql_queries.sql` file. I have stored the necessary database credentials (e.g., username, password, host, port, and database name) in a .env file for security reasons. Please ensure you create your own .env file with appropriate credentials before running the code.

### Requirements
The project dependencies can be found in the `requirements.txt` file. To install the necessary Python packages, you can run the following command:

```bash
pip install -r requirements.txt

