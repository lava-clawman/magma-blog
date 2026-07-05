# Daily Review 2026-07-05

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Email Review]] AM/PM 两轮邮件复盘正常运行：上午无紧急事项；下午发现 Grass Foundation 连续 OTP 验证码，需确认是否本人触发；同时筛出 LinkedIn/CITANZ 活动回顾、Seequent Senior Software Engineer、SEEK Christchurch ICT 批量岗位等值得看但不应过度投入的线索。
- [[Job Search]] 自动岗位扫描运行两轮：上午新增 30 个岗位、下午新增 18 个岗位；两轮均未出现进入 triage 或建议推进的强候选，仅保留少量边缘岗位供快速扫视。
- [[magma-blog]] 自动发布链路完成一次恢复：先出现草稿校验失败，随后草稿生成成功，继续进入 worker-general 终稿编排并完成正式发布。
- [[Matt Pocock Skills]] 安装与多工具联动完成：先做外部仓库安全检查，只安装 promoted skills；随后将同一套 skills symlink 到 `~/.agents/skills`、`~/.claude/skills`、`~/.codex/skills`、`~/.antigravity/skills`。
- 解释并确认 Matt Pocock 推荐流程：`/grill-with-docs` → `/to-prd` → `/to-issues` → 新会话按 issue `/implement`；`grill-with-docs` 没出现在 model-visible 列表中，是因为它被标记为 user-invoked。

## 决策与变更
- 外部 skill 安装采用安全优先策略：不直接运行不明安装脚本，只拉取并筛选 `.claude-plugin/plugin.json` 中 promoted skills；跳过 deprecated / misc / personal / in-progress，降低供应链与不稳定内容风险。
- [[TOOLS.md]] 已记录 Matt Pocock skills 的安装位置、symlink 范围、可见/隐藏 skill 区分，以及默认开发工作流的使用方式。
- [[AGENTS.md]] 的默认开发规则已实际落地：新项目/非平凡工程任务优先走 Spec-Driven Development，并结合 Matt Pocock skills 进行 grill、PRD、issue、实现、review。
- 邮件复盘继续坚持“过滤噪音、只推行动判断”的策略：IFTTT / Railway / WSJ 等低优先级内容不占用注意力；求职机会只给投入建议，不默认展开材料重写。

## 错误与改进
- [[magma-blog]] 草稿阶段曾误判为 Claude Code draft generation failed；实际 Claude 已有输出，但草稿校验未通过。后续应继续区分“模型无输出 / 模型输出不合格 / 编排脚本失败”，避免错误归因。
- Matt Pocock skills 初次安装后未立即覆盖 Codex 与 Antigravity，需要用户补充提醒。后续安装跨工具 skills 时，应主动检查目标运行面：OpenClaw/Claude/Codex/Antigravity 是否都需要链接。
- `grill-with-docs` 这类 user-invoked skill 容易被误认为“没装”或“不可用”。后续说明 skill 可用性时，应区分：model-visible、ready but hidden、user-invoked command 三类。
- 今日没有 memory log；Daily Review 主要依赖最近 24h session。若希望日总结更完整，需要保证关键手动事件也落入 `memory/YYYY-MM-DD.md` 或 FlashNotes log。

## 未完成事项（待提醒）
- 确认 Grass Foundation 连续 OTP 是否本人触发；若不是本人操作，应从官网/可信入口检查账号安全，不要点邮件链接。
- 快速复核 Seequent Senior Software Engineer JD，判断 senior 门槛是否过高；若明显不匹配，不投入定制材料。
- 快速扫 SEEK Christchurch ICT 批量岗位中的本地经验型机会，重点看 IT & Systems Support / IT Support / Systems 相关方向。
- magma-blog 虽然本次已恢复发布，但仍应观察下一轮是否继续出现草稿校验失败；若重复发生，需要修校验标准或 draft 产物格式。
- 对 Matt Pocock skills 做一次真实项目试跑：至少验证 `grill-with-docs`、`to-prd`、`to-issues`、`implement` 在当前工具链中的实际可用性。

## 明日优先级 Top 3
1. 处理 Grass Foundation OTP 风险确认；若非本人触发，优先做账号安全检查。
2. 用最小成本复核今日筛出的本地求职线索，避免在低匹配 senior 岗上过度投入。
3. 选一个小型工程任务试跑 [[Matt Pocock Skills]] 推荐流程，把安装状态转化为可验证的工作流基线。
