import os

templates_name = ".README.template.md"
excluded_dirs = ["templates", ".git"]
config_lines = 2

day_template = "[Day {day}](https://adventofcode.com/{year}/day/{day})"
img_template = '<img width="100px" height="100px" src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/{icon}/{icon}-original.svg" />'
badge_template = "[![{year}](https://img.shields.io/badge/⭐%20{stars}-gray?logo=adventofcode&labelColor=black)](https://adventofcode.com/{year})"


def read_config(file):
    config = {}
    for line in [file.readline().split("=") for _ in range(0, config_lines)]:
        config[line[0][3:]] = line[1][:-1]
    template.readline()  # skip separation line
    return config


def read_completion(file):
    days: list[int] = [0] * 25
    while not (line := file.readline()).startswith("// completion=end"):
        if len(splits := line.split(":")) == 2:
            days[int(splits[0])] = int(splits[1][0])
    return days


def write_completion_table(file, days, year):
    file.write("\n## Completion\n\n")
    file.write("| Day   | Part A | Part B |\n")
    file.write("| :---: | :----: | :----: |\n")
    for day, count in enumerate(days):
        day_link = day_template.format(day=day, year=year)
        if count == 1:
            file.write(f"| {day_link} | ⭐ |    |\n")
        if count == 2:
            file.write(f"| {day_link} | ⭐ | ⭐ |\n")
    file.write(f"\n**Total**: {sum(days)}/50 ⭐\n\n")


def write_years_table(file, years):
    sorted_years = sorted(years)

    def year(year, _):
        return f"[{year}](./{year})"

    def separator(*_):
        return ":----:"

    def image_link(_, config):
        return img_template.format(icon=config["icon"])

    def name(_, config):
        return f"**{config['title']}**"

    def stars(year, config):
        return badge_template.format(year=year, stars=sum(config["days"]))

    for mapping in [year, separator, image_link, name, stars]:
        transformed = [mapping(year, years[year]) for year in sorted_years]
        file.write(f"| {' | '.join(transformed)} |\n")


def write_stats(file, years):
    sums = []
    max = (None, 0)
    min = (None, 51)
    for year, data in years.items():
        star_sum = sum(data["days"])
        sums.append(star_sum)
        if star_sum > max[1]:
            max = (year, star_sum)
        if star_sum < min[1]:
            min = (year, star_sum)
    total = sum(sums)
    n = len(sums)
    median = (sums[n // 2] + sums[n // 2 - 1]) // 2 if not n % 2 else sums[n // 2]

    file.write(f"* **Years**: {n}\n")
    file.write(f"* **Total**: {total}/{n * 50} ⭐\n")
    file.write(f"* **Max**: {years[max[0]]['title']} {max[0]} ({max[1]}/50)\n")
    file.write(f"* **Min**: {years[min[0]]['title']} {min[0]} ({min[1]}/50)\n")
    file.write(f"* **Average**: {total//n}/50 ⭐\n")
    file.write(f"* **Median**: {median}/50 ⭐\n")


def generate_year_readme(year, template):
    days = {}
    with open(f"{year}/README.md", "w") as new_readme:
        new_readme.write(f"# Advent of Code {year}\n\n")
        while line := template.readline():
            if line.startswith("// completion=start"):
                days = read_completion(template)
                write_completion_table(new_readme, days, year)
                continue
            new_readme.write(line)
    return days


def generate_root_readme(years):
    with open(f"templates/{templates_name}") as root_template:
        with open("README.md", "w") as root_readme:
            for line in root_template.readlines():
                if line.startswith("// years"):
                    write_years_table(root_readme, years)
                elif line.startswith("// stats"):
                    write_stats(root_readme, years)
                else:
                    root_readme.write(line)


years = {}
for year in [f for f in os.listdir(".") if os.path.isdir(f) and f not in excluded_dirs]:
    with open(f"{year}/{templates_name}") as template:
        years[year] = read_config(template)
        years[year]["days"] = generate_year_readme(year, template)

generate_root_readme(years)
