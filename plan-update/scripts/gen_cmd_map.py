#!/usr/bin/env python3
"""Sinh doclink_map_cmd.json: moi section cua README lenh (commands/<bucket>/<nhom>/<slug>/README.md)
-> trang tai lieu chinh thuc tuong ung voi chinh section do.

SPEC[slug] = (primary_url, primary_label, trouble_url, trouble_label, practice_url, practice_label[, compare_url, compare_label])
Thieu field nao -> dung DEFAULT (van dong voi chu de cua lenh).
Routing theo ten heading: loi/ sai -> trouble; so sanh -> compare; best practices -> practice;
bai tap -> bo qua; con lai (khai niem, cach goi, vi du, tham khao) -> primary.
Chay: python3 plan-update/scripts/gen_cmd_map.py   (ghi file JSON, applier doc sau do)
"""
import json, re, glob, os

V = 'https://code.visualstudio.com/docs/'
G = 'https://docs.github.com/en/copilot/'
DEF_T = (V + 'agents/agent-troubleshooting/troubleshooting', 'Troubleshoot agents in VS Code')
DEF_P = (V + 'agents/best-practices', 'Best Practices')
DEF_C = (G + 'concepts/agent-capabilities/about-agents/about-third-party-coding-agents', 'Third-party coding agents')

