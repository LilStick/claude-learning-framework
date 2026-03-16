# Claude Learning Mode

Turn Claude Code into a personal programming tutor. Instead of just generating code, Claude teaches you — explains concepts, quizzes you, tracks your progress, and only writes code after you've demonstrated understanding.

## What it does

- **Quiz-before-code**: Claude NEVER writes code until you answer questions correctly
- **Progress tracking**: Every concept, weakness, and improvement is tracked across sessions
- **Spaced revision**: Automatic comeback quizzes after breaks, revision before exams
- **Weakness detection**: Wrong answers are logged and re-tested in future sessions
- **Team feedback integration**: Code review feedback becomes learning material
- **Session continuity**: Even after `/clear`, Claude knows exactly where you left off
- **Time tracking**: Estimated vs actual time per topic, to improve planning

## Quick start

```bash
# Clone this repo
git clone <this-repo-url>

# Run the init script in YOUR project directory
cd /path/to/your/project
/path/to/claude-learning-framework/init.sh .

# Or run it from anywhere and specify the target
/path/to/claude-learning-framework/init.sh /path/to/your/project
```

The script will ask you:
- Your name
- Programming language
- Project name and description
- Tech stack
- Your level (beginner / intermediate / advanced)
- Your schedule (alternance, full-time, self-study)
- Daily end time
- Team context

Then it generates all the files in your project.

## What gets generated

```
your-project/
├── CLAUDE.md                  # The brain — all pedagogical rules
├── cours/
│   ├── README.md              # Index of all course files
│   ├── 00-programme.md        # Module list (YOU customize this)
│   ├── suivi-progression.md   # Progress tracking with skill axes
│   └── revision-express.md    # All validated questions in one place
└── .claude-learning/
    ├── MEMORY.md              # Session state, learning state
    └── feedback_time_tracking.md  # Time estimation calibration
```

## After setup

### 1. Define your learning modules

Edit `cours/00-programme.md` — list the modules you want to learn, following your project's PRs or features:

```markdown
## Module 1 : The Domain Layer
**PR** : #2
**Statut** : A faire
- Entities and value objects
- Encapsulation and constructors
- Domain validation rules
```

### 2. Define your progress axes

Edit `cours/suivi-progression.md` — list 3-7 skill categories you want to track:

```markdown
## Axe 1 : Technical vocabulary
## Axe 2 : HTTP conventions
## Axe 3 : Architecture patterns
## Axe 4 : Language idioms
## Axe 5 : Testing strategies
```

### 3. Add project-specific sections to CLAUDE.md

Fill in the `<!-- CUSTOMIZE -->` sections:
- **Project Overview**: What your project does
- **Common Commands**: `make test`, `npm run dev`, etc.
- **Architecture**: How your code is organized
- **Code Conventions**: Your team's style rules

### 4. Link memory files

Copy `.claude-learning/` contents to your Claude Code memory path:
```bash
# Find your project memory path (usually something like):
~/.claude/projects/-path-to-your-project/memory/

# Copy memory files there
cp .claude-learning/* ~/.claude/projects/<your-project-path>/memory/
```

### 5. Start learning!

```bash
claude
```

Claude will automatically:
- Check git state
- Read your progress
- Quiz you on weak points
- Teach the next module
- Track everything

## How it works

The system is built on three mechanisms native to Claude Code:

1. **CLAUDE.md** — Project instructions that Claude reads at every session start. Contains all pedagogical rules, progress tracking, and project conventions.

2. **Memory files** — Persistent state that survives `/clear` and new sessions. Tracks session state, learning progress, and time estimation data.

3. **Course files** (`cours/`) — Auto-generated course material. Each validated module gets a course file with key concepts, code examples, prerequisites, and revision questions.

### The learning loop

```
Session start
    │
    ├── Git state check
    ├── Read all tracking files
    ├── Comeback quiz (if returning from break)
    │
    ▼
Module N
    │
    ├── Explain concept
    ├── Quiz (one question at a time)
    │   ├── Correct → next question
    │   └── Wrong → re-explain, re-quiz
    ├── All questions validated
    ├── Implement code together
    │
    ├── [Checkpoint 1] Quick update: suivi-progression + memory
    │
    ▼
Module complete
    │
    ├── [Checkpoint 2] FULL update: all tracking files
    ├── CI Pipeline verification
    ├── Confirm to user
    │
    ▼
Next module (or session end)
    │
    ├── Progress report
    ├── Save session state
    └── Time tracking summary
```

## Customization tips

### For a beginner
- Start with 3-4 simple axes
- Use lots of analogies in CLAUDE.md rules
- Add: "Always use real-world analogies to explain concepts"
- Add: "Never assume prior knowledge — explain everything"

### For an intermediate
- 5-7 axes covering patterns and architecture
- Add: "Focus on the WHY more than the HOW"
- Add: "Challenge the student to find the answer in the code before explaining"

### For a team
- Each team member clones the framework into their project
- Share the same `cours/00-programme.md` (same learning path)
- Individual progress tracking (each person has their own `suivi-progression.md`)
- Senior devs add feedback → everyone's courses get updated

## Philosophy

This framework was born from a real apprenticeship. The key insight: **Claude Code is already the perfect tutor infrastructure** — it has persistent memory, project context, and code understanding. All it needs is the right instructions.

The rules in CLAUDE.md are the result of hundreds of iterations:
- The comprehension gate prevents "just make it work" syndrome
- Checkpoint 1 + 2 ensures no learning progress is ever lost
- The CI pipeline catches inconsistencies before they compound
- Time tracking mirrors real-world sprint estimation skills
- Weakness detection ensures no concept falls through the cracks

The goal isn't to use AI to code faster. It's to use AI to **learn to code better, faster**.

## License

MIT — Use it, share it, adapt it.
