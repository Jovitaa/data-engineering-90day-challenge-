from pathlib import Path

BASE_PATH = Path(
    r"C:\Users\jovit\OneDrive\Documents\GitHub\data-engineering-90day-challenge-"
    r"\01.Netflix Recommendation Engine\01.-data"
)

required_folders = [
    "01.traditional_architecture/01.raw",
    "01.traditional_architecture/02.processed",
    "01.traditional_architecture/03.curated",

    "02.medallion_architecture/01.bronze",
    "02.medallion_architecture/02.silver",
    "02.medallion_architecture/03.gold",
]

for folder in required_folders:
    folder_path = BASE_PATH / folder

    if folder_path.exists():
        print(f"FOUND: {folder}")
    else:
        print(f"MISSING: {folder}")