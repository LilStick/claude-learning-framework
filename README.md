# Claude Learning Mode

> Turn Claude Code into your personal programming tutor.

Claude explains, quizzes, tracks your progress — and only writes code **after** you've proven you understand it. Works with any language, any stack, any level.

**Got a codebase?** Claude teaches you through it.
**Starting from zero?** Claude helps you plan, design, and build step by step.

```
    You                          Claude
     |                             |
     |   "I want to learn X"       |
     |  ========================>  |
     |                             |  Explains the concept
     |                             |  Asks you a question
     |   <======================== |
     |                             |
     |   "I think it's because..." |
     |  ========================>  |
     |                             |  Evaluates your answer
     |                             |  Correct? Next question.
     |                             |  Wrong? Re-explains differently.
     |   <======================== |
     |                             |
     |   All questions validated   |
     |                             |  NOW writes code with you
     |   <======================== |
```

---

## Quick start

```bash
git clone <this-repo-url>

# Run in your project directory (can be empty)
/path/to/claude-learning-framework/init.sh /path/to/your/project
```

The script guides you interactively. Memory files are **auto-linked** to Claude Code — no manual copy needed.

Then just run `claude` and start learning.

---

## Two modes

<table>
<tr>
<td width="50%">

### Existing project

You already have code (or your team is building it).

Claude teaches through what's already there — you define modules that follow your PRs or features.

**Best for:** alternance students, juniors joining a team, devs learning a new codebase

</td>
<td width="50%">

### From scratch

You start with an empty directory and an idea.

Claude helps you plan first (MVP, architecture, data model) then guides you through building it.

**Best for:** personal projects, self-learners, students building something from zero

</td>
</tr>
</table>

---

## What the script asks

| Question | Example |
|----------|---------|
| Interaction language | `Francais`, `English`, `Espanol`, `Deutsch`, ... |
| Student name | `Alice` |
| Programming language | `Go`, `Python`, `TypeScript` |
| Project name | `Review Reminder` |
| Tech stack | `Go / Gin / PostgreSQL` or `not sure yet` |
| Level | beginner / intermediate / advanced |
| Schedule | alternance, full-time, self-study |
| Daily end time | `18h30` or `flexible` |
| Team context | `works with senior devs` or `solo` |

**From-scratch only:** your project idea + learning goal. If you don't have an idea, choose option 2 and Claude will help you find one.
**Alternance only:** your school weeks (for revision timing).

---

## Generated files

```
your-project/
|
|-- CLAUDE.md                     The brain (pedagogical rules only)
|
|-- cours/
|   |-- README.md                 Index of all courses
|   |-- 00-programme.md           Module list
|   |-- plan-projet.md            Project plan (from-scratch only)
|   |-- suivi-progression.md      Skill tracking by axis
|   |-- revision-express.md       All quiz questions in one place
|   |-- ci-pipeline.md            Verification checklist (5 stages)
|
|-- .claude-learning/             Local backup of memory files
    |-- MEMORY.md                 Session state, learning state
    |-- feedback_time_tracking.md Time estimation data
```

> Memory files are automatically copied to `~/.claude/projects/` so Claude Code picks them up instantly.

---

## Key features

### The comprehension gate

Claude **never** writes code until you answer questions correctly. No exceptions.

```
Explain concept --> Quiz (1 question at a time) --> All correct --> Write code
                          |
                          +--> Wrong? Re-explain with new analogy, re-quiz
```

Even if you ask "just implement it", Claude reminds you of the learning contract.

### Progress tracking

Every skill is tracked across **axes** (e.g. "HTTP conventions", "Architecture patterns"). Each axis breaks down into sub-concepts with individual levels:

| Level | Meaning |
|-------|---------|
| Beginner | Can't answer or answers wrong |
| Fragile | Knows the concept, frequent errors |
| Progressing | Understands, some imprecisions |
| Solid | Answers precisely, can explain to others |
| Mastered | Autonomous, applies without help |

Wrong answers are logged (what you said vs. what was correct) and re-tested in future sessions.

### Checkpoints (zero data loss)

| When | What happens |
|------|-------------|
| After each question | Quick update: progression + memory |
| After each module | Full update: ALL files. Claude stops and confirms before continuing. |

### CI pipeline (5 stages)

Lives in `cours/ci-pipeline.md`. Runs at every module completion and session start:

1. **Numbering** — no gaps or duplicates anywhere
2. **Counts** — numbers match across all files
3. **Consistency** — module statuses, weakness levels match everywhere
4. **Completeness** — no missing tables, no TODOs in tracking files
5. **Timestamps** — all "last updated" dates are current

