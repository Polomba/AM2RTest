import os

def create_file(file_path, content=""):
    with open(file_path, 'w') as file:
        file.write(content)

def create_directory(directory_path):
    os.makedirs(directory_path, exist_ok=True)

def generate_file_structure(feature_name):
    features_directory = "../features/"
    feature_directory = f"{features_directory}{feature_name}/"
    domain_directory = f"{feature_directory}domain/"
    use_cases_directory = f"{domain_directory}use_cases/"
    presentation_directory = f"{feature_directory}presentation/"
    business_components_directory = f"{presentation_directory}business_components/"
    user_interfaces_directory = f"{presentation_directory}user_interfaces/"

    create_directory(feature_directory)
    create_directory(domain_directory)
    create_directory(use_cases_directory)
    create_directory(presentation_directory)
    create_directory(business_components_directory)
    create_directory(user_interfaces_directory)

    use_case_file_path = f"{use_cases_directory}{feature_name}_use_case.dart"
    use_case_impl_file_path = f"{use_cases_directory}{feature_name}_use_case_impl.dart"
    cubit_file_path = f"{business_components_directory}{feature_name}_cubit.dart"
    state_file_path = f"{business_components_directory}{feature_name}_state.dart"
    ui_file_path = f"{user_interfaces_directory}{feature_name}_ui.dart"

    create_file(use_case_file_path)
    create_file(use_case_impl_file_path)
    create_file(cubit_file_path)
    create_file(state_file_path)
    create_directory(f"{presentation_directory}components/")
    create_file(ui_file_path)

if __name__ == "__main__":
    feature_name = input("Enter the name of the feature: ")
    generate_file_structure(feature_name)
    print(f"File structure for {feature_name} created successfully.")
