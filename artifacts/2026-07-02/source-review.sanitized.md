# Daily Review 2026-07-02

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Job Search]], [[Email Review]], [[magma-blog]], [[Phocas Software]]

## 今日关键事项
- [[Phocas Software]] 首轮 HR 面试已完成，反馈整体偏正向：对方说明后续还有三轮，包括美国 Customer Lead 以及 Christchurch 本地团队两轮，预计下周再有进展。
- 已把 Phocas 岗位状态更新为 `interviewing`，并同步补充面试准备记录：今天问过 3–6 个月成功标准与岗位期望，HR 先表示 “good question”，但回答主要复述 JD，说明下一轮需要把问题问给真正 owner。
- 今日岗位扫描两轮合计新增大量岗位，并自动推进 4 个较高匹配机会进入 positions：
  - Intermediate Software Engineer (TypeScript, Node.js, React) @ Aderant
  - Digital Solution Area Specialist - Copilot @ Microsoft
  - Data Scientist (AI Enablement) @ University of Canterbury
  - Data Analyst @ MBIE
- [[Email Review]] AM/PM 两轮复盘完成。AM 重点提醒 Phocas 面试、GitHub passkey、新邮件待确认；PM 无紧急事项，记录 Claude Fable 5、LU Career Centre、Gate 等低优先级信息。
- [[magma-blog]] 自动发布链路从早前草稿校验失败中恢复：Claude Code 草稿生成后，通过 worker-general 终稿编排并完成正式发布。
- Shaun 在 Telegram 明确要求在 `AGENTS.md` 中增加 “DO NOT send optional commentary” 规则，已写入 Messaging rule，后续回复应更克制，只保留必要 substance / confirmation / actionable result。

## 决策与变更
- [[Phocas Software]] 后续准备策略调整：不再泛问 “success measures”，而是在 Customer Lead / Christchurch team 面前改问更具体的 delivery、team workflow、customer problem、AI tooling adoption 场景问题，以获得实质信息。
- 邮件复盘流程进入更严格状态管理：昨日已确认 `email-candidates.py` 之前没有代码层过滤已处理邮件，导致 IMMI 已处理邮件被重复提醒；今天 AM/PM 复盘继续要求先读取 `email_review_state.json` 与 `Email_Review_Log.md`，再生成新增复盘。
- 沟通规则收紧：`AGENTS.md` 新增不发送可选说明的要求，尤其适用于同上下文确认、任务完成回报、频道内更新，避免重复确认和无意义说明。
- 求职主线继续以本地经验和高匹配岗位推进为优先，自动岗位管线保持运行，并把可推进岗位自动进入 positions 与分析队列。

## 错误与改进
- 邮件复盘重复提醒问题的根因已明确：不能只依赖 cron prompt 要求模型过滤，候选脚本本身也必须读状态并过滤。改进方向是把“已复盘/已处理不再提醒”固化到脚本层，而不是仅依赖执行代理自觉。
- Telegram 规则更新出现重复确认消息，和 Shaun 新增的 “DO NOT send optional commentary” 正好相关。后续同类配置/规则更新应只回复一次最小确认。
- [[magma-blog]] 早前草稿阶段失败的表象是 Claude Code draft generation failed，但真实原因是 Claude 已返回输出、草稿校验未通过。后续排障要区分“模型未产出”和“产出未通过校验”，避免误判。
- 面试信息记录中曾把 “good question” 误识别/误写为“还问题”，已被 Shaun 纠正，并已更新面试准备文档。后续语音/拼写纠错要保留不确定性，避免把明显可能是输入错误的词直接当事实。

## 未完成事项（待提醒）
- [[Phocas Software]] 下周等待后续轮次安排；需要提前准备 Customer Lead 视角问题与 Christchurch 本地团队问题。
- GitHub passkey 新增提醒需要 Shaun 判断是否本人操作；若不是本人，需要立即检查 GitHub 安全设置。
- AM 邮件复盘中仍有若干等待用户确认的邮件事项，需要后续根据 Shaun 回复更新 `email_review_state.json` 与 `Email_Review_Log.md`。
- LU Career Centre 周报正文提取不完整，低优先级：有空可手动扫一眼，避免漏掉活动或岗位信息。
- 今日新增岗位中已推进的 4 个机会需要继续完成深度分析、CV/cover letter 或申请决策，不要只停留在自动入库。

## 明日优先级 Top 3
1. 深化 [[Phocas Software]] 后续面试准备：整理 Customer Lead / Christchurch team 两类问题、项目叙事、AI tooling / professional services 结合点。
2. 处理邮件复盘遗留确认项，并继续验证 [[Email Review]] 状态过滤是否稳定，避免已处理邮件再次进入待确认。
3. 跟进今日自动推进岗位，优先复核 University of Canterbury Data Scientist、Aderant、Microsoft Copilot、MBIE Data Analyst 的 JD 与个人项目匹配度，决定申请顺序。
