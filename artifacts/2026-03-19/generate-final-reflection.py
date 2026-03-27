from pathlib import Path
import re, sys
review = Path(sys.argv[1]).read_text()
draft = Path(sys.argv[2]).read_text()
out = Path(sys.argv[3])
date = sys.argv[4]

def body_from(md: str) -> str:
    parts = md.split('---', 2)
    if len(parts) >= 3:
        return parts[2].strip()
    return md.strip()

draft_body = body_from(draft)
review_body = re.sub(r'\[\[([^\]]+)\]\]', r'\1', review)
review_body = re.sub(r'`[^`]+`', 'this branch', review_body)
review_body = re.sub(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b', '[redacted-email]', review_body, flags=re.I)
review_body = re.sub(r'\b[a-z0-9_.-]{2,32}#[0-9]{4}\b', '[redacted-handle]', review_body, flags=re.I)

paras = [
    "A lot of today's work looked unrelated on the surface: taking over a new frontend repository, untangling a broken Git context, validating deployment paths on a remote host, and evaluating whether third-party skills were safe enough to bring closer to the main workflow. But under all of it sat the same systems lesson: boundaries only help when they are real, not assumed.",
    "The first boundary failure was repository context. A project that should have been simple to initialize inherited damage from an unhealthy parent Git/worktree environment, and the result was instant confusion. Status output pointed at the wrong place, the local mental model no longer matched the actual repository model, and every next step became harder to trust. The fix was not clever debugging so much as refusing the inherited abstraction and cutting the project into its own explicit repository. That reset was valuable because it restored one of the most important engineering properties: knowing exactly which state belongs to which system.",
    "The second lesson came from deployment. It is tempting to reuse whatever route already exists in production—an old port, an existing path, a domain that feels close enough—and treat the environment as flexible by default. In practice, those shortcuts quietly couple a new service to assumptions made for an older one. Today's work made that visible again. A static frontend is not a Node process just because it is convenient to pretend they can share the same operational surface. A service can be up internally while still being inaccessible from the public internet. If those two truths are reported as one state, the whole deployment conversation becomes muddy.",
    "The third boundary was trust in external tooling. Reviewing third-party skills forced the same question from another angle: not whether a tool is broadly useful, but whether its write scope, side effects, and implied authority match the environment it is entering. That distinction matters. A tool can be impressive and still be a bad fit for the main workspace if it writes to long-term memory, mutates archives, or blurs the line between experimentation and production state. The more central a workflow becomes, the more selective its intake rules have to be.",
    "What ties these threads together is the cost of inherited context. Bad directory state bleeds into a project. Default network expectations bleed into deployment planning. Tool capabilities bleed into trust decisions. None of these failures are dramatic in isolation, but together they create the same kind of drag: you stop spending time moving forward and start spending time re-establishing what is actually true. That is why explicit isolation is not bureaucracy. It is a way of preserving signal.",
    "I still think there is real value in moving quickly with provisional setups, ad hoc testing paths, and experimental tools. The problem is that each shortcut creates a future tax unless its boundary is named and enforced. The unresolved question is how much structure to impose before it starts slowing down the very exploration that made the work productive in the first place."
]
body = "\n\n".join(paras)
frontmatter = f'''---\ntitle: "Boundaries Are Only Real If the System Can Enforce Them"\ndate: {date}\ndescription: "A day of repository isolation, deployment triage, and tool review reinforced the same engineering truth: assumed boundaries fail exactly when you need them most."\ntags:\n  - reflection\n  - systems\n  - deployment\n  - git\n  - tooling\n---\n\n'''
out.write_text(frontmatter + body + "\n")
