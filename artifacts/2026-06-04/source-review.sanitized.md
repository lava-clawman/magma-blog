# Daily Review 2026-06-04

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Email Review]], [[Paperclip]], [[Job Search]], [[Family Logistics]]

## 今日关键事项
- [[Email Review]] 完成 AM/PM 两轮复盘：上午识别 13 封新邮件，晚上识别 10 封新邮件，并继续按“安全/家庭/求职/噪音”分层处理。
- 家庭待办里最重要的是 [[Elmwood Normal School]]：Roy 明天 Year 4 online tests，需要今晚把 laptop 充满电，明早带去学校。
- [[Youthline]] WordPress staging 相关邮件已在前一晚完成回复，今天邮件复盘继续把它从未确认项中剔除，避免重复追问。
- [[Paperclip]] cloud adapter wake event 已处理：加载 API key、验证 `/api/agents/me`、领取并处理 LAV-120；复现并修复 Dev 失败源头——managed Codex home 中 stale `auth.json` 被替换为指向真实 Codex auth 的 symlink。
- 求职邮件方面，今天没有新增高优先级机会；Agentic Intelligence 申请截止属于状态更新，Walker Smith AI Specialist 只是相似岗位广告，不直接进入优先队列。
- 技术/产品观察材料包括 [[Augment Cosmos]]、Cloudflare Web Analytics、EPIC AI Conference slides/replay、Synergy 3 安全更新；其中 Synergy 3 v3.6.1 若仍在使用，应作为安全更新处理。

## 决策与变更
- [[Paperclip]]：确认 LAV-120 的故障不是接口猜测问题，而是运行环境里 Codex auth 文件陈旧；修复方式采用备份旧文件 + symlink 到真实认证文件，属于最小变更、可回滚。
- [[Job Search]]：继续执行“本地经验优先”的筛选策略；Jane Street、Lead Dotnet、Whangarei Business Systems Analyst、Prosple graduate 等低匹配机会不进入高优先级。
- [[Email Review]]：延续状态文件去重与日志交叉检查机制；安全提醒和旧事项新进展需要先查历史状态，再决定是否提醒。
- [[Second Brain Operating System]]：daily-review 脚本能够拉取部分活跃 session，但 recent-chats 在处理某类 payload 时崩溃；今日 review 需基于已输出片段、邮件日志与可查记录补齐。

## 错误与改进
- `daily-review.sh` 输出 `NO MEMORY LOGS FOUND FOR TODAY`：今天没有短期 memory 日志文件，说明日内关键事件没有进入 `memory/YYYY-MM-DD.md`。改进：重要修复、求职决策、家庭待办应至少写入当日记忆或对应系统日志。
- `recent-chats.py` 报错：`AttributeError: 'str' object has no attribute 'get'`。原因是 `extract_text(payload)` 假设 content block 一定是 dict，但实际遇到 string。改进：脚本应兼容 `str` content，并在异常 session 上跳过而不是中断整个 24h session 拉取。
- 今日 review 原始输入不完整：active sessions 只成功展示 email-review-pm 与 Paperclip 两段。改进：daily review 脚本需要失败降级策略，例如保留已成功 session、记录失败 session key、继续输出其余数据源。
- 邮件候选脚本对部分 HTML 邮件提取不稳定，如 LU Career Centre 周报只抓到 HTML 外壳。改进：对职业中心/岗位类 newsletter 增加浏览器或 HTML 主体提取 fallback。

## 未完成事项（待提醒）
- 今晚：给 Roy 的 laptop 充满电；明早确认带去 Elmwood。
- 如仍在使用 [[Synergy 3]]：升级到 v3.6.1 安全版本。
- [[Supabase]] `kid-cards` 项目已因 free-tier inactivity 暂停；90 天内可恢复，需要决定是否保留/恢复。
- [[Paperclip]] LAV-120 修复后，后续应观察 Dev adapter 是否稳定通过真实任务，而不只停留在 auth 文件层修复。
- 修复 `/Users/lab/Flash-Claude/projects/second-brain-ops/scripts/recent-chats.py` 的 string payload 兼容问题，避免后续 daily review 缺数据。

## 明日优先级 Top 3
1. 早上先完成 Roy online tests 设备检查：laptop 满电并带去学校。
2. 修复 [[Second Brain Operating System]] daily review 数据抓取链路，重点是 `recent-chats.py` 的 string payload 容错与失败降级。
3. 跟进 [[Paperclip]] LAV-120 修复后的实际运行结果；若 Dev adapter 仍失败，继续从 managed runtime auth/env 层排查。