SPEC = {
    # ---- cloud / model-agent ----
    'cloud-agent-session': (G + 'how-tos/use-copilot-agents/cloud-agent/start-copilot-sessions', 'Start Copilot sessions',
                            G + 'how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent', 'Troubleshoot cloud agent',
                            G + 'how-tos/use-copilot-agents/cloud-agent/use-cloud-agent-on-github', 'Use cloud agent on GitHub'),
    'coding-agent-assign': (G + 'how-tos/copilot-on-github/use-copilot-agents/kick-off-a-task', 'Kick off a task',
                            G + 'how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent', 'Troubleshoot cloud agent',
                            G + 'how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate', 'Research, plan, iterate'),
    'coding-agent-pr': (G + 'how-tos/copilot-on-github/use-copilot-agents/watch-and-fix-pull-requests', 'Watch and fix pull requests',
                        G + 'how-tos/use-copilot-agents/cloud-agent/troubleshoot-cloud-agent', 'Troubleshoot cloud agent',
                        G + 'how-tos/copilot-on-github/use-copilot-agents/review-copilot-output', 'Review Copilot output'),
    # ---- cloud / system-knowledge ----
    'audit-log': (G + 'reference/enterprise-administrators/agentic-audit-log-events', 'Agentic audit log events',
                  G + 'how-tos/administer-copilot/manage-for-enterprise/review-audit-logs', 'Review audit logs',
                  G + 'how-tos/administer-copilot/manage-for-enterprise/manage-agents/monitor-agentic-activity', 'Monitor agentic activity'),
    'content-exclusion': (G + 'how-tos/configure-content-exclusion/exclude-content-from-copilot', 'Exclude content from Copilot',
                          G + 'how-tos/configure-content-exclusion/review-changes', 'Review exclusion changes',
                          G + 'concepts/security-governance-and-network-settings/content-exclusion', 'Content exclusion (concept)'),
    'knowledge-base': (G + 'concepts/prompting-and-context/repository-indexing', 'Repository indexing',
                       G + 'how-tos/troubleshoot-copilot/troubleshoot-common-issues', 'Troubleshoot common issues',
                       G + 'concepts/prompting-and-context/context-management', 'Context management'),
    # ---- copilot / chat-session ----
    'attachments': (V + 'chat/copilot-chat-context#add-files-as-context', 'Add files as context',
                    V + 'agents/guides/get-agent-back-on-track#reset-conversation-context', 'Reset conversation context',
                    V + 'agents/guides/optimize-usage#exclude-files-from-chat-context', 'Exclude files from chat context'),
    'checkpoints': (V + 'agents/run/review-code-edits#restore-a-checkpoint', 'Restore a checkpoint',
                    V + 'agents/guides/get-agent-back-on-track#recover-unwanted-changes', 'Recover unwanted changes',
                    V + 'agents/run/review-code-edits#choose-your-review-approach', 'Choose your review approach'),
    'clear': (V + 'agents/guides/optimize-usage#start-new-chats-for-new-tasks', 'Start new chats for new tasks',
              V + 'agents/concepts/context#context-window-and-compaction', 'Context window & compaction',
              V + 'agents/best-practices#manage-context-and-sessions', 'Manage context & sessions'),
    'compact': (V + 'agents/run/sessions/manage-sessions#compact-conversation-context', 'Compact conversation context',
                V + 'agents/guides/get-agent-back-on-track#compact-the-current-conversation', 'Compact the conversation',
                V + 'agents/guides/optimize-usage#manage-context-with-compaction', 'Manage context with compaction'),
    'fork': (V + 'agents/run/sessions/manage-sessions#fork-a-chat-session', 'Fork a chat session',
             V + 'agents/guides/get-agent-back-on-track#fork-the-conversation', 'Fork the conversation',
             V + 'agents/guides/optimize-usage#fork-conversations', 'Fork conversations'),
    'history': (V + 'agents/run/sessions/session-history', 'Session History',
                V + 'agents/run/sessions/session-history#reindex-the-session-store', 'Reindex the session store',
                V + 'agents/run/sessions/session-history#what-gets-tracked', 'What gets tracked'),
    'inline-chat': (V + 'chat/inline-chat#use-editor-inline-chat', 'Editor inline chat',
                    V + 'agents/reference/ai-settings#inline-chat-settings', 'Inline chat settings',
                    V + 'chat/inline-chat#inline-chat-in-active-editing-sessions', 'Inline chat in editing sessions'),
    'new-chat': (V + 'agents/run/chat-view#start-a-session', 'Start a session',
                 V + 'agents/run/sessions/manage-sessions#start-a-new-or-related-conversation', 'Start a new or related conversation',
                 V + 'agents/concepts/sessions#choose-a-new-chat-a-fork-or-a-new-session', 'New chat, fork, or new session'),
    'quick-chat': (V + 'chat/inline-chat#use-quick-chat', 'Use Quick Chat',
                   V + 'agents/reference/ai-settings#chat-settings', 'Chat settings',
                   V + 'agents/run/agents-window#start-a-quick-chat', 'Start a quick chat'),
    'resume': (V + 'agents/run/sessions/manage-sessions#find-and-resume-a-session', 'Find and resume a session',
               V + 'agents/run/sessions/manage-sessions#find-a-missing-session', 'Find a missing session',
               V + 'agents/run/sessions/manage-sessions#continue-between-the-chat-view-and-agents-window', 'Continue across views'),
    'shortcuts': (V + 'configure/keybindings#keyboard-shortcuts-editor', 'Keyboard shortcuts',
                  V + 'configure/keybindings#troubleshooting-keyboard-shortcuts', 'Troubleshoot keybindings',
                  V + 'configure/keybindings#customize-shortcuts-for-ui-actions', 'Customize shortcuts'),
    'troubleshoot': (V + 'agents/agent-troubleshooting/troubleshooting', 'Troubleshoot agents in VS Code',
                     V + 'agents/agent-troubleshooting/troubleshooting#report-an-unresolved-issue', 'Report an unresolved issue',
                     V + 'agents/agent-troubleshooting/chat-debug-view', 'Debug Chat Interactions'),
    # ---- copilot / code-actions ----
    'commit-message': (V + 'editing/copilot-smart-actions#generate-a-commit-message-and-pr-information', 'Generate commit message',
                       V + 'sourcecontrol/troubleshooting', 'Git troubleshooting',
                       V + 'sourcecontrol/staging-commits', 'Staging & commits'),
    'debug-terminal': (V + 'editing/copilot-smart-actions#fix-terminal-errors', 'Fix terminal errors',
                       V + 'agents/guides/get-agent-back-on-track#diagnose-repeated-failures', 'Diagnose repeated failures',
                       V + 'chat/inline-chat#use-terminal-inline-chat', 'Terminal inline chat'),
    'doc': (V + 'editing/copilot-smart-actions#generate-documentation', 'Generate documentation',
            V + 'agents/guides/explore-a-codebase#5-record-what-you-verified', 'Record what you verified',
            V + 'agents/guides/prompt-examples#tips-for-crafting-effective-prompts', 'Crafting effective prompts'),
    'explain': (V + 'editing/copilot-smart-actions#explain-code', 'Explain code',
                V + 'agents/guides/explore-a-codebase#4-check-the-explanation-against-tests', 'Check the explanation against tests',
                V + 'agents/guides/explore-a-codebase#1-define-the-question', 'Define the question'),
    'fix': (V + 'editing/copilot-smart-actions#fix-coding-errors', 'Fix coding errors',
            V + 'agents/guides/fix-a-bug-with-agents#add-a-failing-regression-test', 'Add a failing regression test',
            V + 'agents/guides/fix-a-bug-with-agents#implement-and-test-the-fix', 'Implement and test the fix'),
    'new': (V + 'agents/guides/prompt-examples#code-generation-and-editing', 'Code generation & editing',
            V + 'agents/guides/add-a-feature#1-define-the-feature', 'Define the feature',
            V + 'agents/guides/add-a-feature#3-review-a-plan-before-editing', 'Review a plan before editing'),
    'optimize': (V + 'editing/refactoring#refactoring-actions', 'Refactoring actions',
                 V + 'agents/guides/refactor-safely#5-check-callers-and-compatibility', 'Check callers & compatibility',
                 V + 'agents/guides/refactor-safely#3-choose-a-bounded-plan', 'Choose a bounded plan'),
    'plan': (V + 'agents/run/planning#ask-the-current-agent-to-plan', 'Ask the current agent to plan',
             V + 'agents/run/planning#review-and-refine-the-plan', 'Review and refine the plan',
             V + 'agents/best-practices#plan-first-then-implement', 'Plan first, then implement'),
    'pr-desc': (V + 'editing/copilot-smart-actions#generate-a-commit-message-and-pr-information', 'Generate PR information',
                V + 'sourcecontrol/github#creating-pull-requests', 'Creating pull requests',
                V + 'sourcecontrol/github#use-ai-assistance-for-pull-requests', 'AI assistance for PRs'),
    'refactor': (V + 'editing/refactoring#code-actions-quick-fixes-and-refactorings', 'Quick fixes & refactorings',
                 V + 'agents/guides/refactor-safely#2-establish-regression-coverage', 'Establish regression coverage',
                 V + 'agents/guides/refactor-safely#4-refactor-in-reviewable-steps', 'Refactor in reviewable steps'),
    'tests': (V + 'editing/copilot-smart-actions#generate-tests', 'Generate tests',
              V + 'agents/guides/test-code-with-ai#run-tests-and-investigate-failures', 'Run tests & investigate failures',
              V + 'agents/guides/test-code-with-ai#review-assertions-and-coverage', 'Review assertions & coverage'),
    # ---- copilot / model-agent ----
    'agent-mode': (V + 'agents/run/chat-view#work-with-the-agent', 'Work with the agent',
                   V + 'agents/agent-troubleshooting/faq#agents-are-not-available-in-chat', 'Agents not available',
                   V + 'agents/best-practices#plan-first-then-implement', 'Plan first, then implement'),
    'ai-credits': (G + 'reference/copilot-billing/models-and-pricing', 'Models and pricing',
                   V + 'agents/agent-troubleshooting/faq#i-reached-my-inline-suggestions-or-ai-credits-limit', 'Reached the AI credits limit',
                   V + 'agents/guides/optimize-usage#monitor-your-usage', 'Monitor your usage',
                   G + 'concepts/billing-and-usage/individuals/usage-limits', 'Usage limits'),
    'ask-mode': (V + 'chat/chat-overview#send-a-chat-request', 'Send a chat request',
                 V + 'chat/chat-overview#troubleshoot-chat-interactions', 'Troubleshoot chat interactions',
                 V + 'chat/chat-overview#get-better-responses', 'Get better responses'),
    'custom-agent': (V + 'agent-customization/custom-agents#when-to-use-a-custom-agent', 'When to use a custom agent',
                     V + 'agent-customization/custom-agents#troubleshoot-custom-agents', 'Troubleshoot custom agents',
                     V + 'agent-customization/custom-agents#write-effective-agent-instructions', 'Write effective agent instructions',
                     V + 'agents/run/subagents#when-to-use-subagents', 'When to use subagents'),
    'model-picker': (V + 'agent-customization/language-models#customize-the-model-picker', 'Customize the model picker',
                     V + 'agents/agent-troubleshooting/faq#not-all-models-are-available-in-the-language-model-picker', 'Models missing in picker',
                     V + 'agents/concepts/language-models#choose-the-right-model', 'Choose the right model'),
    'policy-approval': (V + 'agents/run/approvals#manage-tool-approvals', 'Manage tool approvals',
                        V + 'agents/run/approvals#reset-tool-confirmations', 'Reset tool confirmations',
                        V + 'agents/run/approvals#prevent-tools-from-being-auto-approved', 'Prevent auto-approval',
                        V + 'agents/run/approvals#claude-permission-modes', 'Claude permission modes'),
    'sandbox-policy': (V + 'agents/run/agent-sandboxing#understand-the-sandbox-boundary', 'Understand the sandbox boundary',
                       V + 'agents/run/agent-sandboxing#troubleshoot-agent-sandboxing', 'Troubleshoot agent sandboxing',
                       V + 'agents/run/agent-sandboxing#inspect-the-effective-sandbox-policy', 'Inspect the effective policy',
                       G + 'concepts/security-governance-and-network-settings/understanding-local-sandboxing', 'Understanding local sandboxing'),
    'session-target': (V + 'agents/run/agent-harnesses', 'Choose an Agent Harness',
                       V + 'agents/agent-troubleshooting/faq#why-cant-i-see-a-copilot-session-i-already-started', 'Session not visible',
                       V + 'agents/best-practices#choose-the-right-agent-harness', 'Choose the right agent harness',
                       V + 'agents/concepts/agent-harnesses', 'Agent Harnesses (concept)'),
    # ---- copilot / system-knowledge ----
    'agent-skill': (V + 'agent-customization/agent-skills#skillmd-file-format', 'SKILL.md file format',
                    V + 'agent-customization/agent-skills#common-issues', 'Skill common issues',
                    V + 'agent-customization/agent-skills#best-practices', 'Skill best practices',
                    V + 'agent-customization/agent-skills#agent-skills-vs-custom-instructions', 'Skills vs custom instructions'),
    'bug-feedback': (V + 'agents/agent-troubleshooting/troubleshooting#report-an-unresolved-issue', 'Report an unresolved issue',
                     V + 'agents/agent-troubleshooting/troubleshooting#collect-network-diagnostics', 'Collect network diagnostics',
                     G + 'how-tos/troubleshoot-copilot/view-logs', 'View Copilot logs'),
    'connector': (V + 'agent-customization/copilot-connectors#connect-a-service', 'Connect a service',
                  V + 'agent-customization/copilot-connectors#troubleshoot-a-connection', 'Troubleshoot a connection',
                  G + 'reference/supported-connectors', 'Supported connectors'),
    'hooks': (V + 'agent-customization/hooks#choose-the-hook-implementation-for-your-session', 'Choose the hook implementation',
              V + 'agent-customization/hooks#troubleshoot-hooks', 'Troubleshoot hooks',
              V + 'agent-customization/hooks#security-considerations', 'Hook security considerations',
              V + 'agent-customization/migrate-customizations#migrate-hooks', 'Migrate hooks'),
    'instructions': (V + 'agent-customization/custom-instructions#create-project-instructions', 'Create project instructions',
                     V + 'agent-customization/custom-instructions#troubleshoot-instructions', 'Troubleshoot instructions',
                     V + 'agent-customization/custom-instructions#write-effective-instructions', 'Write effective instructions',
                     V + 'agents/reference/custom-instructions-reference#supported-formats-and-locations', 'Formats & locations'),
    'login': (V + 'setup/copilot#set-up-github-copilot', 'Set up GitHub Copilot',
              V + 'agents/agent-troubleshooting/faq#my-copilot-subscription-is-not-detected-in-vs-code', 'Subscription not detected',
              V + 'setup/copilot#use-a-different-github-account-with-copilot', 'Use a different GitHub account'),
    'logout': (V + 'setup/copilot#remove-ai-features-from-vs-code', 'Remove AI features from VS Code',
               V + 'agents/agent-troubleshooting/faq#can-i-use-vs-code-without-signing-in', 'VS Code without signing in',
               V + 'setup/copilot#disable-ai-features-for-a-workspace', 'Disable AI features for a workspace'),
    'mcp': (V + 'agents/reference/mcp-configuration', 'MCP configuration reference',
            V + 'agents/run/manage-mcp-servers#troubleshoot-mcp-servers', 'Troubleshoot MCP servers',
            V + 'agents/run/manage-mcp-servers#review-trust-and-isolation', 'Review trust & isolation',
            G + 'concepts/customizations/mcp', 'MCP (GitHub Docs)'),
    'mcp-add': (V + 'agent-customization/mcp-servers#find-and-install-a-server', 'Find and install an MCP server',
                V + 'agent-customization/mcp-servers#if-the-server-does-not-work', 'If the server does not work',
                V + 'agent-customization/mcp-servers#choose-a-configuration-destination', 'Choose a configuration destination'),
    'plugins': (V + 'agent-customization/agent-plugins#what-plugins-provide', 'What plugins provide',
                V + 'agent-customization/agent-plugins#troubleshooting', 'Plugin troubleshooting',
                V + 'agent-customization/agent-plugins#verify-a-plugin-after-installation', 'Verify a plugin after install',
                V + 'agent-customization/agent-plugins#cross-tool-compatibility', 'Cross-tool compatibility'),
    'status': (V + 'setup/copilot', 'GitHub Copilot Setup',
               V + 'agents/agent-troubleshooting/faq#github-copilot-subscription', 'Copilot subscription FAQ',
               V + 'agents/agent-troubleshooting/troubleshooting#start-with-basic-checks', 'Start with basic checks'),
    'telemetry': (V + 'configure/telemetry', 'Telemetry in VS Code',
                  V + 'agents/guides/monitoring-agents#what-gets-collected', 'What gets collected',
                  V + 'agents/guides/monitoring-agents#enable-otel-monitoring', 'Enable OTel monitoring'),
    # ---- local ----
    'export': (V + 'agents/run/sessions/session-history#export-or-copy-a-conversation', 'Export or copy a conversation',
               V + 'agents/agent-troubleshooting/chat-debug-view', 'Debug Chat Interactions',
               V + 'agents/run/sessions/session-history#share-a-session', 'Share a session'),
    'help': (V + 'agents/reference/ai-features-cheat-sheet', 'Cheat Sheet', DEF_T[0], DEF_T[1],
             V + 'agents/guides/prompt-examples#tips-for-crafting-effective-prompts', 'Crafting effective prompts'),
    'edit-mode': (V + 'agents/run/review-code-edits#review-pending-edits-with-the-working-set', 'Review pending edits',
                  V + 'agents/run/review-code-edits#local-harness-specific-behavior', 'Local harness specific behavior',
                  V + 'agents/run/review-code-edits#configure-review-controls', 'Configure review controls'),
    'participants': (V + 'agent-customization/migrate-customizations#replace-chat-participants', 'Replace chat participants',
                     V + 'agent-customization/migrate-customizations#if-you-maintain-a-participant', 'If you maintain a participant',
                     V + 'agents/run/subagents#subagents-by-harness', 'Subagents by harness'),
    'cli-explain': (G + 'how-tos/copilot-cli/use-copilot-cli/overview', 'Use Copilot CLI',
                    G + 'reference/copilot-cli-reference/cli-command-reference', 'CLI command reference',
                    G + 'how-tos/copilot-cli/cli-best-practices', 'Copilot CLI best practices'),
    'cli-suggest': (G + 'how-tos/copilot-in-your-ide/copilot-for-common-tasks/get-ide-code-suggestions', 'Get code suggestions',
                    G + 'how-tos/troubleshoot-copilot/troubleshoot-common-issues', 'Troubleshoot common issues',
                    V + 'editing/ai-powered-suggestions#tips-tricks', 'Suggestions tips & tricks',
                    G + 'how-tos/copilot-cli/use-copilot-cli/overview', 'Use Copilot CLI'),
    'prompt-file': (V + 'agent-customization/prompt-files#create-a-prompt-file', 'Create a prompt file',
                    V + 'agent-customization/prompt-files#troubleshoot-prompt-files', 'Troubleshoot prompt files',
                    V + 'agent-customization/prompt-files#tips-for-writing-effective-prompts', 'Tips for effective prompts',
                    V + 'agent-customization/migrate-customizations#convert-prompt-files-to-skills', 'Convert prompt files to skills'),
    'vscode-mcp-json': (V + 'agents/reference/mcp-configuration#configuration-file', 'MCP configuration file',
                        V + 'agents/reference/mcp-configuration#environment-variable-references', 'Environment variable references',
                        V + 'agents/run/manage-mcp-servers#share-and-reuse-configuration', 'Share and reuse configuration',
                        V + 'agents/reference/mcp-configuration#editor-managed-configuration-for-local-harness-compatibility', 'Local harness compatibility'),
}

