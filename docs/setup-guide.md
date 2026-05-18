# HR Evaluation Agent — Setup Guide
### Omysha Foundation | Internal Use Only

---

## What This Is

An AI assistant that reads interview transcripts and generates structured scoring reports — Natural Fit, Org Fit, recommendations, and a Word document ready to share. You give it a transcript; it gives you a complete evaluation report.

---

## One-Time Setup (do this once)

### Step 1 — Install Node.js
Go to [nodejs.org](https://nodejs.org) → download the **LTS** version → install it.
*(Skip if already installed.)*

### Step 2 — Install Claude Code
Open Terminal (Mac) or Command Prompt (Windows) and run:
```
npm install -g @anthropic-ai/claude-code
```

### Step 3 — Get an Anthropic API Key
1. Go to [console.anthropic.com](https://console.anthropic.com)
2. Sign in (or create an account with your work email)
3. Go to **API Keys** → click **Create Key** → copy it

### Step 4 — Get the Agent Files
Clone the repository (ask your tech contact for the GitHub link):
```
git clone <repository-link>
cd claude-skills
```
Or ask to be added as a collaborator on GitHub and use **GitHub Desktop** if you prefer a visual tool.

### Step 5 — Start the Agent
Inside the `claude-skills` folder, run:
```
claude
```
Paste your API key when prompted the first time. You are now inside the agent.

---

## Running an Evaluation (every time)

**Step 1** — Open Claude Code in the `claude-skills` folder
```
claude
```

**Step 2** — Paste the transcript into the chat

Paste the full Zoom AI Companion export, VTT file, or meeting notes directly into the chat window.

**Step 3** — Type (or just send the transcript — the agent auto-detects)
```
/evaluate-candidate
```

**Step 4** — Answer any clarifying questions the agent asks
It may ask: role applied for, interview date, which rounds were conducted, confidence level.

**Step 5** — Wait (~2–3 minutes)
The agent reads the transcript, scores all candidates, and generates:
- A markdown summary in the chat window
- A Word document saved to `data/evaluation-reports/batch-[date]-[role].docx`

**Step 6** — Open the `.docx` file and share with Nitin Sir

---

## Getting Updates

When the agent is improved, pull the latest version:
```
git pull
```
No reinstallation needed — the update takes effect immediately.

---

## Common Questions

**"Which role do I select?"**
The agent asks you — just type the role name (HR Intern, Project Intern, etc.).

**"What if a candidate only completed GD?"**
Paste the full transcript. The agent automatically skips NF/OF scoring for candidates who didn't reach those rounds.

**"Where is the Word document saved?"**
Inside the `claude-skills` folder → `data` → `evaluation-reports` → file named `batch-[date]-[role].docx`.

**"Can I evaluate multiple candidates from one session?"**
Yes — paste the full session transcript. The agent handles all candidates in one run.

**"What if the transcript has connectivity gaps?"**
The agent notes it automatically and applies a default score for unprobed sections. You'll see a `limitation_note` in the report.

---

## Important Notes

- The final hire/reject decision is always Nitin Sir's. The report is a scoring input, not a decision.
- Do not share the `data/evaluation-reports/` folder publicly — it contains candidate PII.
- If something looks wrong in a report, use `/justify-rejection` to check rejection criteria, or flag to the agent owner.

---

*For setup help, contact: a4gcollab@gmail.com*
