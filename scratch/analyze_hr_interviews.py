import re
import collections

vtt_path = r"c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\HR Interviews.vtt"

with open(vtt_path, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.splitlines()
print(f"Total lines: {len(lines)}")

# Find all speakers and line counts
speaker_counts = collections.Counter()
for idx, line in enumerate(lines):
    match = re.match(r'^([A-Za-z0-9\s\.\(\)\-\[\]\'_]+):', line.strip())
    if match:
        speaker = match.group(1).strip()
        speaker_counts[speaker] += 1

print("\nSpeakers and their line counts:")
for speaker, count in speaker_counts.most_common(40):
    print(f"  {speaker}: {count}")

# Scan for mentions of rounds or transitions
print("\n--- Scanning for round-like references ---")
for idx, line in enumerate(lines):
    if re.search(r'(group discussion|GD|HR round|fit round|natural fit|org fit|organizational fit|individual interview|personal interview)', line, re.IGNORECASE):
        print(f"Line {idx+1}: {line.strip()}")

# Scan for where Sushma introduces individual candidate interviews
print("\n--- Scanning for candidate selection/interview starting points ---")
for idx, line in enumerate(lines):
    if re.match(r'^(Sushma|Suhani):', line.strip()):
        lower_line = line.lower()
        if any(keyword in lower_line for keyword in ["onboard", "welcome", "congratulate", "next candidate", "call the", "please start", "your turn", "individual", "interview"]):
            print(f"Line {idx+1}: {line.strip()}")
