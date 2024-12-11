def engrave_stone(stone, depth, current_depth=0):
    count = 0
    stone = str(int(stone))  # Ensure stone is a string representation of an integer
    if current_depth >= depth:
        return 1
    current_depth += 1
    if stone == "0":
        count += engrave_stone("1", depth, current_depth)
    elif len(stone) % 2 == 0:
        h = len(stone) // 2
        s1, s2 = stone[:h], stone[h:]
        count += engrave_stone(s1, depth, current_depth)
        count += engrave_stone(s2, depth, current_depth)
    else:
        count += engrave_stone(str(int(stone) * 2024), depth, current_depth)
    return count

def main():
    with open('sample.txt', 'r') as file:
        In = file.read().strip()

    result = 0
    depth = 75
    stones = list(map(int, In.split()))
    print(" ".join(map(str, stones)))

    for i, stone in enumerate(stones):
        print(f"Processing #{i}")
        result += engrave_stone(stone, depth)

    with open('out.txt', 'w', encoding='utf-8') as file:
        file.write(str(result))

if __name__ == "__main__":
    main()
