import requests
import pandas as pd
import matplotlib.pyplot as plt

def fetch_data(url):
    """
    Fetch data from a given URL.

    Parameters
    ----------
    url : str
        The URL to fetch data from.

    Returns
    -------
    str
        The content of the response.
    """
    response = requests.get(url)
    return response.text

def create_dataframe(data):
    """
    Create a pandas DataFrame from a list of dictionaries.

    Parameters
    ----------
    data : list of dict
        List of dictionaries to convert into a DataFrame.

    Returns
    -------
    DataFrame
        The pandas DataFrame.
    """
    df = pd.DataFrame(data)
    return df

def plot_data(df):
    """
    Plot data from a DataFrame.

    Parameters
    ----------
    df : DataFrame
        The pandas DataFrame to plot.
    """
    df.plot(kind='bar')
    plt.show()

def main():
    # Use the requests package to fetch data
    url = 'https://jsonplaceholder.typicode.com/todos'
    data = fetch_data(url)
    print("Data fetched:", data[:100]) # Print first 100 characters of data

    # Use the pandas package to create and manipulate a DataFrame
    df = create_dataframe([{'task': 'task1', 'status': 1}, {'task': 'task2', 'status': 0}])
    print("DataFrame created:", df)

    # Use matplotlib to plot data
    plot_data(df)

if __name__ == "__main__":
    main()
