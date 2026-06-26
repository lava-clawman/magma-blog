# Daily Review 2026-06-26

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Spec-Driven Development]], [[Email Review]], [[Paperclip]]

## 今日关键事项
- [[Job Search]] 是今天的主线：
  - Wholesale Solutions / AI Developer Enablement Specialist 完成 CV 与 cover letter 生成；先遇到 Claude Code `401 Invalid authentication credentials`，随后切换到本地生成脚本补产物，产出 HTML/PDF，并根据 Shaun 对排版的反馈优化 CV 页面密度、字号、行距与 section 间距。
  - 该岗位随后已提交，并同步更新为 `submitted`；`positions/index.json`、detail、pipeline 与 analysis queue 已重建且 warnings 为 0。
  - Partly Graduate Software Engineer 也已由 `draft` 更新为 `submitted`，提交日期为 `2026-06-26`，并同步重建 job pipeline / analysis queue；该岗位已从待分析队列移除。
- [[Email Review]] 完成 AM / PM 两轮复盘：
  - AM 重点识别 Moomoo W-8BEN、Interactive Brokers 授权 Anthropic 等金融/安全相关事项。
  - PM 新增 8 封邮件进入本地状态索引，并追加到 `Email_Review_Log.md`，复盘内容已发送到 Discord。
  - 仍需关注 Mercury 电费账单、Moomoo W-8BEN、Anthropic / Claude Code / API 相关状态。
- [[Job Search Pipeline]] 自动扫描与 Discord forum 同步仍有局部失败：
  - 扫描、pipeline、analysis queue、triage、promote、forum queue 均成功。
  - 失败点明确：旧帖 `Farmlands Co-Operative - Graduate Software Developer` 已归档，脚本尝试 PATCH tag 时 Discord 返回 `Thread is archived` / `50083`，导致 `forum_sync_exit=1`。
  - 这不是新岗位扫描失败，也不是新帖未创建；属于旧 thread 状态处理缺陷。
- [[Spec-Driven Development]] 已正式纳入默认开发守则：
  - 安装并验证 GitHub 官方 `spec-kit` / `specify-cli 0.11.8`。
  - 已将“新项目 / 非小型功能默认走 Spec-Driven Development”的规则写入本地工作守则与工具基线。
- 夜间系统巡检/梦境叙事记录显示 [[Paperclip]] 保持健康：
  - `paperclip-poc` tmux、`/api/health`、本地/公网健康检查均持续返回 ok。
  - 备份与运行模式记录稳定，未见当天需要人工介入的异常。

## 决策与变更
- 开发流程层面：以后新软件项目和非平凡功能默认采用 [[Spec-Driven Development]]：constitution → spec → plan → clarify/analyze → tasks → implement → verify。这个决定已写入本地规则，避免后续直接“先写代码再补设计”。
- 求职流程层面：当 Claude Code / 项目 skill 认证失败时，不继续让用户等待坏掉的流程；可切换到本地生成脚本补交付物，但仍需保持项目规范：HTML/PDF、index/detail 更新、pipeline 重建、材料隐私检查。
- 汇报方式层面：用户再次强调“没结果”的反馈说明长任务必须给可验证状态；今天的修正是把失败原因、产物路径、状态更新和 pipeline 重建结果明确分开汇报。
- 邮件复盘层面：延续状态索引机制，复盘前过滤已处理邮件，并把新增处理结果写入本地 JSON 与 `Email_Review_Log.md`，避免重复提醒。

## 错误与改进
- Claude Code 认证失败：
  - 问题：生成 CV/cover letter 的 Claude CLI 流程返回 `401 Invalid authentication credentials`。
  - 改进：短期用本地脚本兜底生成材料；后续需要单独修复 Claude Code/API 认证，避免求职材料生成链路临场失效。
- CV 初版排版偏保守：
  - 问题：为避免溢出而压缩字号/行距，导致页面未撑满且观感过密。
  - 改进：默认生成后应做一次视觉版式检查，尤其是 2 页 CV：页面利用率、留白、字号、行距、section 间距都要纳入质量 gate。
- Discord forum 同步失败仍未根治：
  - 问题：脚本对已归档 thread 的 tag 更新缺少跳过/解归档/错误降级逻辑，导致局部历史帖问题污染整次 sync exit code。
  - 改进：在 `sync_discord_jobs_forum.py` 中对 archived thread 加保护：跳过 tag PATCH、先 unarchive 再更新、或将该类错误降级为 warning，并确保 map 状态一致。
- 今日无本地 memory 日志：
  - 问题：daily-review 脚本提示 `NO MEMORY LOGS FOUND FOR TODAY`，导致复盘主要依赖 session 摘要。
  - 改进：关键任务完成后应同步写入日记忆/任务日志，减少只靠聊天 transcript 的复盘脆弱性。

## 未完成事项（待提醒）
- 修复 Claude Code / Claude CLI `401 Invalid authentication credentials`，恢复求职材料生成的主链路。
- 修复 job forum sync 对 archived Discord thread 的处理，特别是 `Farmlands Co-Operative - Graduate Software Developer` 旧帖。
- 确认 Moomoo W-8BEN 是否已处理；若仍使用 Moomoo US，应优先从官方 App/网站完成认证。
- 核对 Interactive Brokers 授权 Anthropic 的第三方访问是否为本人预期操作；如不确定，应登录 IB 官方后台检查并撤销异常授权。
- 核对 Mercury 最新电费账单金额、到期日与 direct debit 是否正常。
- 将今日关键求职、邮件、安全事项补入合适的 memory / FlashNotes 层，避免明日复盘继续缺少本地 memory logs。

## 明日优先级 Top 3
1. 修复 [[Job Search Pipeline]] 的 archived thread 同步失败，避免后续每次岗位扫描都被 Farmlands 旧帖拖成 `forum_sync_exit=1`。
2. 修复 Claude Code / Claude CLI 认证问题，并给求职材料生成链路加一个轻量 preflight，失败时立即兜底而不是长时间无结果。
3. 处理金融/账单类待确认事项：Moomoo W-8BEN、IB Anthropic 授权、Mercury 电费账单。 