# heading -> kieu link (thu tu uu tien: phat trien som -> dung som)
RULES = [(r'^(tham khảo|liên quan|đọc tiếp|học tiếp|tài liệu)', None),
         (r'^bài tập', 'exercise'),
         (r'lỗi thường gặp|tình trạng thường gặp|hay gặp lỗi', 'trouble'),
         (r'nếu làm sai|sai lầm|dễ nhầm', 'trouble_b'),
         (r'so sánh|với claude', 'compare'),
         (r'best practices|mẹo|thủ pháp|\btips?\b', 'practice'),
         (r'khi nào dùng|khi nào nên|khi nào đừng|dùng lúc nào', 'when'),
         (r'điều hướng|phím tắt|shortcut|keybinding', 'nav'),
         (r'ví dụ|\bvd\b|demo', 'example'),
         (r'là gì|nôm na|vì sao|cơ chế|tổng quan', '_concept'),
         (r'cách |sử dụng|thao tác|các bước|copy-paste|lệnh', 'how')]

FAM = {
 ('cloud', 'model-agent'): dict(
    concept=G + 'concepts/agent-capabilities/about-agents/about-github-copilot-agents', concept_label='About GitHub Copilot agents',
    example=G + 'how-tos/copilot-on-github/use-copilot-agents/research-plan-iterate', example_label='Research, plan, iterate',
    when=G + 'concepts/agent-capabilities/choosing-and-delegating-agent-work', when_label='Choosing & delegating agent work',
    nav=G + 'reference/keyboard-shortcuts', nav_label='Copilot keyboard shortcuts',
    trouble_b=G + 'how-tos/troubleshoot-copilot/troubleshoot-common-issues', trouble_b_label='Troubleshoot common issues',
    practice=G + 'get-started/best-practices', practice_label='Copilot best practices'),
 ('cloud', 'system-knowledge'): dict(
    concept=G + 'concepts/customizations', concept_label='Customizations (concept)',
    example=G + 'how-tos/copilot-on-github/customize-copilot/customize-cloud-agent/create-custom-agents', example_label='Create custom agents',
    when=G + 'concepts/customizations/comparing-customizations', when_label='Comparing customizations',
    trouble_b=G + 'how-tos/troubleshoot-copilot/troubleshoot-common-issues', trouble_b_label='Troubleshoot common issues',
    compare=G + 'concepts/customizations/comparing-customizations', compare_label='Comparing customizations',
    practice=G + 'get-started/best-practices', practice_label='Copilot best practices'),
 ('copilot', 'chat-session'): dict(
    concept=V + 'agents/concepts/sessions', concept_label='Sessions (concept)',
    example=V + 'agents/guides/prompt-examples', example_label='Prompt examples',
    when=V + 'agents/best-practices#pick-the-right-tool-for-the-task', when_label='Pick the right tool',
    nav=V + 'agents/reference/ai-features-cheat-sheet#essential-keyboard-shortcuts', nav_label='Chat and agent keyboard shortcuts',
    trouble_b=V + 'agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path', trouble_b_label='Choose a troubleshooting path',
    compare=V + 'agents/concepts/agent-harnesses', compare_label='Agent Harnesses',
    practice=V + 'agents/guides/optimize-usage', practice_label='Optimize AI usage'),
 ('copilot', 'code-actions'): dict(
    concept=V + 'editing/copilot-smart-actions', concept_label='Copilot smart actions',
    example=V + 'agents/guides/prompt-examples#code-generation-and-editing', example_label='Code generation & editing',
    when=V + 'agents/reference/ai-features-cheat-sheet#choose-a-feature', when_label='Choose a feature',
    trouble_b=V + 'agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path', trouble_b_label='Choose a troubleshooting path'),
 ('copilot', 'model-agent'): dict(
    concept=V + 'agents/concepts/agents', concept_label='Agents (concept)',
    example=V + 'agents/guides/prompt-examples#tips-for-crafting-effective-prompts', example_label='Crafting effective prompts',
    when=V + 'agents/best-practices#pick-the-right-tool-for-the-task', when_label='Pick the right tool',
    trouble_b=V + 'agents/agent-troubleshooting/troubleshooting#choose-a-troubleshooting-path', trouble_b_label='Choose a troubleshooting path',
    compare=G + 'concepts/agent-capabilities/choosing-and-delegating-agent-work', compare_label='Choosing & delegating agent work'),
 ('copilot', 'system-knowledge'): dict(
    concept=V + 'agent-customization/overview', concept_label='Customize AI agents (overview)',
    example=V + 'agents/guides/customize-copilot-guide#step-1-create-project-instructions', example_label='Create project instructions',
    when=V + 'agent-customization/overview#choose-a-customization-scope', when_label='Choose a customization scope',
    trouble_b=V + 'agent-customization/overview#troubleshoot-customization-issues', trouble_b_label='Troubleshoot customization issues',
    compare=G + 'concepts/customizations/comparing-customizations', compare_label='Comparing customizations'),
 ('local', 'model-agent'): dict(
    concept=V + 'agents/concepts/agent-harnesses', concept_label='Agent Harnesses (concept)',
    example=V + 'agents/run/chat-view#work-with-the-agent', example_label='Work with the agent',
    when=V + 'agents/best-practices#pick-the-right-tool-for-the-task', when_label='Pick the right tool',
    trouble_b=V + 'agents/agent-troubleshooting/troubleshooting#start-with-basic-checks', trouble_b_label='Start with basic checks',
    practice=V + 'agents/best-practices#choose-the-right-agent-harness', practice_label='Choose the right agent harness'),
 ('local', 'system-knowledge'): dict(
    concept=V + 'agent-customization/overview', concept_label='Customize AI agents (overview)',
    example=V + 'agents/guides/customize-copilot-guide', example_label='Customize Copilot guide',
    when=V + 'agent-customization/overview#choose-a-customization-scope', when_label='Choose a customization scope',
    trouble_b=V + 'agents/agent-troubleshooting/troubleshooting#check-customization-diagnostics', trouble_b_label='Check customization diagnostics',
    compare=V + 'agents/concepts/customization', compare_label='Customization layer (concept)'),
}

