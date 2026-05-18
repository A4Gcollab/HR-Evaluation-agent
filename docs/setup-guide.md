# HR Evaluation Agent — Setup Guide
### Omysha Foundation | Internal Use Only

---

## What This Does

You paste an interview transcript → the agent reads it → you get a complete Word document with scores, recommendations, and a Hire / Hold / Reject call for every candidate.

---

## One-Time Setup

### Step 1 — Get the files on your computer

1. Install **GitHub Desktop**: [desktop.github.com](https://desktop.github.com) → download → install
2. Open GitHub Desktop → click **Clone a Repository from the Internet**
3. Paste this URL: `https://github.com/A4Gcollab/HR-Evaluation-agent`
4. Choose where to save it on your computer → click **Clone**

You now have the agent files on your computer. You won't need to do this again.

---

### Step 2 — Choose your tool

Pick whichever you already have or prefer:

| | Antigravity IDE | Claude.ai (browser) |
|---|---|---|
| **Setup** | Open the cloned folder | One-time project setup |
| **Best for** | Regular daily use | Quick one-off evaluations |

---

#### Option A — Using Antigravity

1. Open **Antigravity**
2. Click **Open Folder** → select the `HR-Evaluation-agent` folder you cloned
3. Open the chat panel
4. Paste your transcript → send
5. The agent auto-detects and starts the evaluation

#### Option B — Using Claude.ai (browser)

**First time only — create a Project:**
1. Go to [claude.ai](https://claude.ai) → click **Projects** → **New Project**
2. Name it: `HR Evaluation Agent`
3. Click **Add Content** → upload these two files from the cloned folder:
   - `skills/0.evaluate-candidate/SKILL.md`
   - `CLAUDE.md`
4. Save the project

**Every evaluation:**
1. Open the `HR Evaluation Agent` project on Claude.ai
2. Start a new conversation
3. Paste the transcript → send

---

## Running an Evaluation

Whether you use Antigravity or Claude.ai, the steps are the same once the chat is open:

1. **Paste the transcript** — Zoom AI Companion export, VTT file, or meeting notes
2. **Send it** — the agent auto-starts (or type `/evaluate-candidate` if it doesn't)
3. **Answer 1–2 questions** the agent may ask — role name, interview date, rounds completed
4. **Wait ~2–3 minutes** — the agent scores all candidates and produces:
   - A summary in the chat
   - A Word document saved to `data/evaluation-reports/` inside your cloned folder
5. **Open the `.docx`** and share with Nitin Sir

---

## Getting Updates

When the agent is improved:

1. Open **GitHub Desktop**
2. Select the `HR-Evaluation-agent` repository
3. Click **Pull origin** (top bar)

Done — the update takes effect immediately, no reinstallation.

---

## Common Questions

**"Which role do I enter?"**
Just type it when the agent asks — HR Intern, Project Intern, etc.

**"What if a candidate only did GD and not the full interview?"**
Paste the full transcript. The agent automatically skips scoring for rounds that weren't conducted.

**"Where does the Word document get saved?"**
In the cloned folder → `data` → `evaluation-reports` → `batch-[date]-[role].docx`

**"Can I run multiple candidates from one session in one go?"**
Yes — paste the full session transcript. All candidates are handled in one run.

**"The transcript had audio/connectivity issues — will that affect the score?"**
The agent notes it and applies a default score for any section that couldn't be assessed. You'll see a note in the report.

---

## Rules

- Nitin Sir makes the final hire/reject call. This report is a scoring input, not a decision.
- Do not share the `data/evaluation-reports/` folder — it contains candidate data.
- If a score looks off, flag it to a4gcollab@gmail.com.

---

*Setup help: a4gcollab@gmail.com*
