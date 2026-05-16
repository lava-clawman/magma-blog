# Daily Review 2026-05-16

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[Agent Skills]]

## 今日关键事项
- [[Email Review]] 工作流暴露重复处理问题：用户指出此前已要求邮件复盘前读取本地状态记录，避免同一邮件反复追问。经核对，约束存在，问题在于执行时漏做前置检查。
- 已将邮件复盘从 main agent 的零散规则中抽离，创建专门的 `mail-review` skill：路径为 `/Users/lab/.openclaw/workspace/skills/mail-review/SKILL.md`，并生成打包文件 `/Users/lab/.openclaw/workspace/skills/dist/mail-review.skill`。
- 邮件复盘自动任务正常运行：上午与晚上各完成一次候选邮件处理，并更新 `data/email_review_state.json` 与 `FlashNotes/Email_Review_Log.md`。晚上重点提醒 GitHub / EdgeMatrixChain EMC-Dashboard PR #3 与 bounty 相关决策。
- [[Job Search]] 今天集中推进 SEEK 岗位处理：
  - Joyn / Lighting Innovation Factory Full Stack / Graduate Developer 已入库、分析，并用 Claude 生成 CV 与 cover letter。
  - Ngāi Tahu Application and Automation Specialist、Ryman Healthcare AI Solution Engineer 已入库并发帖。
  - 日常岗位扫描新增岗位较多：09:06 扫描新增 237 个岗位，自动推进 Randstad Business Data Analyst 与 PHF Science Business Analyst；15:02 扫描新增 43 个岗位，暂无明显合适岗位。
- 针对 SEEK 漏扫问题做了策略复盘：旧扫描偏传统职位名，漏掉了 `application`、`automation`、`power platform`、`AI solution` 等能力/生态关键词，需要扩展扫描策略。

## 决策与变更
- 邮件处理架构决定：main agent 只保留频道路由与触发规则，邮件复盘的状态检查、重复判断、分类、用户回复处理、todo 跟踪等细节放入 `mail-review` skill，避免继续膨胀 main `AGENTS.md`。
- `mail-review` skill 设计为确定性工作流：包含状态 schema、分类规范、todo policy、用户回复处理规则与 quickstart，目标是以后不依赖临时语义记忆或聊天缓存判断邮件是否已处理。
- 求职扫描策略需要从“职位名匹配”升级为“职位名 + 能力关键词 + 生态关键词”混合扫描，尤其覆盖业务系统、自动化、Power Platform、Dynamics、SharePoint、AI tooling、application support 等本地经验友好型岗位。
- 求职材料生成继续沿用项目内 Claude/skill 流程，但执行中必须核验真实产出文件；今天 Claude Code 曾卡住无输出，已中止后改用更直接的非交互调用完成材料生成。

## 错误与改进
- 邮件复盘错误：同类邮件重复处理，原因不是规则缺失，而是执行流程没有强制读取 `email_review_state.json`、`Email_Review_Log.md` 与近期 #mail 用户回复。已通过 `mail-review` skill 与 AGENTS 路由规则修正。
- AGENTS 负载问题：把复杂邮件处理细节继续塞进 main agent 会让主规则过重；已改为“main 轻路由 + skill 承载细节”。
- 求职扫描漏召回：Ngāi Tahu、Ryman 等更贴近 Shaun 当前目标的岗位未被日常扫描捕捉，说明扫描 query 过窄。下一步应调整扫描关键词并回测命中质量。
- 长任务反馈纪律继续被验证：Claude 生成材料时没有直接声称完成，而是等待实际文件与数据更新；这是正确模式，应保持。

## 未完成事项（待提醒）
- 需要按今天的复盘结果更新/验证 SEEK 日常扫描策略，增加能力与生态关键词，并确认后续扫描是否能覆盖 Ngāi Tahu / Ryman 这类岗位。
- 需要跟进 Joyn 岗位材料的后续申请动作：确认 CV / cover letter 是否需要人工微调，并决定是否投递。
- 需要跟进 Ngāi Tahu、Ryman、Randstad、PHF Science 等已入库岗位的下一步：生成材料、投递、或标记优先级。
- 需要处理 PM 邮件复盘中的 GitHub / EdgeMatrixChain EMC-Dashboard PR #3：是否 review/merge，以及 bounty/钱包信息如何处理。
- 需要观察 `mail-review` skill 在下一轮邮件复盘中是否真正避免重复提醒；若仍失败，应把状态脚本接入为强制 gate。

## 明日优先级 Top 3
1. 完成 SEEK 扫描策略升级与一次回测：新增 `application`、`automation`、`power platform`、`Dynamics`、`SharePoint`、`AI solution`、`business systems` 等关键词，确认不会显著增加低质量噪音。
2. 推进已入库高优先级岗位：优先 Joyn、Ngāi Tahu、Ryman，其次 Randstad 与 PHF Science；明确每个岗位的材料状态与下一步。
3. 跑一轮邮件复盘流程验证：确认 `mail-review` skill 会先查状态与日志，再输出新邮件复盘；同时处理 GitHub PR #3 这类待用户决策事项。
