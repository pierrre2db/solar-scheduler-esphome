---
name: council
description: Convene a council of subagents (esphome, hardware, scheduling, skeptic) that vote and critique each other on a question, diff or design choice for this repo. Use for "council", "avis du conseil", "vote", "review this change".
---
# Council

Input: the user's question, or the current diff (`git diff`) if none given.

1. **Round 1 (parallel)**: spawn `council-esphome`, `council-hardware`, `council-scheduling`, `council-skeptic` in ONE message via the Agent tool. Give each the question/diff and the path `solar_scheduler.yaml`. Independent: no member sees another's answer.
2. **Round 2 (parallel)**: re-spawn each member with the anonymized Round 1 outputs (label A-D, shuffled). Ask: which claim is weakest, which risk is missing, final VOTE.
3. **Verdict** (you, the chair): tally final votes.
   - Majority APPROVE and no high-confidence REJECT -> approve.
   - Any high-confidence REJECT on safety (hardware) -> blocks.
   - Otherwise list required AMENDs.
4. Report in bullets: tally, top risks ranked, dissent, first concrete action. Do not edit files unless the user asks.
