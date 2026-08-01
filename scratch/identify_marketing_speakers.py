import re

vtt_path = r"c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\20260731- Marketing Interviews Recording.transcript.vtt"

speakers = set()
pattern = re.compile(r"^([a-zA-Z\s]+):")

with open(vtt_path, "r", encoding="utf-8") as f:
    for line in f:
        line_clean = line.strip()
        if ":" in line_clean and not line_clean.startswith("http") and not line_clean.startswith("00:"):
            parts = line_clean.split(":", 1)
            speaker = parts[0].strip()
            if len(speaker) > 1 and len(speaker) < 40 and all(c.isalnum() or c.isspace() for c in speaker):
                speakers.add(speaker)

print("Found speakers:")
for s in sorted(speakers):
    print(f"- {s}")
