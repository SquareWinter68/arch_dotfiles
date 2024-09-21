import time


import time

def timer(seconds: int):
    def seconds_to_timestamp():
        hour = seconds // 3600
        minute = (seconds % 3600) // 60
        second = seconds % 60
        return hour, minute, second

    # Hide the cursor
    print("\033[?25l", end="")
    
    try:
        while seconds:
            hour, minute, second = seconds_to_timestamp()
            # Print the time in bold
            print(f"\033[1m{hour:02}:{minute:02}:{second:02}\033[0m", end="\r")
            seconds -= 1
            time.sleep(1)
    finally:
        # Show the cursor again before exiting
        print("\033[?25h", end="")
        print()  # Move to the next line after the timer ends





def main_loop():
    menu = "Welcome to timer set the desired time in the following format\n nh nm ns, where n is a natural number and {h,m,s} are hour, minute and second respectively\n floats will be parsed as ints, characters converted to ascii and passed as ints\n max values are 23, 59, 59 respectively.\n If exeeded, the timer wil autmatically set the max to quit type q, or quit"
    print(menu)
    while 1:
        x = input()
        if x.lower() in ("q", "quit"):
            break
        else:
            string = x.strip().split()
            string = [_ for _ in string if _ not in ("\n", " ", "\t")]
            if len(string) > 3:
                print("Wrong format\n", menu)
            else:
                timer(int(string[0][:-1])*60**2 + int(string[1][:-1])*60 + int(string[2][:-1]))
            
main_loop()