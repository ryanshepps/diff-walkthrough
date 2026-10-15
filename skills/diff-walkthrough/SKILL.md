---
name: diff-walkthrough
description: Walk a user through an unstaged or PR diff, one visible Herdr excerpt and decision at a time.
---

# Diff Walkthrough

## Workflow

1. Identify the diff. If the target is unclear, ask which diff to cover.
2. Map changes into a sequence ordered by dependency called "checkpoints".
3. Identify the agent pane in the working directory once from `herdr pane list`. Set `skill_dir` to the directory containing this `SKILL.md`, using the loaded skill path. Claude Code also exposes that directory as `CLAUDE_SKILL_DIR`.
4. For the current checkpoint, show a short, coherent excerpt of the change and pipe the combined result to `"$skill_dir/scripts/review-panes.sh" <agent-pane-id>`.
5. Explain the excerpt, then tell the user they can ask questions about the excerpt, they can choose to continue to the next excerpt or request an edit/change to the code. Only tell the user this on the first checkpoint. They will know they can do this on future checkpoints. Replace the excerpt with code when it would aid your explanation and help the user's understanding.
6. After the final checkpoint, ask whether the user wants a quiz. If yes, ask questions colleagues might raise about implementation choices shown in the diff.

## Review Best Practices

- Group related tests with the checkpoint they cover. Do not show the tests as one large checkpoint at the end.
- Start with data models, working your way up the abstraction layers to guide the user's understanding.

## Excerpt input

The helper only displays stdin. Choose and color the text before piping it in. Pass the current excerpt pane ID as a second argument when replacing it. For a diff, use Git's color output:

```bash
git diff --color=always main...HEAD -- src/llm/index.ts tests/llm/index.test.ts | "$skill_dir/scripts/review-panes.sh" "$agent_pane" "$excerpt_pane"
```

For code, use `bat` to color the excerpt. On Debian or Ubuntu, use `batcat` if the package does not provide a `bat` command. You may select lines from a file or write the snippet yourself. Include enough context to answer the user's question, even when that code is outside the diff.

```bash
{
  printf 'src/llm/index.ts\n'
  sed -n '40,65p' src/llm/index.ts | bat --language=typescript --style=plain --color=always --paging=never
  printf '\ntests/llm/index.test.ts\n'
  sed -n '15,38p' tests/llm/index.test.ts | bat --language=typescript --style=plain --color=always --paging=never
} | "$skill_dir/scripts/review-panes.sh" "$agent_pane" "$excerpt_pane"
```
