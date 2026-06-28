# Daily Review 2026-06-28

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Personal Homepage TUI]], [[Job Search]], [[Email Review]], [[magma-blog]]

## 今日关键事项
- [[Personal Homepage TUI]] 基本进入 **v1 稳定可用版**：线上 `/api/chat` 正常，RAG 问题可命中项目资料，IP 白名单/限流头正常，`npm run build` 与 `npm audit --omit=dev` 通过，Git 状态干净。
- 明确了当前 portfolio RAG 的真实形态：资料已发布到 Cloudflare KV，但 KV 中保存的是整份 markdown；运行时按 heading 做 section-level retrieval，不是预先 chunks 化后的向量/结构化索引。
- 对 TUI portfolio 的产品表达做了关键判断：TUI 适合作为 geek / builder 人格入口，但不适合承担全部项目视觉说服力；后续应保留 TUI，同时为 `/projects` 或首页增加更视觉化、更吸引招聘方的项目展示层。
- 求职管线继续自动扫描 SEEK：今日新增岗位扫描两轮，整体没有强匹配；Partly / Phocas 这组里，判断 **Phocas AI Implementation Engineer, Customer** 更值得推进，Partly 不需要重复投入太多。
- 邮件复盘 AM/PM 均执行：AM 关注 Gate.com 登录安全提醒、GitHub Supabase OAuth 授权、Partly/Phocas 岗位机会；PM 重点提醒 Leyi 的 Riccarton Clinic 预约确认，以及 Todoist 产品教育邮件。
- [[magma-blog]] 自动发布链路完成一次闭环：Claude Code 草稿 → worker-general 终稿 → 脚本发布，2026-06-27 正式稿已发布。

## 决策与变更
- Portfolio 当前定位从“继续修 bug”转为“持续内容运营 / RAG 资料维护”：短期主线不是重构，而是持续更新 `Public_Portfolio_Context.md` 与展示内容。
- Portfolio 展示策略建议转为双层结构：
  - TUI 保留为人格入口与记忆点；
  - 项目展示层改用更视觉化的 cards / screenshots / demo flow / case-study 结构，提高对招聘方、PM、BA、非纯工程面试官的说服力。
- RAG 技术路线保持轻量：当前 section-level retrieval 对 v1 足够；真正 chunks 化、向量化、embedding 检索可作为后续增强，而不是当前阻塞项。
- 求职判断继续强调“本地机会 + AI/implementation/product delivery 混合叙事”：Phocas 的 AI Implementation Engineer 比普通 SWE/PM 更贴 Shaun 当前定位。

## 错误与改进
- 今日 review 脚本提示没有找到当天 memory log，说明日内关键上下文主要来自活跃 session，而不是 `memory/2026-06-28.md`。改进：重要系统变更、恢复、决策类内容仍应在当天 memory 或项目日志中做一次轻量落地，避免只散落在频道会话里。
- 前一日 Cloudflare Pages env secret 被 API round-trip 破坏的问题已形成明确教训：不要通过 Pages project API patch 带有 `secret_text` 的 env 配置；后续 secrets 使用 Dashboard 或 `wrangler pages secret put`，普通 env/binding 修改也要避免碰 secret entries。
- Portfolio 当前 RAG 仍是 markdown + runtime section matching，虽然 v1 可用，但长期如果资料量增大，会出现命中不稳定、上下文截断、项目展示不够精细的问题。改进方向是先把资料结构写好，再考虑 chunks/metadata/retrieval 升级。
- 求职自动扫描今天命中较弱，说明 pipeline 本身在运转，但高质量机会仍依赖人工判断与主动补充渠道；边缘岗位不应消耗太多精力。

## 未完成事项（待提醒）
- 确认 Leyi Zhang 在 Riccarton Clinic 的预约是否已进日历：7月14日周二 9:00，Riccarton Clinic - Yaldhurst Road，Dr Claire Buchanan。
- Portfolio 下一步内容运营：继续维护 `/Users/lab/Flash-Claude/FlashNotes/Profile/Public_Portfolio_Context.md`，保持 Cloudflare KV 中 public context 新鲜、准确。
- Portfolio 视觉层改造待排期：设计更华丽的项目展示层，保留 TUI 入口但不要让 TUI 独自承担作品说服力。
- Phocas AI Implementation Engineer 岗位可继续推进：建议进入 position / 标准分析链路，评估 CV 与 cover letter 叙事。
- Cloudflare Pages / KV 的安全与可维护性仍需后续增强：rate limiting/cost controls、security headers/CSP、RAG retrieval 精度、旧文档中的过期 `PUBLIC_AI_*` 引用清理。

## 明日优先级 Top 3
1. 推进 [[Personal Homepage TUI]] 的项目展示层方案：先做最小设计稿/结构草案，明确 TUI 与视觉 projects layer 的分工。
2. 处理家庭/邮件待办：确认 Riccarton Clinic 预约是否进日历，并清掉邮件复盘中等待确认的事项。
3. 复核并推进 Phocas AI Implementation Engineer：按求职 pipeline 入 position、跑 JD 分析，判断是否生成定制 CV / cover letter。
