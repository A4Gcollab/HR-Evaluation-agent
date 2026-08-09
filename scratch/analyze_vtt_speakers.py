import re
from collections import Counter

vtt_path = r"c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20260808-PM_Recording.transcript.vtt"

speakers = Counter()
lines_dict = {}

with open(vtt_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Pattern to match: SpeakerName: Text
# VTT file has timestamp lines, index lines, and then speech lines
lines = content.split('\n')
for idx, line in enumerate(lines):
    line = line.strip()
    if not line:
        continue
    # Skip VTT metadata/timestamps
    if line == "WEBVTT" or re.match(r'^\d+$', line) or '-->' in line:
        continue
    
    match = re.match(r'^([^:]+):\s*(.*)', line)
    if match:
        speaker = match.group(1).strip()
        text = match.group(2).strip()
        speakers[speaker] += 1
        if speaker not in lines_dict:
            lines_dict[speaker] = []
        lines_dict[speaker].append((idx + 1, text))

print("Speakers and line counts:")
for sp, cnt in sorted(speakers.items(), key=lambda x: x[1], reverse=True):
    print(f"- {sp}: {cnt} lines")

print("\nSample lines for each speaker (first 2):")
for sp in sorted(speakers.keys()):
    print(f"=== {sp} ===")
    for idx, text in lines_dict[sp][:2]:
        print(f"Line {idx}: {text}")
