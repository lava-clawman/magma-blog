# Daily Review 2026-06-06

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Email Review]] AM 复盘识别出两个需要关注的事项：
  - [[澳洲签证]] / Home Affairs biometrics：对 ZHANG, SHUN 的申请发出采集要求，需要进入 IMMI 或邮件附件确认截止时间与预约要求。
  - [[Loom]] Business + AI trial 将在 6月8日结束；用户已表示 Loom 暂时不需要，后续应避免重复提醒，只需确认未添加付款信息或取消 trial。
- [[Email Review]] PM 复盘没有发现需要马上处理的新邮件：
  - GitHub / EdgeMatrixChain EMC-Dashboard PR #3 关闭通知已判断为旧线程新进展，无需回复。
  - Interactive Brokers 日活动报表、Supabase 通知等归为留档/关注项，不构成即时待办。
- 已为 [[澳洲签证]] biometrics 给出预约方向：使用 VFS Global 的 Australian Biometrics Collection Centre 预约入口，优先考虑 Christchurch ABCC（Breakfree on Cashel, 165 Cashel Street）。
- [[Job Search]] 方向继续推进：用户希望继续看 SEEK 与 LinkedIn 岗位；已筛出 Ember Technology — Junior/Intermediate Software Engineer 作为高优先级本地入口岗位，理由是 Christchurch、本地公司、junior/intermediate、技术栈与 workflow/AI/testing/client-facing 匹配。
- [[OpenClaw]] 运行侧发生一次重复告警排查：`agents.defaults.memorySearch.ollama` 是错误 schema lookup 路径，不是 QMD、Ollama 或 memory_search 本身持续故障。
- 凌晨自动 dream narrative 任务持续运行，记录了 Paperclip 健康巡检、知识库机制、Hermes/OpenCLI 等碎片，但这些更像系统梦境日志，不是当天主要人工任务。

## 决策与变更
- 对重复触发的 `agents.defaults.memorySearch.ollama failed` 告警作出判断：配置和 cron 中均没有该字段，当前没有 running task，最可能是 Gateway/Telegram 工具进度通知的旧失败状态卡住并重复补发。
- 已决定通过 Gateway 重启清理内存态/重复 tool-progress 状态；本次未做配置变更，因此无需 config diff。
- 邮件处理规则继续生效：新邮件进入复盘，已复盘且无需提醒的邮件写入状态记录并过滤，避免重复列为待确认。
- 求职策略保持当前主线：优先本地可落地岗位、本地经验入口；SEEK 和 LinkedIn 均可纳入筛选，但岗位质量优先于数量。

## 错误与改进
- 错误：曾查询不存在的配置路径 `agents.defaults.memorySearch.ollama`，触发 Gateway schema lookup 失败，并可能导致 Telegram 工具进度状态重复补发。
  - 改进：后续查询 OpenClaw 配置前应先用 schema lookup 验证真实字段结构，避免凭字段名直觉访问不存在路径。
  - 改进：遇到重复工具失败通知时，应区分“真实任务持续失败”与“旧 tool-progress 状态卡住”，先查配置、cron、running task、session dispatch，再决定是否重启。
- 错误风险：全局 grep 过重，已被杀掉。
  - 改进：类似排查应优先限定路径、限定文件类型或使用更窄的 ripgrep pattern，避免在大目录上无界搜索。
- 邮件复盘仍有潜在噪音：PM 中大量通知类邮件无需用户动作。
  - 改进：继续强化“无需处理/留档/需要用户确认”的状态区分，尤其对 GitHub、投资账户报表、服务通知类邮件减少重复曝光。

## 未完成事项（待提醒）
- [[澳洲签证]] biometrics：需要确认是否已经完成预约；若未完成，应尽快处理。
- [[Loom]] trial：用户表示暂时不需要，仍需确认是否已取消或确认不会自动扣费；截止点为 6月8日。
- [[Job Search]]：继续筛 SEEK / LinkedIn；Ember Technology 岗位值得优先进入岗位分析/CV/cover letter 流程。
- [[OpenClaw]] 重启后的状态：需要确认重复 `agents.defaults.memorySearch.ollama failed` 告警是否停止；若仍出现，应继续查 Telegram/tool-progress 队列或前端补发机制。
- [[Second Brain Operating System]]：今天没有 memory log；需要确认 daily memory capture 是否正常运行，避免 Daily Review 只依赖 session logs。

## 明日优先级 Top 3
1. 完成或至少确认 [[澳洲签证]] biometrics 预约状态，避免错过 Home Affairs 要求。
2. 推进 [[Job Search]]：优先分析 Ember Technology 岗位，并继续筛 SEEK / LinkedIn 的本地 junior/intermediate 机会。
3. 复核 [[OpenClaw]] 告警与 [[Second Brain Operating System]] 日志链路：确认 Gateway 重启后重复告警消失，同时检查 daily memory log 缺失原因。
