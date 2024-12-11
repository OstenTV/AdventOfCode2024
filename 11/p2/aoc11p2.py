def main():
    with open('input.txt', 'r') as file:
        In = file.read().strip()

    result = 0
    stones = list(map(int, In.split()))
    print(f"0 : {' '.join(map(str, stones))}")

    for i in range(1, 76):
        new_stones = []
        for stone in stones:
            stone_str = str(stone)
            if stone_str == "0":
                new_stones.append(1)
            elif len(stone_str) % 2 == 0:
                h = len(stone_str) // 2
                s1 = stone_str[:h]
                s2 = stone_str[h:]
                new_stones.extend([int(s1), int(s2)])
            else:
                new_stones.append(int(stone_str) * 2024)
        
        stones = new_stones
        if i < 10:
            print(f"{i} : {' '.join(map(str, stones))}")
        else:
            print(f"{i} : {len(stones)}")

    result = len(stones)
    with open('out.txt', 'w', encoding='utf-8') as file:
        file.write(str(result))

if __name__ == "__main__":
    main()
