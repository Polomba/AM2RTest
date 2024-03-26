import re
import pandas as pd
import os

# Get the directory of the current script
script_directory = os.path.dirname(os.path.abspath(__file__))

# Specify the relative path to the Excel file from the script
excel_file_path=os.path.normpath(os.path.join(script_directory,'../strings/strings.xlsx'))

# Specify the relative path to the Flutter project directory from the script
flutter_project_relative_path = '../../../Application/'
flutter_project_directory = os.path.normpath(os.path.join(script_directory, flutter_project_relative_path))

# Specify the relative path to the Flutter project localization directory
output_directory_relative_path = 'lib/l10n'
output_directory = os.path.join(flutter_project_directory, output_directory_relative_path)


df=pd.read_excel(excel_file_path,header=None)

# Extract headers and data
data = df.iloc[4:].values.tolist()
print(data)

languages=['PT', 'EN', 'ES']
# Generate ARB files
for language in languages:
    arb_data = {}
    language_index= languages.index(language)+3
    for row in data[1:]:

        string_name = row[2]
        translation = row[language_index]
        print(string_name,translation)
        arb_data[string_name] = translation

        # Extract all dynamic placeholders from the translation string
        placeholders = re.findall(r'{(\w+)}', translation)

        # Create a list of placeholders with their indices
        placeholders_with_indices = [f'{{param{i}}}' for i in range(len(placeholders))]

        # Replace placeholders in the translation string with numbered placeholders
        formatted_translation = re.sub(r'{\w+}', lambda x: placeholders_with_indices.pop(0), translation)

        arb_data[string_name] = formatted_translation

    # Save ARB file for each language
    arb_file_path = os.path.join(output_directory, f'app_{language}.arb')
    with open(arb_file_path, 'w', encoding='utf-8') as arb_file:
        arb_file.write('{\n')
        for i, (key, value) in enumerate(arb_data.items()):
            arb_file.write(f'  "{key}": "{value}"')
            if i < len(arb_data) - 1:
                arb_file.write(',\n')
        arb_file.write('\n}\n')
