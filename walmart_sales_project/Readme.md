# Welcome to my Walmart Data Analysis project!
![Walmart Logo](walmart_logo.png)

## Project Overview

The data for this project was downloaded using the Kaggle API. To do so, I used an API key that was saved as a JSON file. If you wish to download the dataset in the same way, follow these steps:

1. Obtain your Kaggle API key by visiting [Kaggle's API page](https://www.kaggle.com/docs/api).
2. Download the `kaggle.json` file and place it in the following directory: `C:\users\your_user_name\.kaggle\kaggle.json`.
3. To download the dataset, run the following command in your terminal:

   ```bash
   kaggle datasets download -d username_of_the_dataset_provider/name_of_the_dataset_on_kaggle

The data was collected from Kaggle using a Kaggle API key. I downloaded my API key as json file and I moved that json file into C:\users\your_user_name.kaggle\kaggle.json
If you want to download the dataset in a similar way that I did, then run this command in your terminal: `kaggele datasets download -d username_of_the_dataset_provider\name_of_the_dataset_present_on_kaggle`
The database that I used throughout this project was PostgreSQL. Where I wrote my SQL queries present in the sql_queries.sql file.
My credentials for the database like (username, password, host, port, database_name) I stored into a .env file
You can find the necessary dependencies in the requirements.txt

