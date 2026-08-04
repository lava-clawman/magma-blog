# Daily Review 2026-08-04

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 求职推进出现明确转向：[[Phocas]] AI Implementation Engineer 收到拒信并更新为 `rejected`；随后完成 2026 Graduate Programme – Software Engineers 的定制 CV、较 casual 的 cover letter，并单独提交申请。
- [[Syft Technologies]] Full-Stack Developer 已正式提交，岗位流水线与分析队列同步更新。
- 复核 [[Airways]] FlightYield Software Engineer 后确认真实匹配度仅约 20–25%；Java 专长和至少两年结构化软件团队经验属于明显硬缺口，决定跳过。
- 对 [[Youthline Central South Island]] 的 AEWV 认证雇主资格完成公开资料核查：实体、NZBN、持续运营及近两年财务表现基本符合申请门槛，但其是否愿意认证、职位是否满足签证要求仍需另行确认。
- 邮件复盘确认：Willowbank 交易与 Mates Rates 注册为本人操作并已处理；Contented 的“申请未完成”邮件是延迟提醒，无需重复申请；Wholesale Solutions 与 Ember Technology 申请仍在审核。
- [[magma-blog]] 完成从 Claude Code 草稿、worker-general 终稿到正式发布的自动化流程。

## 决策与变更
- 求职重心进一步聚焦 [[Graduate Software Engineer]]、Junior Software Engineer 与 AI Graduate 岗位，减少对经验或技术栈硬门槛明显不匹配职位的投入。
- 多招聘来源扩展不应把 Indeed 逻辑直接塞入 `seek-cli`，也不应复制完整 `indeed-cli`；更合理的长期方向是统一的 `jobs-cli` / job discovery framework，内部采用 SEEK、Indeed 等独立 adapter，并保留现有 SEEK 命令兼容性。
- Indeed 可研究 Cookie、浏览器指纹和 CDP fallback 的复用方案，但 Cookie 不能视为稳定抓取保证；在投入工程化前，应先做小规模可行性验证并评估风控、频率和维护成本。
- 对潜在认证雇主的判断采用两层标准：先核实机构是否具备申请资格，再单独判断其申请意愿及具体岗位能否支持 AEWV，避免把“有资格”误解为“可以担保”。

## 错误与改进
- 自动岗位匹配分可能被地点、职位名和 SQL 等表面关键词抬高；今后应优先检查必需技术栈、经验年限和团队背景等硬门槛，再给出人工匹配结论。
- Prodigy 年费误续费退款请求自 7 月 27 日提交后，超过一周仍无客服回复或工单确认；原流程缺少可靠回执和超时跟进机制。后续提交退款/支持请求时应保存确认编号，并设置明确的 3–5 个工作日复查提醒。
- SEEK 的成功经验不能直接外推到 Indeed；应将抓取、认证状态、页面解析和 fallback 分层，避免来源特有逻辑污染统一流水线。

## 未完成事项（待提醒）
- 跟进 [[Prodigy]] USD 89.21 年费误续费退款：通过官方 Billing and Membership 渠道重新提交或追问，并注明原请求日期 2026-07-27。
- 确认给 Emily 的 Phocas 原邮件线程草稿是否需要发送；目前记录显示草稿已创建但尚未发送，而 Graduate 岗位已经提交。
- 持续跟踪 Wholesale Solutions 与 Ember Technology 的审核状态，等待 shortlist、面试或拒信变化。
- 若继续扩展招聘扫描，先为 Indeed 做有限 PoC：验证登录态/Cookie 可复用性、搜索结果稳定性、结构化数据来源及限频策略，再决定 `jobs-cli` adapter 的实现范围。
- 如 Youthline 岗位进入下一阶段，直接询问机构是否愿意申请雇主认证，以及职位工时、薪资和职责是否满足 AEWV 条件。

## 明日优先级 Top 3
1. 重新跟进 Prodigy 退款并取得可追踪的确认编号或邮件回执。
2. 围绕 Graduate / Junior Software Engineer 岗位继续筛选和提交高匹配申请，同时处理 Phocas 给 Emily 的待发草稿。
3. 为统一 `jobs-cli` 明确最小 adapter 接口，并对 Indeed 数据获取路径进行小规模可行性测试。
