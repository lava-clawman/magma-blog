# Daily Review 2026-06-07

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Australian Biometrics]] / 签证材料推进：确认三个人（Shun、Leyi、Qian）都需要去做 biometrics，且电子版 appointment letter / biometric requirement letter 可用；同时复核本地三份 PDF，纠正了预约表单中 VLN 的填写依据。
  - 正确 VLN：Shun `AUE-NZ-66-027242-A`；Leyi `AUE-NZ-66-027244-G`；Qian `AUE-NZ-66-027245-W`。
  - 对应 Application ID：Shun `1510720649`；Leyi `2055720410`；Qian `1670721966`。
  - 现场重点材料：三人护照原件、三人各自 biometrics requirement letter / appointment letter，建议手机本地保存并打印备用。
- [[Email Review]] AM/PM 两轮运行正常：AM 复盘确认没有重复制造已处理邮件待办；PM 识别出 OpenAI macOS 应用安全更新、图书馆借阅收据等信息，并继续把邮件处理状态写入本地索引。
- [[Local AI Models]] 判断：当前 Mac mini M4 / 16GB unified memory 能跑 Gemma 4 12B，但属于刚好够用；现实推荐 Q4 量化，Q5 可能吃紧，长上下文需保守。
- [[Paperclip]] 夜间健康状态稳定：dreaming narrative 记录显示 Paperclip 持续处于 expected local mode，`paperclip-poc` tmux 与 Node/tsx listener 正常，公共与本地 health check 均保持 ok。
- [[Weekly Review]] 已在昨晚生成：`/Users/lab/Flash-Claude/FlashNotes/reviews/Weekly-Review-2026-W23.md`。

## 决策与变更
- Biometrics 预约字段判断发生关键修正：先前把邮件标题/信件中的 `BCC2026/...` 误认为 VFS 预约 VLN，后续通过 PDF 原文确认真正应填写的是 `AUE-NZ-...`，并已把三人的准确字段整理出来。
- 邮件复盘流程继续采用“读取候选邮件 + 交叉检查 `email_review_state.json` + 避免重复提醒”的策略；AM 轮体现了去重逻辑有效，PM 轮继续分类为“需要马上处理 / 值得注意 / 求职机会”等。
- 本地模型运行策略明确：16GB 设备可以尝试 12B，但不应按宽裕机器规划；后续如果要本地跑，优先选择量化、小上下文、可回退方案。

## 错误与改进
- VLN 字段误判是今天最重要的纠错：仅凭邮件标题或外层编号判断不够可靠，涉及官方表单填写时应优先打开 PDF/原文逐项核对。改进规则：签证、移民、缴费、预约类信息若包含多个编号，必须区分编号用途后再给最终答案。
- 邮件复盘 AM 输出显示系统能避免重复待确认，这是好现象；但 PM 里 OpenAI macOS 安全更新仍需要后续确认是否已处理，不能只停留在“值得提醒”。
- 今日无 memory 日志文件，Daily Review 主要依赖近 24 小时活跃 session。改进：如果当天有关键执行链路，最好同步写入短期 memory 或 FlashNotes log，避免只散落在会话里。

## 未完成事项（待提醒）
- [[Australian Biometrics]]：完成 VFS 三人预约；预约时使用三人的 `AUE-NZ-...` VLN，并确认每个人是否需要单独 appointment / customer entry。
- [[Australian Biometrics]]：预约完成后整理现场 checklist：护照原件、三人 requirement letter、appointment confirmation、手机离线副本、打印备份。
- [[OpenAI]]：确认 ChatGPT macOS app 是否已更新到安全更新版本；如仍在使用旧版，应尽快升级。
- [[Library]]：Christchurch City Libraries 当前借阅 18 本，新借 2 本到期日 2026-07-05；暂不紧急，但应进入借阅追踪。
- [[Job Search]]：AM 邮件复盘提到的 LinkedIn 求职线索仍是待确认状态，包括 Tribe Group Product Manager / Partly Principal Product Manager 等，需择优继续筛选。

## 明日优先级 Top 3
1. 完成 [[Australian Biometrics]] 三人预约，并把最终 appointment confirmation 与材料 checklist 归档。
2. 处理 [[OpenAI]] macOS 应用安全更新提醒：确认当前版本或安排更新。
3. 继续收口 [[Job Search]] 邮件线索：筛选高价值岗位，避免待确认列表长期堆积。
