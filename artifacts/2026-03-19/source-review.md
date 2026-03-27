# Daily Review 2026-03-19

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 完成了 [[OpenClaw Gateway]] 的一轮稳定性排查与恢复，确认主问题不是配置本身持续损坏，而是外部 watchdog 对 Gateway 的激进自动恢复导致反复重启与短时失联。
- 针对 [[Telegram]] 通道做了两类处理：一是修正群聊 allowlist 相关配置的放置方式；二是把 Telegram 错误从“粗暴关键词告警”升级为“分类采样 + 分级判断 + 每日摘要”。
- 将 watchdog 从“单次失败即重启”改为更保守的恢复策略：先告警、记录连续失败、考虑启动宽限期与冷却时间，满足条件后才做轻量恢复。
- 为 watchdog 增加了 Telegram 异常样本沉淀与日报输出，摘要将发往 Discord 的 baseline-self-check 频道，用于持续优化判断规则。

## 决策与变更
- 明确确认：`second-brain-ops` 的 `watchdog-daemon.sh` 通过 crontab 每分钟仅负责“保活 tmux session 是否存在”，不会无限多开；真正导致不稳定的是 `watchdog.py` 内部 Gateway 恢复逻辑过于激进。
- 调整 [[OpenClaw Gateway]] watchdog 策略：
  - 增加连续失败阈值
  - 增加启动宽限期
  - 增加告警冷却与恢复冷却
  - 恢复动作降级为轻量 `openclaw gateway start`
  - 去掉此前更容易补刀的 restart / LaunchAgent reload 式重手恢复路径
- 调整 [[Telegram]] 异常处理策略：
  - 新增分类：`restart_window` / `network` / `webhook_cleanup` / `send_failure`
  - 引入“重启窗口降权”判断，避免把 provider 启停期的噪音误报成“消息可能丢失”
  - 将原始样本写入 `watchdog-telegram-events.jsonl`
  - 增加每日 Telegram 异常摘要并投递到 Discord 指定频道
- 已将语言偏好补充到 `USER.md`：避免使用“吃到新逻辑”这类含混、拟人化、圈内黑话式表达。

## 错误与改进
- 主要故障模式已识别：Gateway 能启动，但随后频繁收到 `SIGTERM`，造成 Telegram/Discord/Slack 通道短时抖动；根因来自外部 watchdog 的自动恢复与人工维护动作相互叠加。
- `launchctl` 与日志证据表明，部分异常属于“外部终止/重启”而非 Gateway 自身崩溃；这一判断帮助把排查重点从配置错误转到自动化干预链路。
- Telegram 告警逻辑此前把 `deleteWebhook failed` / `webhook cleanup failed` 误当成“消息投递失败”，已改为先收集样本再分类，显著减少误报空间。
- Telegram 群聊配置已做过一轮修正：群组 ID 不再混放到用户 allowlist；但群内谁可触发 bot 的最终权限策略仍未完全收尾，目前以“暂时够用”为准。

## 未完成事项（待提醒）
- 继续观察 [[OpenClaw Gateway]] 在新 watchdog 策略下是否仍出现重启风暴、PID 抖动或新的 `SIGTERM` 模式。
- 继续验证 [[Telegram]] 群聊权限配置是否满足实际使用；若再次出现群内触发异常，需要明确采用“群内开放”还是“仅 Shaun 可触发”的最终策略。
- 观察新加的 Telegram 异常日报是否足够有区分度，后续可考虑补充“稳定运行期 vs 重启窗口期”统计维度。
- 如需进一步降低误报，可继续根据 `watchdog-telegram-events.jsonl` 的真实样本迭代分类规则与告警阈值。

## 明日优先级 Top 3
1. 复核 [[OpenClaw Gateway]] 在新 watchdog 策略下的稳定性，确认不再被自动恢复逻辑反复打断。
2. 检查 [[Telegram]] 群聊触发权限与实际消息收发情况，决定是否继续精修 allowlist / groupPolicy。
3. 查看首轮 Telegram 异常日报效果，决定是否增加更细的上下文统计与更明确的高优先级告警规则。
