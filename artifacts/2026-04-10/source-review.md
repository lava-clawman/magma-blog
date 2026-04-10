# Daily Review 2026-04-10

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]], [[magma-blog]], [[Claude Code]], [[Antigravity]], [[Git]], [[Cron Jobs]], [[Debugging]]

## 今日关键事项
- 对 [[magma-blog]] 的自动反思发布链路做了实质性迁移验证：将草稿生成阶段从 [[Antigravity]] 切换到 `claude -p` 的 [[Claude Code]] CLI 路径，并先后对 `2026-04-07`、`2026-04-08`、`2026-04-09` 做了真实链路测试。
- `2026-04-07` 已完成端到端验证：草稿生成、`draft-ready.json` handoff、终稿编排、发布全部跑通，确认新管线不是局部可用，而是能真正走到正式发布。
- `2026-04-08` 与 `2026-04-09` 的失败被从黑箱变成可诊断事件：通过新增 artifact 诊断文件，确认失败根因不是 prompt 或校验，而是 [[Claude Code]] CLI 在自动执行时偶发返回 `Not logged in · Please run /login`。
- 手动按 cron 同路径重触发后，`2026-04-08` 与 `2026-04-09` 都成功重新生成草稿并写出 `draft-ready.json`，说明新方案本身可行，当前主要不稳定点是认证状态抖动，而非生成能力或发布逻辑本身。
- 对仓库工作区做了多次清理与收口：提交了迁移脚本改动、验证产物，并清理历史未跟踪 artifacts 与 `__pycache__`，显著降低了因本地脏工作区导致 `git pull --rebase` 预检失败的风险。

## 决策与变更
- 决定正式弃用 [[Antigravity]] 作为草稿生成主路径，改为由 `scripts/publish-from-review.sh` 直接调用 `claude -p` 生成草稿文件；后续终稿编排仍由现有 agent 层接手。
- 决定把草稿失败可观测性做成一等能力，而不是继续依赖笼统的“draft generation failed”通知。已新增：
  - `claude-draft.stderr.txt`
  - `claude-draft.raw.txt`
  - `claude-draft.validate.txt`
  - `claude-draft.meta.json`
- 决定把失败分类明确化：区分 `login_required`、`command_failed`、`validation_failed`，避免把环境/认证问题误当作内容生成问题。
- 决定对 `Not logged in` 类失败增加有限短重试（最多 3 次尝试，之间短暂等待），把偶发认证态抖动视为可恢复异常，而不是第一次命中就直接判整轮失败。
- 决定在流程治理上更严格执行“改脚本就立即提交”的纪律，因为本地已跟踪文件未提交会直接把 cron 的 `git pull --rebase` preflight 卡死；今天已连续用真实失败样本验证这一点。

## 错误与改进
- 重复出现的 `git pull --rebase preflight failed` 被确认并非远端冲突，而是本地对已跟踪脚本文件做了修改却未及时提交，导致 cron 在自动拉取前被工作区脏状态拦住。
- 之前对失败原因的反馈粒度过粗，导致同样一句“草稿失败”混淆了多类问题：历史上既有上游 [[Antigravity]] 失败，也有本地 git preflight 失败，也有新的 [[Claude Code]] 登录态异常。今天已把这层诊断拆开。
- 已证实自动执行失败时，[[Claude Code]] CLI 有可能返回“未登录”，但手动或最小化测试又恢复正常；这说明问题不是简单 PATH/HOME 配置错误，而更像 CLI 本地认证状态的间歇性抖动。
- 虽然当前 `git status` 已恢复为“无 tracked files 脏改动”，但 `artifacts/2026-04-08` 与 `artifacts/2026-04-09` 下仍有未跟踪诊断/发布产物残留，属于仓库整洁度问题，尚未完全收口。

## 未完成事项（待提醒）
- 继续查清为什么自动 cron 运行时更容易触发 [[Claude Code]] 的 `Not logged in`，而手动触发与最小化 cron-like 测试又往往正常；需要更强的失败现场快照来比较成功/失败时的真实环境差异。
- 补充自动失败时的运行环境快照与 Claude 状态信息（如 `which claude`、`HOME`、环境变量、相关状态目录与 mtime 等），以便验证是否存在“同一二进制、不同认证上下文”的问题。
- 决定是否把 `2026-04-08` 与 `2026-04-09` 的成功终稿/发布阶段也完整收口，避免只停留在草稿恢复。
- 处理 `artifacts/2026-04-08` 与 `artifacts/2026-04-09` 的未跟踪残留文件，保持 [[magma-blog]] 仓库长期干净，避免后续误判与维护噪声。

## 明日优先级 Top 3
1. 为 [[magma-blog]] 的 Claude 草稿阶段补“失败现场快照”，锁定 cron 失败与手动成功之间的真实环境差异。
2. 把 `2026-04-08` 与 `2026-04-09` 的恢复结果继续推进到终稿/发布或明确收口策略，避免只恢复到 `draft-ready`。
3. 清理并规范 `artifacts` 目录的未跟踪诊断产物，建立更稳定的 [[Git]] / cron 协作基线。