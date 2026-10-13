import re
from collections import Counter

vtt_path = r'c:\Users\Suhani\OneDrive\Documents\GitHub\HR-Evaluation-agent\GMT20261013-Tech Interviews_Recording.transcript.vtt'

with open(vtt_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

speaker_first_last = {}

for idx, line in enumerate(lines):
    line_clean = line.strip()
    m = re.match(r'^([^:\n]+):\s*(.*)', line_clean)
    if m:
        speaker = m.group(1).strip()
        text = m.group(2).strip()
        if speaker not in speaker_first_last:
            speaker_first_last[speaker] = {'first': idx, 'last': idx, 'count': 0, 'sample': text}
        speaker_first_last[speaker]['last'] = idx
        speaker_first_last[speaker]['count'] += 1

print(f'Total lines: {len(lines)}')
print('Speakers found (sorted by order of appearance):')
for spk, data in sorted(speaker_first_last.items(), key=lambda x: x[1]['first']):
    print(f'{spk}: count={data["count"]}, first_line={data["first"]}, last_line={data["last"]}')
