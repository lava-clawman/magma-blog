# Daily Review 2026-06-09

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[Email Review]] AM/PM 两次自动复盘正常执行，过滤旧邮件后输出新事项；重点包括 [[Google]] Search 隐私设置变更、[[Atlassian Loom]] 订阅付款提醒、[[Youthline]] WFH 回复确认。
- [[Youthline]] WFH 邮件处理闭环：先误用 Apple Mail 创建草稿，随后按 Shaun 校准改为使用 `gog` 的 Gmail 账号 `lazyeo25@gmail.com`，并成功创建 Gmail Draft，收件人为 `trystan@youthlinecsi.org.nz`。
- [[Job Search]] 方向继续校准：分析 Ember/Christchurch 本地岗位后，判断适合推进；随后更新岗位策略与个人资料，把叙事重心从学校练手项目转向真实 side projects。
- [[Resume Optimizer]] 的 `my_profile.json` 已更新：强化 AI-enabled software/product builder、BA/product/documentation/technical delivery 定位；软件/AI/dev 岗位默认优先讲 [[CareerMatch AI]]、[[NZ Immigration RAG]]、Kids Worksheet Generator、Personal Homepage/AI chat、Smart Canvas 等项目。
- 夜间 dream narrative / heartbeat 类会话持续记录 [[Paperclip]] 健康状态：`paperclip-poc` tmux、`/api/health`、version `0.3.1`、local_trusted/private 模式均被反复确认。

## 决策与变更
- 邮件工作流基线变更：以后邮件草稿/发送默认使用 `gog + lazyeo25@gmail.com`，不使用 Apple Mail；该偏好已写入本地记忆与工具说明。
- 求职叙事基线变更：本地 software / AI / dev 岗位优先使用真实 side projects 作为主证据，学校项目只作为基础能力补充。
- 技术能力表述边界明确：可以表达 AWS/GCP/Cloudflare、域名、服务器、cloud-hosted DB、部署排障等基础 DevOps/运维认知，但不包装成专职 DevOps/SRE。
- 对 Christchurch 本地岗位的判断原则进一步明确：当前目标是尽快获得本地岗位与本地经验，本地 junior/intermediate technical delivery / software foothold 值得优先推进。

## 错误与改进
- 错误：邮件草稿最初误走 Apple Mail，违背 Shaun 对 Gmail/gog 的实际偏好。
  - 改进：已把“邮件操作默认走 gog 的 Gmail 账号 `lazyeo25@gmail.com`”写入 `USER.md` / `TOOLS.md`，后续邮件相关任务先检查该基线。
- 风险：自动邮件复盘容易重复提醒已处理邮件。
  - 改进：继续在新复盘前交叉检查 `email_review_state.json`、`Email_Review_Log.md` 和 #mail 近期回复，避免旧事项反复进入待确认列表。
- 风险：CV/CL 自动生成可能沿用旧的“学校项目为主”叙事。
  - 改进：已更新 `my_profile.json` 和求职偏好记忆，后续生成材料需优先读取这些字段，并以 JD 原文复核。

## 未完成事项（待提醒）
- [[Atlassian Loom]]：是否补付款方式仍待 Shaun 判断；若 Loom Business + AI 不是刚需，建议自然停用。
- [[Google Search Privacy Settings]]：如果 Shaun 介意 Lens/Search Live 等图片、音频、视频互动被保存，需要后续检查 Google 新隐私设置。
- [[Youthline]]：WFH 已获 Trystan 确认，周四去办公室；目前无需回复。
- [[Apple Mail]]：误建草稿脚本未找到可删草稿，可能未实际落到草稿箱；若未来出现重复草稿再清理。
- [[Paperclip]]：健康状态稳定，但仍需按既有 heartbeat / preflight 机制观察，不需要主动干预。

## 明日优先级 Top 3
1. 推进 [[Job Search]]：基于更新后的 `my_profile.json` 继续生成/优化高优先级本地岗位 CV 与 cover letter，确保 side-project-led 叙事生效。
2. 处理 [[Email Review]] 遗留：决定 [[Atlassian Loom]] 是否续费；如有必要检查 Google 新隐私设置。
3. 维护 [[Second Brain Operating System]]：把今天形成的邮件工具偏好、求职叙事基线与未完成提醒保持在可复用位置，避免后续流程回退。
