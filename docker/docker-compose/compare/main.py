import os
import pandas as pd

def compare_columns_and_show_differences(file1, file2, column_name, other_columns=None):
    # Read files into pandas dataframes
    df1 = pd.read_csv(file1)  # Use pd.read_excel() for Excel files
    df2 = pd.read_csv(file2)  # Use pd.read_excel() for Excel files

    # Compare specific columns
    columns_to_compare = [column_name] + (other_columns or [])
    columns1 = df1[columns_to_compare]
    columns2 = df2[columns_to_compare]

    # Merge dataframes to find differences
    merged_df = pd.merge(columns1, columns2, how='outer', left_index=True, right_index=True, suffixes=('_in_' + recent_files[0], '_in_' + recent_files[1]))

    # Identify rows with differences
    differences = merged_df[merged_df[column_name + '_in_' + recent_files[0]] != merged_df[column_name + '_in_' + recent_files[1]]]

    return differences

# Example usage
folder_path = '/path/to/your/folder'
recent_files = get_recent_files(folder_path)

if len(recent_files) >= 2:
    file1_path = os.path.join(folder_path, recent_files[0])
    file2_path = os.path.join(folder_path, recent_files[1])

    column_name = 'your_column_name'  # Replace with the actual column name
    other_columns = ['other_column1', 'other_column2']  # Replace with other column names, or set to None

    differences = compare_columns_and_show_differences(file1_path, file2_path, column_name, other_columns)

    if differences.empty:
        print(f"No differences found in columns between {recent_files[0]} and {recent_files[1]}.")
    else:
        print(f"Differences in columns:")
        print(differences)
else:
    print("Not enough files to compare.")
