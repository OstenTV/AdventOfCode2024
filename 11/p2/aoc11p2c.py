import time
from collections import defaultdict

def measure_command(func):
    """Measures the time taken by the function `func`."""
    start_time = time.time()
    result = func()
    end_time = time.time()
    return result, end_time - start_time

def read_input(file_path):
    """Reads the input file and returns its content as a single string."""
    with open(file_path, 'r', encoding='utf-8') as file:
        return file.read().strip()

def write_output(file_path, data):
    """Writes the given data to the output file."""
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(str(data))

def engrave_stone(stone, i, depth, seen, global_state):
    """Recursively processes a stone according to the logic in the PowerShell script."""
    count = 0
    key = f"{i}-{stone}"
    
    if i >= depth:
        return 1
    i += 1
    
    if key in seen:
        count = seen[key]
        global_state['saved'] += count
    else:
        stone = str(int(stone))
        if stone == "0":
            count += engrave_stone("1", i, depth, seen, global_state)
        elif len(stone) % 2 == 0:
            h = len(stone) // 2
            s1 = stone[:h]
            s2 = stone[h:]
            count += engrave_stone(s1, i, depth, seen, global_state)
            count += engrave_stone(s2, i, depth, seen, global_state)
        else:
            count += engrave_stone(str(int(stone) * 2024), i, depth, seen, global_state)
        seen[key] = count
        global_state['calls'] += 1
    
    return count

def main():
    input_path = './input.txt'
    output_path = './out.txt'
    
    # Read input
    input_data = read_input(input_path)
    stones = [int(s) for s in input_data.split()]
    print(" ".join(map(str, stones)))
    
    result = 0
    depth = 75
    seen = defaultdict(int)
    global_state = {'calls': 0, 'saved': 0}
    
    for i, stone in enumerate(stones):
        print(f"Processing #{i}")
        result += engrave_stone(str(stone), 0, depth, seen, global_state)
    
    write_output(output_path, result)
    
    print(result)
    runtime_minutes = global_state['calls'] / 60
    if global_state['calls'] > 0:
        years_saved = (((global_state['saved'] / global_state['calls']) - global_state['calls']) * (runtime_minutes / 60 / 24 / 365))
        print(f"Saved {years_saved} years")

if __name__ == "__main__":
    result, runtime = measure_command(main)
    print(f"Runtime: {runtime} seconds")
