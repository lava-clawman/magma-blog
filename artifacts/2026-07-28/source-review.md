# Daily Review 2026-07-28

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[Phocas Software]], [[求职]], [[家庭财务]]

## 今日关键事项
- 完成 [[Phocas Software]] 面试相关支持：核实 11:00–11:30 与 Alix Huntsman 的安排；确认原始邀请、日历事件和 `.ics` 均遗漏会议链接，并给出联系招聘方 Emily Alexander 的紧急英文模板。
- 面试后继续调查 Phocas Christchurch 团队：公开证据支持其为规模较大的主力办公室，人数只能估算约 80–120；员工评价总体偏正面，但晋升空间、技术债及私募入股后的变化仍需留意。
- 针对下一轮面试官姓名线索，Neil Cooper 是当前最吻合的公开人选，但职位、地点及是否为实际面试官尚未得到可靠确认，不能作为确定事实使用。
- 求职扫描新增两条可推进岗位：Streamline Business NZ 的 Full Stack Developer（66%）与 CEVA Logistics 的 Business Analysis & Intelligence Specialist（65%），均已进入 positions 流程并生成初步分析。
- 完成近期电费复核：Mercury 最近 91 天纯电费比去年同期 Nova 高约 $106.26，但今年用电量也高 9.4%；计入宽带后总支出仅高约 $53.76。结合 Nova 2026-04-01 涨价后的新费率，换到 Mercury 的决定仍然合理。
- 核实 [[OpenClaw Memory]] 状态：记忆文件未丢失，语义搜索索引已恢复；但长期记忆整理、每日记录和 promotion 链路近期没有稳定持续运行。

## 决策与变更
- Phocas 薪资判断保持证据分层：90–97k 只是第三方普通工程师样本，不是该岗位已知薪资；对 graduate/junior 属于较好区间，对中级开发者则偏低。
- 对潜在面试官和团队规模不做过度确认：Neil Cooper 与 80–120 人均作为线索/估算保留，后续面试准备须继续标注不确定性。
- 家庭能源判断应比较“新旧供应商当前费率”，而不是只比较跨年账单；Nova 涨价后的反事实成本支持此前转签 Mercury。

## 错误与改进
- Phocas 招聘邀请遗漏会议链接，直到面试前约 10 分钟才完成核查。后续收到面试邀请后应尽早检查 `LOCATION`、视频会议字段和 `.ics`，至少提前一天暴露缺失项。
- 今日及昨日均没有生成 `memory/YYYY-MM-DD.md`，说明每日记忆写入/整理链路存在连续性缺口；语义索引恢复不等于记忆管理全链路恢复。
- 晚间 `email-review-pm` 和本次 `sb-daily-review` 均出现模型返回不完整响应：工具准备阶段已执行，但最终写入/回复未完成。需要将关键定时任务绑定到经过实际 cron 场景验证的稳定模型，并避免依赖模糊 fallback。

## 未完成事项（待提醒）
- 确认 Phocas 下一轮安排、实际面试官身份和时间；如收到后续邮件，及时补充 Neil 线索并按真实职位准备。
- 评估是否联系 1–2 位 Phocas Christchurch 员工作轻量 informational outreach，避免在面试官身份未确认时直接套近乎。
- 修复每日记忆日志与长期记忆 promotion 的连续运行，并补查 2026-07-27 是否有值得恢复的关键记录。
- 排查连续失败的自动任务：`sb-daily-review`、`sb-weekly-review`、`email-review-pm` 与 weekly portfolio context，区分供应商鉴权/超时与模型空响应问题。

## 明日优先级 Top 3
1. 跟进 [[Phocas Software]] 面试后续，确认下一轮面试官、时间与会议链接。
2. 修复并验证关键 cron 的模型稳定性，至少完成一次真实写文件与投递的端到端测试。
3. 恢复每日 memory 日志与 promotion 链路，补齐最近两天的关键事实与待办。
