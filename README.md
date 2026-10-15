# Diff Walkthrough

Walk through a code diff one checkpoint at a time in Herdr. The agent shows the implementation and related tests in one review pane, explains them, and waits for your questions or a request to continue.

## See it in action

![Typing continue opens the next diff, then questions reveal the relevant code](assets/diff-walkthrough-demo.gif)

## Install

Install [Herdr](https://herdr.dev/docs/install/) and make sure `git`, `jq`, `less`, and either `bat` or `batcat` are on your `PATH`. Ubuntu and Debian package `bat` as `batcat`.

Install the skill for your coding agent with one command:

```bash
npx skills add ryanshepps/diff-walkthrough --skill diff-walkthrough --global
```

The [skills CLI](https://github.com/vercel-labs/skills) requires Node.js and detects installed agents, including Claude Code and Codex. Review its agent selection before confirming. The global install makes the skill available across projects. Restart your agent if the new skill does not appear.

Start your agent inside Herdr, then ask it to use `diff-walkthrough` to review an unstaged diff or pull request. The skill's helper opens the excerpt pane through the Herdr CLI, so `HERDR_ENV=1` must be present in the agent pane.

## Review before installing

Read [the skill](skills/diff-walkthrough/SKILL.md) and [its pane helper](skills/diff-walkthrough/scripts/review-panes.sh). The helper reads an excerpt from stdin, opens a Herdr pane, and displays the excerpt with `less`. It does not need account credentials or a background service.
