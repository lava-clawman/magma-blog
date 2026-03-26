# Daily Review 2026-03-26

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[magma-blog]] 的 `2026-03-25` 反思文最终成功发布：经历多轮排障后，发布链路完成了 Antigravity 生成/超时判定、本地兜底、privacy check、[[Astro]] build、git commit、push 与成功通知闭环，最终提交为 `c60ea27`。
- 围绕 [[Antigravity]] 自动发布链做了连续修复：从“要求它写文件并返回路径”改为“只要求返回正文，由本地脚本提取、规范化、落盘并发布”，显著收缩了它在链路中的职责边界。
- 发布脚本 `publish-from-review.sh` 在今天连续完成多次实质性改造：加入限定等待窗口、改进正文提取、忽略 prompt 模板、清理本次 `artifacts/<date>/` 残留、避免 `git pull --rebase` 被中间文件误挡，并验证整条链路最终可跑通。
- 今天还澄清了 [[Antigravity]] 失败模式：它并非整体不可用，而是在自动化约束下常表现为“超时或未按契约交付可机读成稿”；手动触发可成功，说明问题更偏向自动链稳定性与交付纪律，而非纯能力缺失。
- 对自动发布策略形成了更清楚的分层理解：若以稳定发稿为优先，应保持较短等待并快速兜底；若更重视 [[Antigravity]] 稿件质量，可考虑把等待窗口放宽到约 5 分钟，或做成“检测到生成迹象时再延长等待”的分层策略。

## 决策与变更
- 决定不再把 [[Antigravity]] 当作可靠的文件写入执行器，而是降级为“正文草稿来源”；文件写入、frontmatter 规范化、privacy/build/push 全部由本地脚本负责。
- 将发布脚本的成功判据从“找到 artifact 文件/路径提示”转为“从 `antigravity read -f json` 中提取到最终 markdown 并通过后续校验”，这是今天最关键的架构调整。
- 针对自动链路的稳定性，决定保留 git preflight 的目的（发布前先与远端 `main` 对齐），但修正其颗粒度：允许安全清理本次未跟踪 artifact 残留，而不是一见脏工作区就整体阻断。
- 针对 [[Antigravity]] 的输出不稳定性，逐步收敛出新的提取策略：跳过模板占位 frontmatter、从后半段定位真实标题块、必要时走本地兜底生成，从而把“内容能力”和“严格交付”拆开处理。
- 对等待策略的方向达成初步判断：默认自动发布宜偏保守，优先可验证收口；若人为明确偏好质量优先，可增加等待窗口而不是恢复无限等待。

## 错误与改进
- 早期脚本错误地假设 [[Antigravity]] 会稳定写出文件并返回 `ARTIFACT_PATH`，实际它常只给相对路径或口头“写好了”，导致自动链长期卡在 artifact 交付层；今天已改为正文提取模式。
- 多次失败暴露了正文提取器的脆弱性：先后踩到“压扁 frontmatter”、“抓到 prompt 模板而不是真实成稿”、“frontmatter YAML 非法导致 build 失败”等问题；今天通过多轮修补才最终跑通。
- `git pull --rebase` preflight 一度被 `artifacts/2026-03-25/` 等未跟踪中间文件挡住，说明发布前同步逻辑虽然方向正确，但实现过硬；已补上针对本次 artifact residue 的清理逻辑。
- [[Astro]] build 的 `bad indentation of a mapping entry` 明确暴露出自动链最后一公里不在生成本身，而在 frontmatter 规范化与成稿切块；这促使链路从“大正则猜测”转向更明确的真实块定位。
- 运行过程中仍留下少量尾巴文件，如 `.success-notified` 与 `antigravity-prompt.txt` 的未跟踪处理策略还不够统一；这虽未阻断最终发布，但属于后续需要收尾的稳定性问题。

## 未完成事项（待提醒）
- 决定是否正式放宽 [[Antigravity]] 自动发布等待窗口：维持当前保守策略，还是调整为约 5 分钟，或改成“检测到生成迹象后再延长等待”的分层方案。
- 清理并制度化发布链对 `.success-notified`、`antigravity-prompt.txt` 等残留文件的处理方式，避免后续继续干扰 preflight 与重试逻辑。
- 将今天关于 [[Antigravity]] 自动链失败模式、提取策略与兜底边界的结论沉淀到更稳定的运行基线中，避免未来再次重复同类排障。
- 继续观察未来几次自动发布，确认今天的修复不是一次性 luck，而是能在 cron 场景下稳定复现。

## 明日优先级 Top 3
1. 跟踪下一次 [[magma-blog]] 自动发布，验证今天修复后的链路在无人值守场景下是否稳定复现。
2. 决定并实现新的 [[Antigravity]] 等待策略（保持 2 分钟、放宽到约 5 分钟，或做成“有生成迹象再延长”的分层等待）。
3. 收尾发布脚本的中间文件与通知标记管理，把今天暴露出的 residue / preflight 干扰问题彻底做干净。