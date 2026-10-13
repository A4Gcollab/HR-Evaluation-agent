import re

with open("gmt20260817-093726_recording.transcript.txt", "r", encoding="utf-8") as f:
    text = f.read()

# find all occurrences of "Name: " at the beginning of a line
speakers = set(re.findall(r"^([A-Za-z0-9\s\'\-]+):", text, re.MULTILINE))
print(sorted(list(speakers)))
