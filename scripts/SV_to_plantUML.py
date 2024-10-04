import re
import argparse
import os

def extract_classes_and_details(content, only_class=False):
    # Regex para encontrar clases, herencia, atributos y métodos
    class_pattern = r'class\s+(\w+)(?:\s+extends\s+(\w+))?'
    attribute_pattern = r'(\w+)\s+(\w+);'
    pure_virtual_function_pattern = r'pure\s+virtual\s+function\s+(\w+)\s+(\w+)\s*\(([^)]*)\);'
    pure_virtual_task_pattern = r'pure\s+virtual\s+task\s+(\w+)\s*\(([^)]*)\);'
    method_pattern = r'(function|task)\s+(\w+)\s+(\w+)\s*\(([^)]*)\);'
    constructor_pattern = r'function\s+new\s*\(([^)]*)\);'

    classes = {}
    current_class = None
    in_first_method = False  # Flag para indicar si ya encontramos el primer método
    
    for line in content.splitlines():
        # Buscar clases
        class_match = re.search(class_pattern, line)
        if class_match:
            current_class = class_match.group(1)
            classes[current_class] = {'parent': class_match.group(2), 'attributes': [], 'methods': []}
            in_first_method = False  # Reiniciar el flag para una nueva clase
            continue
        
        if only_class:
            continue  # Si la opción only_class está activada, saltamos el procesamiento de atributos y métodos
        
        # Buscar atributos solo antes del primer método
        if current_class and not in_first_method:
            attribute_match = re.search(attribute_pattern, line)
            if attribute_match:
                # Cambiar el formato a nombre: tipo
                attr_type = attribute_match.group(1)
                attr_name = attribute_match.group(2)
                classes[current_class]['attributes'].append(f'{attr_name}: {attr_type}')
            
            # Buscar el constructor
            constructor_match = re.search(constructor_pattern, line)
            if constructor_match:
                in_first_method = True  # Ya encontramos el primer método
                arguments = constructor_match.group(1).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                classes[current_class]['methods'].append(f'+new({", ".join(arg_types)})')
                continue

            # Buscar el primer método (pure virtual o normal)
            pure_virtual_function_match = re.search(pure_virtual_function_pattern, line)
            if pure_virtual_function_match:
                in_first_method = True  # Ya encontramos el primer método
                return_type = pure_virtual_function_match.group(1)  # Obtener el tipo de retorno
                method_name = pure_virtual_function_match.group(2)
                arguments = pure_virtual_function_match.group(3).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                # Solo agregar si no es void
                if return_type != 'void':
                    classes[current_class]['methods'].append(f'>{method_name}({", ".join(arg_types)}) : {return_type}')
                else:
                    classes[current_class]['methods'].append(f'>{method_name}({", ".join(arg_types)})')
                continue

            pure_virtual_task_match = re.search(pure_virtual_task_pattern, line)
            if pure_virtual_task_match:
                in_first_method = True  # Ya encontramos el primer método
                method_name = pure_virtual_task_match.group(1)
                arguments = pure_virtual_task_match.group(2).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                classes[current_class]['methods'].append(f'>{method_name}({", ".join(arg_types)})')
                continue
            
            method_match = re.search(method_pattern, line)
            if method_match:
                in_first_method = True  # Ya encontramos el primer método
                method_type = method_match.group(1)  # function o task
                method_name = method_match.group(3)  # Obtenemos el nombre del método
                return_type = method_match.group(2) if method_type == 'function' else 'void'
                # Extraer los argumentos y sus tipos
                arguments = method_match.group(4).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                
                # Solo agregar el método si no contiene if, else o case
                if 'if' not in line and 'else' not in line and 'case' not in line:
                    if return_type != 'void':  # Solo agregar si no es void
                        classes[current_class]['methods'].append(f'+{method_name}({", ".join(arg_types)}) : {return_type}')
                    else:
                        classes[current_class]['methods'].append(f'+{method_name}({", ".join(arg_types)})')

        elif in_first_method:  # Si ya se encontró el primer método, continuar buscando métodos
            pure_virtual_function_match = re.search(pure_virtual_function_pattern, line)
            if pure_virtual_function_match:
                return_type = pure_virtual_function_match.group(1)  # Obtener el tipo de retorno
                method_name = pure_virtual_function_match.group(2)
                arguments = pure_virtual_function_match.group(3).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                if return_type != 'void':
                    classes[current_class]['methods'].append(f'>{method_name}({", ".join(arg_types)}) : {return_type}')
                else:
                    classes[current_class]['methods'].append(f'>{method_name}({", ".join(arg_types)})')
                continue

            pure_virtual_task_match = re.search(pure_virtual_task_pattern, line)
            if pure_virtual_task_match:
                method_name = pure_virtual_task_match.group(1)
                arguments = pure_virtual_task_match.group(2).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                classes[current_class]['methods'].append(f'>{method_name}({", ".join(arg_types)})')
                continue
            
            method_match = re.search(method_pattern, line)
            if method_match:
                method_type = method_match.group(1)  # function o task
                method_name = method_match.group(3)  # Obtenemos el nombre del método
                return_type = method_match.group(2) if method_type == 'function' else 'void'
                # Extraer los argumentos y sus tipos
                arguments = method_match.group(4).strip()
                arg_types = [arg.split()[0] for arg in arguments.split(',')] if arguments else []
                
                # Solo agregar el método si no contiene if, else o case
                if 'if' not in line and 'else' not in line and 'case' not in line:
                    if return_type != 'void':  # Solo agregar si no es void
                        classes[current_class]['methods'].append(f'+{method_name}({", ".join(arg_types)}) : {return_type}')
                    else:
                        classes[current_class]['methods'].append(f'+{method_name}({", ".join(arg_types)})')

    return classes