def slots(v, fam):
    d = {'primary': (v[0], v[1]),
         'trouble': (v[2], v[3]) if len(v) > 3 and v[2] else DEF_T,
         'practice': (v[4], v[5]) if len(v) > 5 and v[4] else (fam.get('practice') and (fam['practice'], fam['practice_label']) or DEF_P),
         'compare': (v[6], v[7]) if len(v) > 7 and v[6] else (fam.get('compare') and (fam['compare'], fam['compare_label']) or DEF_C)}
    d['example'] = (fam['example'], fam['example_label'])
    d['when'] = (fam['when'], fam['when_label'])
    d['trouble_b'] = (fam['trouble_b'], fam['trouble_b_label'])
    d['exercise'] = d['primary'] if 'primary' in d else DEF_P   # bai tap = dung lenh cua bai
    d['how'] = d['primary']                      # 'cach goi' -> dung trang cua lenh do
    d['nav'] = (fam.get('nav') or V + 'agents/reference/ai-features-cheat-sheet#essential-keyboard-shortcuts',
                fam.get('nav_label') or 'Essential keyboard shortcuts')
    d['_concept'] = (fam['concept'], fam['concept_label'])
    return d

CONCEPT_HEADS = ('1 câu nôm na', 'nôm na là', 'vì sao dùng', 'vì sao phải', 'cơ chế')
rows = []
missing = []
for f in sorted(glob.glob('01-huong-dan-su-dung/commands/*/*/*/README.md')):
    slug = f.split('/')[-2]
    if slug not in SPEC:
        missing.append(f); continue
    parts = f.split('/')
    fam = FAM[(parts[2], parts[3])] if (parts[2], parts[3]) in FAM else FAM[('copilot', 'model-agent')]
    s = slots(SPEC[slug], fam)
    lines = open(f, encoding='utf-8').read().split('\n')
    for i, l in enumerate(lines, 1):
        m = re.match(r'^##\s+(.*)$', l)
        if not m: continue
        title = m.group(1).strip()
        kind = 'primary'
        for pat, k in RULES:
            if re.search(pat, title, re.I):
                kind = k; break
        if kind is None: continue
        low = title.lower()
        if kind == 'primary' and any(c in low for c in CONCEPT_HEADS):
            kind = '_concept'
        url, label = s[kind]
        rows.append([f[:-len('/README.md')], '## ' + title[:48], url, label])
json.dump({'_doc': 'Sinh boi gen_cmd_map.py — moi section cua README lenh -> trang docs tuong ung.',
           'm': rows}, open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'doclink_map_cmd.json'), 'w'),
          ensure_ascii=False, indent=2)
print(f'{len(rows)} entry -> doclink_map_cmd.json')
if missing:
    print('SLUG CHUA CO SPEC:', *missing, sep='\n  ')
