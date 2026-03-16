# Claude Learning Mode

Turn Claude Code into a personal programming tutor. Instead of just generating code, Claude teaches you — explains concepts, quizzes you, tracks your progress, and only writes code after you've demonstrated understanding.

Works with **any language**, **any stack**, **any level** — whether you already have a codebase or you're starting from zero.

---

## Table of contents

- [Why this exists](#why-this-exists)
- [What it does](#what-it-does)
- [Two modes](#two-modes)
- [Quick start](#quick-start)
- [What the script asks you](#what-the-script-asks-you)
- [What gets generated](#what-gets-generated)
- [File-by-file breakdown](#file-by-file-breakdown)
- [After setup — Existing project mode](#after-setup--existing-project-mode)
- [After setup — From-scratch mode](#after-setup--from-scratch-mode)
- [How it works under the hood](#how-it-works-under-the-hood)
- [The learning loop](#the-learning-loop)
- [The checkpoint system](#the-checkpoint-system)
- [The CI pipeline](#the-ci-pipeline)
- [Session lifecycle](#session-lifecycle)
- [Weakness detection and spaced revision](#weakness-detection-and-spaced-revision)
- [Time tracking](#time-tracking)
- [Team feedback integration](#team-feedback-integration)
- [Customization tips](#customization-tips)
- [Frequently asked questions](#frequently-asked-questions)
- [Philosophy](#philosophy)
- [License](#license)

---

## Why this exists

Most people use AI coding assistants to generate code faster. That's useful — but it doesn't help you **learn**. You end up with working code you don't understand, and your skills don't grow.

This framework flips the model. Claude Code already has everything a tutor needs: persistent memory, project context, code understanding, and the ability to track state across sessions. All it needs is the right instructions.

**The goal isn't to use AI to code faster. It's to use AI to learn to code better, faster.**

---

## What it does

| Feature | Description |
|---------|-------------|
| **Quiz-before-code** | Claude NEVER writes code until you answer questions correctly |
| **Progress tracking** | Every concept, weakness, and improvement is tracked across sessions |
| **Spaced revision** | Automatic comeback quizzes after breaks, revision before exams |
| **Weakness detection** | Wrong answers are logged and re-tested in future sessions |
| **Team feedback integration** | Code review feedback from colleagues becomes learning material |
| **Session continuity** | Even after `/clear` or a new terminal, Claude knows exactly where you left off |
| **Time tracking** | Estimated vs actual time per topic, to improve planning skills |
| **From-scratch planning** | If you don't have a codebase yet, Claude helps you plan and build your project from zero |

---

## Two modes

The framework detects whether your project directory already contains source code and adapts accordingly.

### Existing project mode

For when you **already have a codebase** (or one is being built by your team). Claude teaches you through the code that's already there. You define learning modules that follow your project's PRs, features, or architecture layers.

**Best for**: students in alternance/apprenticeship, juniors joining an existing team, developers learning a new codebase.

### From-scratch mode

For when you **start with an empty directory** and an idea. Claude helps you plan the project first — define the problem, design the architecture, break it into building steps — then teaches you by guiding you through the construction, one step at a time.

**Best for**: students building a personal project, self-learners with a project idea, anyone who wants to learn by building something real.

---

## Quick start

### Prerequisites

- [Claude Code](https://claude.ai/code) installed and working
- A directory for your project (can be empty)
- Git recommended (not required)

### Installation

```bash
# Clone this repo anywhere on your machine
git clone <this-repo-url>
cd claude-learning-framework
```

### Running the init script

```bash
# Option 1: Run from inside your project directory
cd /path/to/your/project
/path/to/claude-learning-framework/init.sh .

# Option 2: Run from anywhere, specify the target
/path/to/claude-learning-framework/init.sh /path/to/your/project
```

The script is interactive — it will guide you through the setup step by step.

---

## What the script asks you

The init script collects information to personalize the learning experience.

### Always asked

| Question | Example | Purpose |
|----------|---------|---------|
| Student name | `Alice` | Personalization, tracking |
| Programming language | `Go`, `Python`, `TypeScript` | Adapts examples and conventions |
| Project name | `Review Reminder` | Labels all generated files |
| Tech stack | `Go / Gin / PostgreSQL` | Contextualizes teaching |
| Student level | beginner / intermediate / advanced | Adjusts depth and complexity of explanations |
| Schedule type | alternance, full-time, self-study | Adapts revision timing and session planning |
| Daily end time | `18h30` or `flexible` | Hard stop — Claude wraps up before this time |
| Team context | `works with senior devs` or `solo` | Enables/disables feedback integration features |

### Asked only in existing project mode

| Question | Example | Purpose |
|----------|---------|---------|
| Project description | `A Slack bot that reminds reviewers` | Context for Claude's teaching |

### Asked only in from-scratch mode

| Question | Example | Purpose |
|----------|---------|---------|
| Project idea | `A task manager with recurring deadlines` | Starting point for project planning |
| Learning goal | `learn REST APIs`, `practice DDD` | Guides which concepts Claude prioritizes |
| Tech stack (rephrased) | `Go / Gin / PostgreSQL` or `not sure yet` | Can be decided later with Claude's help |

### Asked only for alternance schedule

| Question | Example | Purpose |
|----------|---------|---------|
| School weeks | `March 09-13, March 30-April 03` | Triggers revision sessions before/after breaks |

---

## What gets generated

```
your-project/
├── CLAUDE.md                    # The brain — all pedagogical rules
├── cours/
│   ├── README.md                # Index of all course files
│   ├── 00-programme.md          # Module list
│   ├── plan-projet.md           # Project plan (from-scratch mode only)
│   ├── suivi-progression.md     # Progress tracking with skill axes
│   └── revision-express.md      # All validated questions in one place
└── .claude-learning/
    ├── MEMORY.md                # Session state, learning state
    └── feedback_time_tracking.md  # Time estimation calibration
```

> If a `CLAUDE.md` already exists in your project, the script offers three options: append, create a separate file, or replace (with backup).

---

## File-by-file breakdown

### `CLAUDE.md` — The brain

This is the most important file. Claude reads it at every session start. It contains:

- **Pedagogical role**: Claude's identity as a teacher, the student's profile and level
- **Core teaching principles**: explain the "why", be progressive, adapt the level, detect weaknesses
- **Comprehension gate**: the strict rule that blocks code generation until understanding is proven
- **From-scratch rules** (if applicable): project planning workflow, architecture guidance, just-in-time learning
- **Schedule and revision behavior**: break detection, comeback quizzes, end-of-day routines
- **Team feedback loop**: how to integrate code review corrections as learning material
- **Session startup check**: what Claude must verify at every session start
- **Checkpoint system**: when and how to update tracking files
- **Time tracking rules**: estimation, hard stops, wrap-up behavior
- **CI pipeline**: 5-stage verification checklist for file consistency
- **Learning tracker**: validated concepts, completed lessons, known weaknesses
- **Project sections**: overview, commands, architecture, conventions (customizable)

### `cours/README.md` — Course index

An auto-maintained index table listing all course files, their concepts, dates, and associated PRs/tickets. Claude updates this after every completed module.

### `cours/00-programme.md` — Learning programme

The ordered list of learning modules. In existing project mode, you define these yourself (following your PRs or features). In from-scratch mode, Claude generates them from the project plan.

Each module has:
- A title and PR/ticket reference
- A status (`A faire` → `En cours` → `Valide (date)`)
- A list of concepts to learn

### `cours/plan-projet.md` — Project plan (from-scratch only)

Generated only in from-scratch mode. A structured planning document with three phases:

1. **Cadrage**: problem definition, users, MVP features, secondary features
2. **Architecture**: project structure, data model, technical choices with reasoning
3. **Decoupage**: ordered construction steps that become learning modules

Claude fills this collaboratively with the student during the first sessions.

### `cours/suivi-progression.md` — Progress tracking

Tracks the student's skill level across multiple axes (e.g., "Technical vocabulary", "HTTP conventions", "Architecture patterns"). Each axis has:

- An overall level (beginner → fragile → progressing → solid → mastered)
- A sub-concepts table with individual levels
- An error log (what the student said vs. what was correct)
- An objective (what mastery looks like)
- A historical level table showing progression over time

### `cours/revision-express.md` — Quick revision

All validated quiz questions in one place, organized by course. Designed for self-revision: read the question, answer in your head, check the answer. Questions are numbered sequentially across all sections.

### `.claude-learning/MEMORY.md` — Session memory

Persistent state that survives `/clear` and new sessions. Contains:

- Student profile (name, level, schedule)
- Learning state (modules completed, concepts validated, current position)
- Live session state (date, start time, end time, current module, last question asked)
- Last session summary
- Session rules (reminders for Claude's behavior)
- Project state (tech stack, mode, PRs merged)
- From-scratch state (if applicable): planning phase, plan validated, modules generated

### `.claude-learning/feedback_time_tracking.md` — Time calibration

Historical data of estimated vs actual time per learning bloc. Used to improve future time estimates. Includes rules (hard stop time, minimum time for new modules).

---

## After setup — Existing project mode

### Step 1: Define your learning modules

Edit `cours/00-programme.md` — list the modules you want to learn, following your project's PRs or features:

```markdown
## Module 1 : The Domain Layer
**PR/Ticket** : #2
**Statut** : A faire
- Entities and value objects
- Encapsulation and constructors
- Domain validation rules

## Module 2 : The Repository Layer
**PR/Ticket** : #3
**Statut** : A faire
- Repository pattern
- Interface-based design
- Database connection
```

### Step 2: Define your progress axes

Edit `cours/suivi-progression.md` — list 3-7 skill categories you want to track:

```markdown
## Axe 1 : Technical vocabulary
## Axe 2 : HTTP conventions
## Axe 3 : Architecture patterns
## Axe 4 : Language idioms
## Axe 5 : Testing strategies
```

### Step 3: Customize CLAUDE.md

Fill in the `<!-- CUSTOMIZE -->` sections:

- **Project Overview**: What your project does, in one paragraph
- **Common Commands**: `make test`, `npm run dev`, `go run .`, etc.
- **Architecture**: How your code is organized (folders, layers, patterns)
- **Code Conventions**: Your team's style rules (naming, error handling, etc.)

### Step 4: Link memory files

Copy `.claude-learning/` contents to your Claude Code memory path:

```bash
# The path follows this pattern (dashes replace slashes):
~/.claude/projects/-path-to-your-project/memory/

# Example: if your project is at /home/alice/dev/my-api
cp .claude-learning/* ~/.claude/projects/-home-alice-dev-my-api/memory/
```

### Step 5: Start learning

```bash
claude
```

Claude will automatically:
1. Check git state (new merges, branch changes)
2. Read all tracking files
3. Quiz you on weak points from previous sessions
4. Teach the next module
5. Track everything

---

## After setup — From-scratch mode

### Step 1: Link memory files

Same as existing project mode — copy `.claude-learning/` to your Claude Code memory path.

### Step 2: Start your first session

```bash
claude
```

Claude will guide you through **project planning** before any coding:

1. **Understand your idea** — Claude asks you to explain your project. Challenges vague descriptions. Pushes for clarity: "What problem does this solve? Who uses it?"
2. **Define the MVP** — Together, you identify the minimum viable product. Claude teaches why building everything at once is a mistake.
3. **Design the architecture** — Claude guides you (doesn't dictate). Adapts to your level:
   - **Beginner**: simple flat structure, explains what a "module" is
   - **Intermediate**: layered architecture, explains trade-offs
   - **Advanced**: discusses patterns (DDD, hexagonal), lets you choose
4. **Model the data** — Walk through entities and relationships. Claude explains WHY you model data this way.
5. **Break into modules** — Each construction step becomes a learning module. Claude generates `cours/00-programme.md` from the plan.

### Step 3: Build step by step

Once the plan is validated, Claude teaches you by guiding you through the construction:

- Each session focuses on one construction step
- Concepts are introduced **just-in-time** (only when the project needs them)
- After each module, the project must compile/run — never left broken
- **You write the code**, Claude guides. No copy-paste finished solutions.
- Milestones are celebrated: first compile, first test passing, first endpoint working

### Step 4: Review your plan

After the first planning sessions, review `cours/plan-projet.md`. It contains all decisions made, technical choices with reasoning, and the construction order. This is your project's reference document.

---

## How it works under the hood

The system is built on three mechanisms native to Claude Code:

### 1. CLAUDE.md — The instruction set

Claude reads this file at every session start. It contains all pedagogical rules, the student's profile, progress tracking, and project conventions. This is what transforms Claude from a code generator into a tutor.

### 2. Memory files — Persistent state

Memory files (in `.claude-learning/`) survive `/clear` commands and new terminal sessions. They track:
- Where you stopped (module, concept, last question)
- Your session history (dates, durations, what was covered)
- Time estimation data (for calibrating future estimates)

### 3. Course files — Living documentation

The `cours/` folder contains auto-generated course material. As you learn, Claude creates and updates:
- Course files for each completed module (key concepts, code examples, prerequisites)
- Progress tracking with sub-concept granularity
- A revision question bank that grows with every validated concept

---

## The learning loop

```
Session start
    |
    +-- Git state check (new merges, branch changes?)
    +-- Read ALL tracking files (cours/, memory, CLAUDE.md)
    +-- Verify consistency across all files
    +-- Fix any inconsistencies found
    +-- Comeback quiz (if returning from a break)
    |
    v
Module N
    |
    +-- Explain concept
    +-- Quiz (ONE question at a time)
    |   +-- Correct --> praise, next question
    |   +-- Vague/incomplete --> follow-up questions
    |   +-- Wrong --> re-explain with different analogy, re-quiz
    +-- All questions validated
    +-- Implement code together (student writes, Claude guides)
    |
    +-- [Checkpoint 1] Quick update: suivi-progression + memory
    |
    v
Module complete
    |
    +-- [Checkpoint 2] FULL update: ALL tracking files
    +-- CI Pipeline verification (5 stages)
    +-- Confirm to user: summary + time spent
    |
    v
Next module (or session end)
    |
    +-- Progress report (improvements, struggles, next steps)
    +-- Save session state to memory
    +-- Time tracking summary (estimated vs actual)
```

---

## The checkpoint system

Progress is saved at two levels to guarantee **zero data loss**.

### Checkpoint 1 — After each question

A quick, lightweight update:
- `cours/suivi-progression.md` — update sub-concept levels
- Memory files — update current position

This ensures that even if the session crashes mid-module, your progress is saved.

### Checkpoint 2 — After each completed module

A full update of **every** tracking file. Claude **stops** and does not continue until all files are updated:

| File | What gets updated |
|------|-------------------|
| `CLAUDE.md` | Learning Tracker section (validated concepts, completed lessons, weaknesses) |
| `cours/suivi-progression.md` | Axis levels, sub-concept tables, error logs |
| `cours/revision-express.md` | New validated questions added |
| `cours/README.md` | Course index updated |
| `cours/00-programme.md` | Module status changed to "Valide (date)" |
| Course file | New course file created for the completed module |
| Memory files | Session state, learning state updated |

Checkpoint 2 also catches any updates that checkpoint 1 might have missed — this is the **zero loss guarantee**.

---

## The CI pipeline

At every checkpoint 2 and every session startup, Claude runs a 5-stage verification:

### Stage 1 — Numbering
No gaps, no duplicates in: tracking rules, revision questions, course file index, module numbers, axis numbers.

### Stage 2 — Counts match
Validated concept counts, completed lesson counts, course file counts, and question counts must be consistent across all files.

### Stage 3 — Cross-file consistency
Module statuses match everywhere. Each completed module has a course file + revision questions + progress axis. Weakness levels match between CLAUDE.md and suivi-progression.

### Stage 4 — Completeness
Every axis has a sub-concepts table. Every course file has required sections. No TODO or placeholder text in tracking files.

### Stage 5 — Timestamps
All "last updated" dates are today's date during an active session.

---

## Session lifecycle

### Session start

1. Claude checks git state (new merges, PRs, branch changes since last session)
2. Reads all files in `cours/` and the Learning Tracker in CLAUDE.md
3. Reads memory files (last session state, current module, last question)
4. Verifies consistency — fixes any issues found
5. Initializes session state (date, start time, available time)
6. Reports to user: "Session check done" or lists what was fixed
7. If returning from a break: comeback quiz (concept by concept, rated mastered/needs review/forgotten)

### During session

- Claude teaches one module at a time
- Every question is asked individually (never batched)
- Wrong answers are logged in the error table
- Time is tracked: 30 min before end → check-in, 15 min before end → start wrapping up
- New content is never started in the last 30 minutes

### Session end

1. Save progress: exact position (module, concept, question) written to memory
2. Time tracking summary: estimated vs actual for all modules covered
3. Progress report: concepts covered, improvements, remaining struggles, plan for next session
4. No rushing: Claude doesn't squeeze in one more question

### Resuming

1. Claude recaps: "Last time we covered X, stopped at Y"
2. Quick quiz: 2-3 questions on previously covered material
3. Weak retention → restart with different analogies
4. Solid retention → continue from where you stopped

---

## Weakness detection and spaced revision

### How weaknesses are tracked

When you answer a question incorrectly or vaguely, Claude:
1. Logs the error in `cours/suivi-progression.md` (what you said vs. what was correct)
2. Updates the sub-concept level (e.g., from "progressing" to "fragile")
3. Flags the concept for re-testing in future sessions

### How revision works

- **Every session start**: quiz on the weakest axes (2-3 questions)
- **Before a break/school period**: comprehensive revision of everything covered
- **After returning from a break**: comeback quiz on all concepts, rated per axis
- **QCM format available**: multiple-choice questions when the student is fatigued

### Level scale

| Level | Meaning |
|-------|---------|
| Beginner | Cannot answer or answers wrong systematically |
| Fragile | Knows the concept but makes frequent errors, vague answers |
| Progressing | Understands the concept, some imprecisions remaining |
| Solid | Answers correctly and precisely, can explain to someone else |
| Mastered | Autonomous, applies without help, can debug alone |

---

## Time tracking

### How it works

1. **Session start**: Claude notes current time and available time in memory
2. **Module start**: estimated duration noted
3. **Module end**: actual duration noted
4. **Session end**: estimated vs actual recorded in `feedback_time_tracking.md`
5. **Future sessions**: Claude uses historical data to improve estimates

### Hard constraints

- **End time is a hard stop** — Claude wraps up everything before your configured end time
- **30 min before end** → Claude checks in: "30 min left, continue or wrap up?"
- **15 min before end** → Start wrapping up (summary + file updates). No new content.
- **Less than 45 min remaining** → Never start a new module

### Why it matters

Time estimation is a real-world engineering skill. By tracking estimated vs actual time consistently, you build intuition for sprint planning, ticket estimation, and project scheduling.

---

## Team feedback integration

When you relay feedback from a colleague or code reviewer:

1. **Claude treats it as authoritative** — the reviewer's correction is the reference
2. **Explains WHY** — doesn't just apply the fix, makes it a learning moment
3. **Updates conventions** — if the feedback reveals a new rule, it's documented in CLAUDE.md
4. **Updates courses** — related course files and revision questions are updated
5. **Re-quizzes** — the correction becomes quiz material until mastered
6. **Logs it** — the Team Feedback Log in CLAUDE.md keeps a history of all corrections

---

## Customization tips

### For a beginner

- Start with 3-4 simple progress axes
- Add to CLAUDE.md: "Always use real-world analogies to explain concepts"
- Add to CLAUDE.md: "Never assume prior knowledge — explain everything"
- Use from-scratch mode — building something concrete is the best way to learn
- Keep modules small (30-45 min each)

### For an intermediate

- 5-7 axes covering patterns, architecture, and best practices
- Add to CLAUDE.md: "Focus on the WHY more than the HOW"
- Add to CLAUDE.md: "Challenge the student to find the answer in the code before explaining"
- Link modules to real PRs for maximum context

### For an advanced developer learning a new stack

- Focus axes on the new technology's idioms and patterns
- Add to CLAUDE.md: "Compare with [previous stack] when explaining new concepts"
- Add to CLAUDE.md: "Push for production-grade code, not just working code"
- Use existing project mode — dive straight into the codebase

### For a team

- Each team member runs `init.sh` in the same project
- Share the same `cours/00-programme.md` (same learning path)
- Individual progress tracking (each person has their own `suivi-progression.md`)
- Senior devs give feedback → Claude integrates it as learning material for everyone
- Consider versioning `cours/` in git so the team can see each other's progress

### Customizing CLAUDE.md rules

You can add any rule to CLAUDE.md and Claude will follow it. Some useful additions:

```markdown
<!-- Teaching style -->
- Always give 2 examples: one simple, one from the project
- When the student is stuck for more than 3 questions, switch to QCM format
- Use diagrams (ASCII art) to explain architecture concepts

<!-- Domain-specific -->
- Always relate database concepts to the existing schema
- When teaching HTTP, use curl examples the student can run

<!-- Strictness -->
- Never accept "I think" — push for "I know because..."
- If the student says "it works", ask them to explain WHY it works
```

---

## Frequently asked questions

### Does this work with any programming language?

Yes. The framework is language-agnostic. You specify your language during setup and Claude adapts its teaching, examples, and conventions accordingly.

### Can I use this without git?

Yes, but it's not recommended. Git enables session checks (detecting new merges, PRs, branch changes) and provides better context for Claude. The script will warn you but let you proceed without git.

### What happens if I `/clear` in Claude Code?

Nothing is lost. All progress is saved in memory files and course files on disk. When you start a new session (even after `/clear`), Claude reads everything back and picks up where you left off.

### Can I switch from existing-project mode to from-scratch mode?

The mode is set during `init.sh` and written into CLAUDE.md. You can manually change the `Project mode` field in CLAUDE.md from `existing` to `from-scratch` (or vice versa) and add/remove the relevant sections. But it's easier to re-run `init.sh`.

### Can I use this for multiple projects?

Yes. Run `init.sh` separately in each project directory. Each project gets its own CLAUDE.md, course files, and memory files with independent progress tracking.

### How do I reset my progress?

Re-run `init.sh` in your project directory. It will detect the existing `cours/` folder and ask if you want to overwrite. Say yes to start fresh.

### Can I modify the generated files manually?

Yes. All files are plain Markdown. You can edit anything — add modules, adjust axes, fix mistakes. Claude will read whatever is there at the next session start.

### What if Claude doesn't follow the rules?

Remind it. Say "check CLAUDE.md" or "remember the comprehension gate". The rules are in CLAUDE.md which Claude re-reads at every session. If a rule is consistently ignored, make it more prominent (move it higher, add "STRICT RULE", bold it).

---

## Philosophy

This framework was born from a real apprenticeship. The key insight: **Claude Code is already the perfect tutor infrastructure** — it has persistent memory, project context, and code understanding. All it needs is the right instructions.

The rules in CLAUDE.md are the result of hundreds of iterations:

- **The comprehension gate** prevents "just make it work" syndrome — you can't get code without understanding it first
- **Checkpoint 1 + 2** ensures no learning progress is ever lost, even if the session crashes
- **The CI pipeline** catches inconsistencies before they compound into confusion
- **Time tracking** mirrors real-world sprint estimation — a skill most juniors lack
- **Weakness detection** ensures no concept falls through the cracks
- **From-scratch planning** teaches project thinking, not just coding
- **Team feedback integration** turns code reviews into structured learning moments

The end goal is **full autonomy** — the student should eventually be able to read, understand, analyze, and write code alone, without AI assistance. Every interaction moves toward that goal.

---

## License

MIT — Use it, share it, adapt it.
