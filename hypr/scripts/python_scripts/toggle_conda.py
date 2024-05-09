path = "/home/squarewinter/.bashrc"

with open(path, "r") as file:
    conda_state, commented_state = (0,0)
    #commented_state = 0 
    content = file.readlines()
    for (index,line) in enumerate(content):
        if ">>> conda initialize >>>" in line:
            if content[index + 2][0] == "#":
                commented_state = 1
            conda_state = 1
            continue
        elif "<<< conda initialize <<<" in line:
            conda_state = 0
        elif "!! Contents" in line:
            continue
        if commented_state and conda_state:
            content[index] = line[1:]
        if conda_state and not commented_state:
            content[index] = "#" + line
    with open(path, "w+") as file:
        file.writelines(content)