def generate_plantuml(classes, only_class=False):
    plantuml_code = '@startuml\n'
    
    for class_name, details in classes.items():
        plantuml_code += f'class {class_name} {{\n'
        
        if not only_class:
            # Agregar atributos en formato nombre: tipo
            for attr in details['attributes']:
                plantuml_code += f'    + {attr}\n'
            
            # Agregar métodos en formato método(): retorno (si no es void)
            for method in details['methods']:
                plantuml_code += f'    {method}\n'
        
        plantuml_code += '}\n'
    
    # Agregar relaciones de herencia después de todas las clases
    for class_name, details in classes.items():
        if details['parent']:
            plantuml_code += f'{details["parent"]} <|-- {class_name}\n'
    
    plantuml_code += '@enduml'
    
    # Eliminar : void
    plantuml_code = plantuml_code.replace(': void', '')

    return plantuml_code

def process_sv_file(file_path, only_class=False):
    with open(file_path, 'r') as file:
        content = file.read()
    return extract_classes_and_details(content, only_class=only_class)

def process_folder(folder_path, only_class=False):
    all_classes = {}
    
    # Buscar todos los archivos .sv en la carpeta
    for root, _, files in os.walk(folder_path):
        for file in files:
            if file.endswith('.sv'):
                file_path = os.path.join(root, file)
                print(f"Procesando archivo: {file_path}")
                classes = process_sv_file(file_path, only_class=only_class)
                all_classes.update(classes)
    
    return all_classes

def main(input_file, output_file, folder=False, only_class=False):
    if folder:
        classes = process_folder(input_file, only_class=only_class)
    else:
        classes = process_sv_file(input_file, only_class=only_class)
    
    plantuml_code = generate_plantuml(classes, only_class=only_class)
    
    with open(output_file, 'w') as file:
        file.write(plantuml_code)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Convert SystemVerilog file(s) to PlantUML.')
    parser.add_argument('input_file', help='Path to the input SystemVerilog file or folder.')
    parser.add_argument('output_file', help='Path to the output PlantUML file.')
    parser.add_argument('--folder', action='store_true', help='Indica que input_file es una carpeta que contiene archivos SystemVerilog.')
    parser.add_argument('--only_class', action='store_true', help='Extrae solo las clases sin atributos ni métodos.')

    args = parser.parse_args()

    input_file = args.input_file
    output_file = args.output_file

    # Si se usa el argumento --folder, se asigna input_file el mismo valor que folder
    if args.folder:
        input_file = args.input_file  # Se utiliza directamente el folder como input_file
    
    main(input_file, output_file, folder=args.folder, only_class=args.only_class)
