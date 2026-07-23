import re
import os

transcript_path = r"c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\Social Psychology Intern Interviews's transcript.txt"

with open(transcript_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f"Total lines: {len(lines)}")

# Let's find speakers
speakers = {}
for i, line in enumerate(lines):
    match = re.match(r"^([A-Za-z0-9\s\.\(\)\-\[\]]+):", line)
    if match:
        speaker = match.group(1).strip()
        speakers[speaker] = speakers.get(speaker, 0) + 1

print("\nSpeakers and line counts:")
for sp, count in sorted(speakers.items(), key=lambda x: x[1], reverse=True):
    print(f"  {sp}: {count}")

# Let's find mentions of "room" or "breakout" or candidate transitions
print("\nKey transitions or introductions:")
for i, line in enumerate(lines):
    if "Sushma:" in line or "Suhani:" in line:
        if "welcome" in line.lower() or "join" in line.lower() or "introduce" in line.lower() or "moving forward" in line.lower() or "starting" in line.lower():
            print(f"Line {i+1}: {line.strip()[:120]}")
