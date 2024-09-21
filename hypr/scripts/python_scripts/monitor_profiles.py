import sys
import subprocess
import os
import re

path = "/home/squarewinter/.config/hypr/monitor_config/monitors.config"
class parser_class:
    def raise_error(self, text):
        subprocess.run(["notify-send", f"{text}"])

    def remove_brackets(self, text):
        # this removes the trailing and leading brackets and whitespaces
        to_be_removed = [" ", "\t", "\n", "{", "}"]
        result = list(text)
        while (result[0] in to_be_removed):
            result.pop(0)
        
        while (result[-1] in to_be_removed):
            result.pop(-1);
        return "".join(result)
    
    def extract_monitors(self, text):
        #print("MONITORS FUNC GOT: ", text)
        text = text[0]
        if text[0] != "{":
            #this is an error
            self.raise_error("config file wrong format")
            return None
        text = text[1:]
        for index, character in enumerate(text):
            if character == "}":
                break;
        text = text[:index]
        # spliting the monitors
        monitors = text.split(",")
        #removing the quotation marks
        monitors = [monitor[1:-1] for monitor in monitors]
        return monitors
    
    def extract_path(self, text):
        #print("PATH FUNC GOT: ", text)
        if len(text) > 1:
            self.raise_error("error in parsing tha path")
        return text[0][1:-1]
    

def isolate_attributes(text):
    text = text.split("\n")
    name, make, model, serial = [], [], [], []
    for line in text:
        if "make:" in line.lower():
            res = " ".join(line.split(" ")[1:])
            #print(f"make case res: {res}")
            make.append(res)
        elif "model:" in line.lower():
            res = " ".join(line.split(" ")[1:])
            model.append(res)
        elif "serial:" in line.lower():
            res = " ".join(line.split(" ")[1:])
            serial.append(res)
        elif "monitor" in line.lower():
            res = line.split(" ")[1]
            name.append(res)
    return (name, make, model, serial)


def read_config(path:str):
    data = []
    with open(path, "r") as file:
        for line in file.readlines():
            # in case line.strip() is an empty string, this and ensures that it works either way
            if line.strip() and line.strip()[0] != "#" and ("docked" in line or "undocked" in line):
                for index, value in enumerate(line):
                    if value == "=":
                        line = line[index+2:]
                        break
                data.append(line)
    for index, line in enumerate(data):
        data[index] = [substr.split(",") for substr in  re.split(r'(?=(?:[^"]|"[^"]*")*$)\s+', line) if substr != '']
    print(data)
    return data

def get_docked_state():
    with open("/home/squarewinter/.config/hypr/hyprland.conf") as file:
        line = file.readline()
        while 1:
            if "DOCKED_STATE_FLAG" in line:
                break
            line = file.readline()
        for index, value in enumerate(line):
            if value == "=":
                return line[index+1:]
def find_name_by_model(model:str):
    data = subprocess.run(["hyprctl", "monitors all"], stdout=subprocess.PIPE).stdout.decode("utf-8")#sys.stdin.read()
    monitors = isolate_attributes(data)
    for index, string in enumerate(monitors[2]):
        if string == model:
            return monitors[0][index]


def write_to_file():
    def transpose_matrix(matrix):
        # Using list comprehension to transpose the matrix
        transposed = [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]
        return transposed
    def write(file_name:str, file_contents):
        with open(f"/home/squarewinter/.config/hypr/monitor_profiles/{file_name}", "w") as file:
            file.write(file_contents)
    def change_docked_state():
        with open("/home/squarewinter/.config/hypr/hyprland.conf", "r+")as file:
            lines = file.readlines()
            #0 = docked, 1 = undocked
            flag = 0
            for index, line in enumerate(lines):
                if "DOCKED_STATE_FLAG" in line:
                    if "docked" in line and "undocked" not in line:
                        lines[index] = "#DOCKED_STATE_FLAG=undocked\n"
                        flag = 1
                    elif "undocked" in line:
                        lines[index] = "#DOCKED_STATE_FLAG=docked\n"
                if "hypr/monitor_profiles/" in line:
                    lines[index] = "source = ~/.config/hypr/monitor_profiles/docked1_profile.conf\n" if flag == 0 else "source = ~/.config/hypr/monitor_profiles/undocked1_profile.conf\n"
                    break
            file.seek(0)
            file.truncate()
            file.writelines(lines)

    docked_state = get_docked_state().strip()
    config = read_config(path)
    file_contents = ""
    if docked_state.lower() == "docked":
        data_matrix = transpose_matrix(config[0])
        data_matrix = [[i.replace('"', '') for i in j] for j in data_matrix]
        for i in range(len(data_matrix)):
            data_matrix[i][0] = find_name_by_model(data_matrix[i][0])
        for row in data_matrix:
            if row[4] != "_":
                temp = "monitor = "
                for string in row[:-1]:
                    temp += f"{string}, "
                temp += f"transform,{row[-1]}"
                file_contents += f"{temp}\n"
            else:
                temp = "monitor = "
                for string in row:
                    if string == '_':
                        break
                    temp += f"{string}, "
                file_contents += f"{temp}\n"
        
        write("docked1_profile.conf", file_contents)
    elif docked_state.lower() == "undocked":
        file_contents = f"monitor = {find_name_by_model(config[1][0][0].replace('"', ''))}"
        write("undocked1_profile.conf", file_contents)
    else:
        subprocess.run(["notify-send", f"Docked state invalid: {docked_state}"])
        return
    change_docked_state()
    
data = subprocess.run(["hyprctl", "monitors all"], stdout=subprocess.PIPE).stdout.decode("utf-8")#sys.stdin.read()
config = parser_class()
print(isolate_attributes(data))
read_config("/home/squarewinter/.config/hypr/monitor_config/monitors.config")
get_docked_state()
write_to_file()
