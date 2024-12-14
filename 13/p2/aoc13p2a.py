import re

# Read the input file
with open('input.txt', 'r') as file:
    In = file.read()

Result = 0

# Regular expression to match the required pattern
regex = re.compile(r'Button A: X\+(?P<Ax>\d+), Y\+(?P<Ay>\d+)\s+Button B: X\+(?P<Bx>\d+), Y\+(?P<By>\d+)\s+Prize: X=(?P<Px>\d+), Y=(?P<Py>\d+)')

# Array to hold the parsed data
parsedData = []

# Match the input string against the regex
for match in regex.finditer(In):
    parsedData.append({
        'A': {'X': int(match.group('Ax')), 'Y': int(match.group('Ay'))},
        'B': {'X': int(match.group('Bx')), 'Y': int(match.group('By'))},
        'Prize': {'X': int(match.group('Px')), 'Y': int(match.group('Py'))}
    })

for machine in parsedData:
    px = machine['Prize']['X'] + 10000000000000
    py = machine['Prize']['Y'] + 10000000000000
    ax = machine['A']['X']
    ay = machine['A']['Y']
    bx = machine['B']['X']
    by = machine['B']['Y']

    maxax = (px // ax) + 1
    maxay = (py // ay) + 1
    maxa = min(maxax, maxay)
    
    maxbx = (px // bx) + 1
    maxby = (py // by) + 1
    maxb = min(maxbx, maxby)

    lowestcost = [-1]
    for ai in range(maxa):
        if not ((px - ax * ai) % bx == 0 and (py - ay * ai) % by == 0):
            continue

        bi = (px - ax * ai) // bx

        posx = (ax * ai + bx * bi)
        posy = (ay * ai + by * bi)

        cost = ai * 3 + bi
        if lowestcost[0] != -1 and cost >= lowestcost[0]:
            continue

        if px == posx and py == posy:
            lowestcost = [cost, ai, bi]
            # print(f"New path found for target {px} {py} with A {lowestcost[1]} B {lowestcost[2]} cost {lowestcost[0]}")

    if lowestcost[0] != -1:
        print(f"Lowest cost for target {px} {py} with A {lowestcost[1]} B {lowestcost[2]} cost {lowestcost[0]}")
        Result += lowestcost[0]


print(Result)
# Write the result to the output file
with open('out.txt', 'w', encoding='utf-8') as file:
    file.write(str(Result))
