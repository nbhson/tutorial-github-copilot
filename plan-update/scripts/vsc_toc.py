#!/usr/bin/env python3
"""Tai ban .md cua mot so trang VS Code docs va liet ke heading (H2/H3) kieu slug GitHub.
Dung khi chon anchor cho tung section cua bai hoc.
Danh sach trang: dat trong bien PAGES (bo sung khi can).
Ket qua: /tmp/vsc-toc.txt  (path<TAB>slug<TAB>heading)
"""
import re, subprocess, sys

PAGES = [
    'docs/agents/overview', 'docs/agents/quickstart', 'docs/agents/best-practices',
    'docs/agents/concepts/agent-harnesses', 'docs/agents/concepts/agents', 'docs/agents/concepts/tools',
    'docs/agents/concepts/context', 'docs/agents/concepts/customization', 'docs/agents/concepts/sessions',
    'docs/agents/concepts/language-models',
    'docs/agents/run/agent-harnesses', 'docs/agents/run/chat-view', 'docs/agents/run/approvals',
    'docs/agents/run/agent-sandboxing', 'docs/agents/run/review-code-edits', 'docs/agents/run/memory',
    'docs/agents/run/planning', 'docs/agents/run/subagents', 'docs/agents/run/tools',
    'docs/agents/run/agents-window', 'docs/agents/run/cloud-sandbox-sessions', 'docs/agents/run/automations',
    'docs/agents/run/security', 'docs/agents/run/manage-mcp-servers', 'docs/agents/run/compare-models',
    'docs/agents/run/sessions/manage-sessions', 'docs/agents/run/sessions/session-history',
    'docs/agents/run/sessions/organize-sessions', 'docs/agents/run/move-to-copilot',
    'docs/agents/reference/ai-settings', 'docs/agents/reference/tools-reference',
    'docs/agents/reference/custom-instructions-reference', 'docs/agents/reference/mcp-configuration',
    'docs/agents/reference/hooks-reference', 'docs/agents/reference/agent-plugin-reference',
    'docs/agents/reference/custom-agent-file-reference', 'docs/agents/reference/ai-features-cheat-sheet',
    'docs/agents/reference/workspace-context',
    'docs/agent-customization/overview', 'docs/agent-customization/custom-instructions',
    'docs/agent-customization/custom-agents', 'docs/agent-customization/agent-skills',
    'docs/agent-customization/agent-plugins', 'docs/agent-customization/mcp-servers',
    'docs/agent-customization/copilot-connectors', 'docs/agent-customization/hooks',
    'docs/agent-customization/language-models', 'docs/agent-customization/prompt-files',
    'docs/agent-customization/migrate-customizations',
    'docs/agents/guides/context-engineering-guide', 'docs/agents/guides/customize-copilot-guide',
    'docs/agents/guides/delegate-two-tasks', 'docs/agents/guides/explore-a-codebase',
    'docs/agents/guides/fix-a-bug-with-agents', 'docs/agents/guides/get-agent-back-on-track',
    'docs/agents/guides/monitoring-agents', 'docs/agents/guides/optimize-usage',
    'docs/agents/guides/prompt-examples', 'docs/agents/guides/refactor-safely',
    'docs/agents/guides/test-code-with-ai', 'docs/agents/guides/add-a-feature',
    'docs/agents/agent-troubleshooting/troubleshooting', 'docs/agents/agent-troubleshooting/faq',
    'docs/agents/agent-troubleshooting/chat-debug-view', 'docs/agents/agent-troubleshooting/cache-explorer',
    'docs/setup/copilot', 'docs/chat/chat-overview', 'docs/chat/inline-chat', 'docs/chat/copilot-chat-context',
    'docs/editing/ai-powered-suggestions', 'docs/editing/copilot-smart-actions', 'docs/editing/intellisense',
    'docs/editing/codebasics', 'docs/editing/refactoring',
    'docs/sourcecontrol/branches-worktrees', 'docs/sourcecontrol/github', 'docs/sourcecontrol/staging-commits',
    'docs/sourcecontrol/overview', 'docs/sourcecontrol/troubleshooting',
    'docs/configure/settings', 'docs/configure/keybindings', 'docs/configure/telemetry',
    'docs/configure/extensions/extension-marketplace', 'docs/configure/extensions/extension-runtime-security',
    'docs/configure/accessibility/voice', 'docs/enterprise/extensions', 'docs/enterprise/manage-ai-settings',
    'docs/enterprise/policies', 'docs/enterprise/telemetry', 'docs/enterprise/overview',
    'docs/terminal/getting-started', 'docs/terminal/basics', 'docs/terminal/advanced',
]

def slug(h):
    s = h.strip().lower()
    s = re.sub(r'[^\w\s-]', '', s)
    return re.sub(r'\s+', '-', s)

out = []
for p in PAGES:
    md = subprocess.run(['curl', '-sL', '--max-time', '40', f'https://code.visualstudio.com/{p}.md'],
                        capture_output=True, text=True).stdout
    if not md or md.startswith('<!doctype') or md.startswith('<html'):
        print(f'LOI tai {p}', file=sys.stderr); continue
    for l in md.split('\n'):
        m = re.match(r'^(#{2,3})\s+(.*)$', l)
        if m:
            out.append(f'{p}\t{slug(m.group(2))}\t{m.group(2).strip()}')
    print(f'  ok {p} ({sum(1 for o in out if o.startswith(p + chr(9)))} headings)', file=sys.stderr)
open('/tmp/vsc-toc.txt', 'w').write('\n'.join(out) + '\n')
print(f'{len(out)} headings -> /tmp/vsc-toc.txt')