### Session management

**Start:** git check, read all files, verify consistency, comeback quiz if returning from break.

**During:** one module at a time, one question at a time, time tracked. 30 min before end: check-in. 15 min before end: wrap up.

**End:** exact position saved, time summary, progress report, next session plan.

**Resume:** recap, quick quiz on previous material, adapt based on retention.

### Time tracking

Estimated vs actual time per module. Builds real-world estimation skills. End time is a hard stop — Claude wraps up before it.

### Team feedback

When you relay a code review correction, Claude:
- Treats it as authoritative (no ego)
- Explains **why** the reviewer is right
- Updates courses, conventions, and quiz material
- Re-tests until the concept is mastered

---

## From-scratch mode in detail

When you choose "from scratch", the first sessions are **planning only** — no code.

**Don't have an idea?** Choose option 2 during setup. Claude will ask about your interests, then propose 3-4 project ideas adapted to your level and language. You pick the one that excites you.

```
Session 0 (if no idea): Project discovery
  |
  |-- Claude asks about your interests
  |-- Proposes 3-4 project ideas
  |-- You choose one
  |
  v
Session 1-2: Planning
  |
  |-- Define the problem clearly
  |-- Identify users and their needs
  |-- List MVP features (3-5 max)
  |-- Design architecture (adapted to your level)
  |-- Model the data
  |-- Break into construction steps
  |
  v
Sessions 3+: Building
  |
  |-- Each step = 1 learning module
  |-- Concepts introduced just-in-time
  |-- You write the code, Claude guides
  |-- Project must run after every module
  |-- Milestones celebrated
```

Architecture is adapted to your level:

| Level | Approach |
|-------|----------|
| Beginner | Simple flat structure, one file per concern |
| Intermediate | Layered architecture, trade-offs explained |
| Advanced | DDD, hexagonal, etc. — you choose, Claude challenges |

The plan lives in `cours/plan-projet.md` and serves as reference for the whole journey.

---

## After setup

<table>
<tr>
<td width="50%">

### Existing project

1. Edit `cours/00-programme.md` — define your modules
2. Edit `cours/suivi-progression.md` — define your skill axes
3. Customize `CLAUDE.md` — project sections
4. Run `claude` and start learning

</td>
<td width="50%">

### From scratch

1. Run `claude`
2. Plan your project with Claude (first sessions)
3. Claude auto-generates your modules from the plan
4. Build step by step

</td>
</tr>
</table>

---

## Customization

You can add any rule to `CLAUDE.md`. Some ideas:

**For beginners:**
```
- Always use real-world analogies to explain concepts
- Never assume prior knowledge
- Keep modules to 30-45 min
```

**For intermediate:**
```
- Focus on the WHY more than the HOW
- Challenge the student to find the answer in code before explaining
```

**For advanced:**
```
- Compare with [previous stack] when explaining
- Push for production-grade code, not just "it works"
```

**For teams:**
- Share `cours/00-programme.md` (same learning path)
- Individual `suivi-progression.md` per person
- Senior feedback becomes learning material for everyone

---

## FAQ

**Any programming language?**
Yes. Specify yours during setup, Claude adapts everything.

**Without git?**
Works, but not recommended. Git enables session checks and PR tracking.

**What if I `/clear`?**
Nothing lost. Progress lives in files on disk. Claude reads them back at next session.

**Switch modes?**
Change `Project mode` in CLAUDE.md, or re-run `init.sh`.

**Multiple projects?**
Run `init.sh` per project. Each has independent tracking.

**Reset progress?**
Re-run `init.sh`, say yes to overwrite.

**Claude ignores a rule?**
Say "check CLAUDE.md" or "remember the comprehension gate". If persistent, move the rule higher or bold it.

---

## Philosophy

This framework was born from a real apprenticeship.

Claude Code already has everything a tutor needs — persistent memory, project context, code understanding. All it needs is the right instructions.

The key mechanisms:

- **Comprehension gate** — no code without understanding
- **Checkpoints** — no progress ever lost
- **CI pipeline** — no inconsistencies slip through
- **Time tracking** — builds real estimation skills
- **Weakness detection** — no concept falls through the cracks
- **From-scratch planning** — teaches project thinking, not just coding

**The goal isn't to use AI to code faster. It's to use AI to learn to code better, faster.**

---

## License

MIT — Use it, share it, adapt it.
