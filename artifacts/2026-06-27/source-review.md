# Daily Review 2026-06-27

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[TUI Portfolio]] / 个人主页安全排查与修复是今天最重要的系统事件。确认线上 `hi.a-dobe.club` 旧实现把 Gemini key 打进公开 JS bundle，不只是报错暴露；本地完成服务端化修复：前端改为调用同源 `/api/chat`，provider API key 留在 Cloudflare Pages Function 环境变量中。
- [[Public Portfolio Context]] 从 Git 仓库迁移到 [[FlashNotes]] 源文件 `/Users/lab/Flash-Claude/FlashNotes/Profile/Public_Portfolio_Context.md`，并发布到 Cloudflare KV：`PORTFOLIO_CONTEXT` 绑定、`portfolio_context:latest` 内容 key、`portfolio_context:metadata` 元数据 key。线上 smoke test 成功。
- 个人主页公开叙事完成 v1 重写：定位为 product-minded full-stack developer / AI-enabled builder / BA-technical delivery，重点项目包括 [[CareerMatch AI]]、[[NZ Immigration RAG]]、[[Kids Worksheet Generator]]、[[Smart Canvas]]、[[TUI Portfolio]]、Issue Tracker、Youthline LMS+WordPress integration、ML Lending project。
- 完成一轮个人主页安全审计：当前线上 `/api/chat` 可用、bundle 未再暴露 `PUBLIC_AI_*` 或 key pattern；没有发现立即灾难级公开暴露，但存在 P1/P2 安全债。
- [[Job Search]] 方面，上午邮件与 SEEK/CHC ICT 线索触发岗位筛选。初筛认为 Voyager / Halo IT 的 Data and AI Specialist、Sourced 的 BA-AI 方向、Sunstone Java Fullstack AI 旧同名记录最值得复核；21:06 Shaun 要求继续分析 ICT 那组，任务已进入岗位 pipeline 复核。
- 邮件复盘执行两次：上午识别 Mercury 账单、Claude Code mobile、若干一般信息；晚上识别 GitHub / Supabase OAuth 授权需确认、SEEK / Wholesale Solutions 岗位线索等。
- [[magma-blog]] 2026-06-26 自动发布流程完成：Claude Code 草稿 → worker-general 终稿 → 脚本发布。
- 与 Shaun 讨论了 OpenClaw / Hermes 的长项目执行模式：结论是不要依赖无限长 session history 作为真实项目记忆，应以文件系统中的 PRD / specs / tasks / runner ledger / decision log 作为控制面和状态源。

## 决策与变更
- 个人主页 AI chat 的安全边界被重新定义：浏览器不再持有或传递 provider key，也不再上传可伪造的完整 context；服务端负责读取 portfolio context、拼接 prompt、调用 provider。
- Cloudflare KV 被确认为公开 portfolio context 的运行时来源，避免把可迭代的个人介绍/RAG 内容继续放在 Git 仓库中。
- 创建/重建 weekly portfolio context review cron/reminder，目标固定到 Discord channel `1520219956141363215`，不使用 threadId，后续相关提醒应留在该频道。
- 记录 Cloudflare Pages 配置管理重要规则：Pages project API 不会回传 secret env 的真实值，不能把 GET 到的 `secret_text` 当作可 round-trip 的 secret 内容；patch Pages config 时只改非 secret 字段/绑定，secret 应用 wrangler secret 或人工重新录入。
- 求职 pipeline 继续按项目脚本链路处理岗位：position draft / analysis queue / Discord jobs forum queue 作为状态源，不手工绕过。
- 长项目执行架构判断进一步明确：session 是执行器，不是唯一记忆；项目状态必须外化到文件，避免 history 污染和 compaction 失真。

## 错误与改进
- 线上 Gemini key 暴露问题比最初描述更严重：不是“错误信息里泄露”，而是旧 `PUBLIC_AI_API_KEY` 模式导致 key 被构建进公开 bundle。改进：所有 provider secret 必须只存在服务端环境变量中，前端只访问 same-origin API。
- Cloudflare Pages secret patch 出现过临时 `AI chat is not configured` 事故。原因是 API 响应不包含 secret 真值，误把空/占位 secret 合并回配置会清空密钥。改进：将此作为 Cloudflare 操作 gotcha 固化到工具记忆；后续 config patch 前区分 secret 与非 secret。
- 个人主页依赖链存在 P1 风险：旧 Astro / Vite / Rollup 审计项未能通过简单 `npm install --package-lock-only` 自动修复，需主动升级依赖或评估 Astro 大版本迁移。
- RAG/context 当前仍是“取 full KV context 前 8k chars”的简单截断策略，不是真正 retrieval/chunk selection。改进方向：按主题分块、检索相关 chunk、保留短 fallback。
- 线上成本/滥用防护不足：`/api/chat` 需要 durable server-side rate limiting、请求大小限制、基础 abuse 防护与更明确的错误脱敏。
- 安全响应头/CSP 仍可加强；旧 docs/local artifacts 可能还残留 `PUBLIC_AI_*` 旧模式说明，容易误导后续维护。
- Git history 可能仍含旧 public context 或变量引用；当前 bundle 干净不等于历史完全无痕。若旧 key 曾真实可用，应视情况 rotate/revoke。

## 未完成事项（待提醒）
- 继续处理 [[TUI Portfolio]] P1：升级/修复 Astro/Vite/Rollup 依赖漏洞，并跑 build/audit 验证。
- 为 `/api/chat` 增加 durable rate limiting / cost control / request limit，避免公开站点被滥用。
- 将 portfolio context 从简单 8k 截断升级为 chunked retrieval 或至少结构化选择。
- 增强个人主页安全响应头/CSP，并复查 Markdown 渲染是否存在 XSS 风险。
- 清理或更新仓库旧 docs/local artifacts 中的 `PUBLIC_AI_*`、旧 Gemini query key 模式和过期安全说明。
- 复核 GitHub / Supabase OAuth 授权是否为本人操作；若不是，撤销授权并检查 GitHub security log。
- 继续完成 ICT 岗位组分析：重点复核 Voyager Data & AI、Sourced BA-AI、Sunstone Java Fullstack AI 是否应入 position / merge / 跳过，并同步 pipeline 与 Discord jobs forum 队列。
- Mercury 账单金额/到期日仍需确认，若 direct debit 正常可归档。
- [[magma-blog]] 注意：本地 cron 不应重新启用到旧 `06:30`；待 Antigravity clean draft 能力稳定后再按目标 `03:35` 恢复。

## 明日优先级 Top 3
1. 收口 [[TUI Portfolio]] 安全债：依赖漏洞升级、rate limit/cost control、CSP/XSS 复查，先保证公开站点安全边界稳定。
2. 完成 ICT 岗位组分析与求职 pipeline 同步，把值得投的岗位推进到 position/analysis 队列，并避免 Sunstone 这类旧同名岗位重复建档。
3. 复查当天待确认项：GitHub/Supabase OAuth 授权、Mercury 账单、旧 docs/Git history 中可能残留的 key/context 痕迹。
