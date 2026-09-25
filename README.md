# onexip-skills

Agent skills for the onexip workflow: idea, research, prototype, spec, tickets,
implementation, review. Works with GitHub Copilot in VS Code and with Claude Code.

## Install

The repo is private, so clone it first (needs `gh auth login` or an SSH key):

```
gh repo clone leonardwecke/onexip-skills
cd onexip-skills
./install.sh claude              # Claude Code, global: symlinks into ~/.claude/skills
./install.sh claude ~/Repos/x    # Claude Code, per project: copies into x/.claude/skills
./install.sh copilot ~/Repos/x   # Copilot, per project: copies into x/.agents/skills
./install.sh                     # asks
```

Update: `git pull`. The global install picks the change up through the
symlinks, for a project install run the same command again and commit the
result.
Existing skill folders that differ from this repo are moved to
`.backup-<timestamp>/`, never deleted.

Then, once per project, in the agent chat:

```
/setup-onexip-skills
```

It asks for the issue tracker, the triage labels and the domain doc layout, and
writes the result to `CLAUDE.md` and `docs/agents/`.

## Where to start

- Unsure which skill fits: `/ask-onexip`
- A loose idea, too big for one session: `/wayfinder`
- Stress-test a plan or decision: `/grilling`
- From a finished conversation to tickets: `/to-spec`, then `/to-tickets`
- One ticket, AFK: `/implement`, review with `/code-review`

## Origin

Fork of [mattpocock/skills](https://github.com/mattpocock/skills), MIT licensed.
The copy was taken from a local install and renamed for onexip; the upstream
head at the time of forking was `74ca5fe` (2026-09-17). Changes against
upstream: the setup skill is `setup-onexip-skills`, `ask-onexip` and
`onexip-frontend` are onexip's own.

To pull in upstream changes, compare a skill folder with the same folder in
mattpocock/skills and take what fits.
