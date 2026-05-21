# Daily Review 2026-05-21

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]]

## 今日关键事项
- [[Job Search]] 主线继续推进，重点集中在新西兰本地岗位筛选、材料生成、状态同步与 Discord forum 标签维护。
- [[UC Digital Course Developer]] 已完成投递：先评估 SMC 路线可行性，判断为“可尝试但不稳妥”；随后生成 CV / cover letter，发现 CV 首页严重溢出后立即压缩内容并重新导出 PDF，最终用户确认已投递，本地 position / pipeline / analysis queue / Discord forum queue 均已更新为 `submitted`。
- [[EnergyAE]] 已完成投递状态闭环：用户确认已投递后，将 position 状态更新为 `submitted`，记录申请日期与材料；后续发现 Discord forum 标签没有同步，补跑 dry-run 与 live sync，将帖子标签更新为“📤 已投递”。
- 对多个岗位做了状态清理：已过期或结束的岗位更新为 `withdrawn` / 不考虑，并同步 pipeline 与 Discord queue，避免继续提醒或误推进。
- 新岗位扫描继续运行：今日扫描新增大量 SEEK 岗位，并自动推进若干候选进入 positions，包括 [[Ruby Play Network]]、[[Cupla]]、[[Eversor Limited]] 等；说明岗位池扩张正常，但仍需要人工判断优先级。
- 邮件复盘 AM / PM 均完成：今日没有需要马上处理的邮件；识别出若干值得后续沉淀的内容，如 Lenny 求职策略文章、AI / 表达 / vibe coding 相关长文、Lincoln Career Centre 周报等。

## 决策与变更
- 求职材料定位进一步明确：对一份软件工程投递材料，判断核心不是“AI 工具人”，而是“能在产品团队里独立交付、懂需求和系统、用 AI 提效但不依赖 AI 的实用型 Software Engineer”。这应继续作为本地岗位材料的默认叙事骨架。
- 对 UC 岗位的移民相关判断保持谨慎：UC 雇主与 fixed-term 条件可能可用，但岗位是否能被认定为 skilled job 仍需基于 ANZSCO / wage / offer 条款复核；不能把它当作稳妥 SMC 路线。
- 明确并复盘了岗位状态同步链路：`build_job_pipeline.py` 只更新本地 pipeline；Discord forum 标签变更必须再跑 `sync_discord_jobs_forum.py --live`。今天 EnergyAE 的漏同步已补救。
- 邮件复盘继续采用“过滤已处理 + 只推新风险/高价值内容”的方式；今日没有把低优先级资讯误报为紧急待办。

## 错误与改进
- EnergyAE 状态更新最初只同步了本地 pipeline，没有同步 Discord forum 标签。已通过 dry-run 确认范围后补跑 live sync；后续投递确认后的标准动作应包含：本地状态、pipeline rebuild、forum queue rebuild、dry-run、live sync、回报标签状态。
- 在处理 EnergyAE 后续邮件提醒时，dry-run 曾出现 UC Digital Course Developer 也要同步成 submitted 的异常信号。处理方式正确：没有贸然 live，而是先修正邮件状态与材料路径，避免跨岗位误更新。
- UC CV 初版出现首页溢出，说明自动生成材料后不能只检查文件存在，必须做至少一次 PDF 页面视觉/截图检查。今天已通过压缩 objective / skills / bullets、收紧排版后修复。
- 邮件和岗位提醒之间仍存在重复提醒风险，尤其是用户已投递后 SEEK reminder 继续出现。今天已把相关邮件状态标记为“已处理 - 用户确认已投递，后续重复提醒过滤”；后续同类事项应优先查 `email_review_state.json` 与 position 状态。

## 未完成事项（待提醒）
- 对今日自动推进的新岗位做人工优先级排序，尤其是：
  - [[Ruby Play Network]] Software Engineer（74%）
  - [[Cupla]] Full Stack Engineer Contracting Role（70%）
  - [[Eversor Limited]] AI & Data Engineer（65%）
- Halter `seek:92099200` 已知在 pipeline 中，评分 52 / medium / worth_reviewing，判断“值得看但不是低摩擦岗位”；尚未同步进 position 系统、未分析、未投递。
- 邮件中提到的 Lenny 求职策略文章和 AI / 表达相关长文适合后续整理进 [[Knowledge Base]] 或求职打法笔记，但今天未做深度归档。
- 检查 Discord forum 与本地 position 状态是否完全一致，尤其是今天被标记为 `submitted` / `withdrawn` 的岗位。

## 明日优先级 Top 3
1. 先处理今日自动推进的新岗位：按本地经验优先级、申请摩擦、签证/本地经验价值排序，决定哪些进入材料生成。
2. 复核求职 pipeline 与 Discord forum 标签一致性，特别是 EnergyAE、UC Digital Course Developer、已过期/已结束岗位，避免重复提醒或状态漂移。
3. 把高价值邮件内容轻量沉淀到 [[FlashNotes]]：优先 Lenny 求职策略文章，其次 AI / 表达 / vibe coding 长文；采用 fragment 先入 [[Knowledge log]]，不急着重分类。
