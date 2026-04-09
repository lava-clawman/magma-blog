# Daily Review 2026-04-09

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 对 [[magma-blog]] 的自动反思发布链做了系统性排障，确认失败来源已不再是单一问题，而是贯穿 [[Antigravity]] 上游稳定性、草稿判定标准、cron 重试策略、git preflight 与执行面选择的组合问题。
- 完成对草稿失败样态的分层确认：一类是上游 `high traffic / Agent terminated` 直接失败；另一类是 [[Antigravity]] 已经输出了带噪正文，但现有草稿阶段仍将其判为失败。
- 改造了 [[magma-blog]] 的草稿阶段与通知逻辑：失败通知不再只报统一的 `antigravity draft generation failed`，而是区分 `upstream_busy`、`mixed_draft_rejected`、`no_useful_output`，并把真实失败原因写进通知文案。
- 放宽了草稿接收标准：草稿阶段开始接受“带噪但已有真实正文”的混合输出作为候选产物，不再把 `undo / Thought / Error` 一类中间噪声直接视为必然失败；同时保留最小正文阈值，避免把明显半截输出误交给终稿层。
- 完成了 [[magma-blog]] 重试策略收敛：`retry-missing-reflections.sh` 已改为每轮只处理一个最高优先级缺失日期，避免在同一时间窗口里连续为 4/7、4/8 等多个日期新建多个 [[Antigravity]] 会话抢上游资源。
- 修复了阻断 cron 的本地工作区问题：识别出 `git pull --rebase preflight failed` 的直接原因是已跟踪文件 `scripts/publish-from-review.sh` 存在未提交改动，而非远端冲突；相关修改已提交，恢复了下一轮 cron 的可执行性。
- 对 `magma-blog` repo 做了一轮低风险噪声清理，移除了 `scripts/__pycache__/`、本地调试脚本与明显的测试目录残留，降低后续排障时的工作区干扰。
- 在 [[tmux]] 中完成了 [[Claude Code]] 交互执行面的真实验证：旧的单行 `--print` 方式在 tmux 中不可靠，重建 session 后采用交互模式启动 `claude`，成功通过 `CLAUDE_TMUX_OK` 最小对话测试，并把“用 Claude Code 直接写草稿文件、替代 Antigravity 草稿链”的正式改造任务交给了新 session `magma-claude2`。

## 决策与变更
- 决定不再继续把精力投入到 [[Antigravity]] 的 UI 读回与草稿提取修补上，而是将草稿生成主路径迁移到 [[Claude Code]]，并让其直接写目标草稿文件，而不是在对话界面中返回草稿内容。
- 决定保留现有的终稿分层思路：草稿阶段负责产出可用草稿文件，终稿阶段仍由单独的 LLM / 编排逻辑负责清洗、润色与正式发布前处理。
- 确认“脏草稿治理”应主要由终稿层负责，而不是继续在 shell / 提取器层过拟合 UI 噪声规则；终稿 prompt 已按这一方向强化为把 prompt echo、UI 词、planning / thought 等视作 non-content noise。
- 将 [[magma-blog]] cron 保持为已重新启用状态，主任务时间维持 `03:35`，补偿重试保留每小时 `:35`，但补偿范围已从“连续扫最近多天”收敛为“只处理一个最高优先级缺失日期”。
- 针对 Claude Code 执行面，确认后续应优先使用“交互式 session + 明确文件产物”的方式，而不是回到单行一次性 `--print` 调用。
- 产生并保留了几次关键提交，用于锁定本轮恢复过程中的真实基线变更：包括草稿失败分类 / mixed output 处理，以及“每轮只重试一个缺失日期”的重试策略调整。

## 错误与改进
- [[Antigravity]] / opencli 草稿链持续暴露两个层面的失败：一是上游 `high traffic / Agent terminated`，二是有正文但混杂 UI 噪声的“半成功”返回；前者说明上游不稳定，后者说明本地成功判定过于保守。
- 旧的失败通知过于笼统，掩盖了真实原因，导致对问题阶段的判断失真；现已改为按失败类型细分通知。
- 原有重试脚本每小时会串行触发最近多天的缺失日期，导致多个独立 [[Antigravity]] 对话在同一窗口竞争同一上游容量，放大拥塞；已收敛为每轮只处理一个最高优先级日期。
- `git pull --rebase` 曾反复失败，但根因不是远端冲突，而是本地脚本改动未提交；这进一步验证了自动链对“工作区必须干净”的依赖非常高，也说明修改自动链后必须尽快提交，不能让 cron 在半改状态下继续运行。
- 在 [[tmux]] 中对 [[Claude Code]] 的首次启动尝试失败，暴露出“单行一次性 `--print` 调用在 tmux 中不可靠”；之后改用交互式启动、最小对话测试、显式权限确认，最终验证可用。这形成了更正确的可复用执行模式。
- Claude Code 在交互执行中对 `/tmp` 读取会触发权限确认，说明后续若继续依赖临时任务文件，需要处理 session 级权限模式；因此进一步得到改进方向：直接以内联任务文本驱动交互会话，减少 `/tmp` 路径权限摩擦。

## 未完成事项（待提醒）
- [[magma-blog]] 仍未完成从 [[Antigravity]] 到 [[Claude Code]] 的正式草稿链迁移；`magma-claude2` 已开始读取和分析 repo，但本轮改造尚未完成落盘、验证和提交。
- 需要在 Claude Code 完成改造后，验证新的 draft pipeline 是否真的能：读取 `source-review.sanitized.md`、直接写草稿文件、生成 `draft-ready.json`，并与现有终稿层正确衔接。
- 需要决定新草稿文件的正式命名与兼容策略：是直接复用 `antigravity-draft.md` 以减少下游变更，还是迁移到更中性的 Claude draft 路径。
- 仍有一些历史未跟踪 artifact 残留在 `magma-blog` repo 中，虽不再是当前主阻塞，但后续最好继续清理或纳入 ignore 策略，避免持续污染工作区信号。
- 需要在新草稿链稳定后，考虑是否关闭、移除或保留 [[Antigravity]] 相关脚本 / 依赖路径，避免双轨并存造成维护歧义。

## 明日优先级 Top 3
1. 继续跟进 `magma-claude2`，完成 [[magma-blog]] 从 [[Antigravity]] 到 [[Claude Code]] 的草稿生成迁移，并确保草稿由 Claude Code 直接写文件而不是通过对话回读。
2. 用真实 review 数据跑通一次新的 draft → final handoff 验证，确认 cron、草稿文件、`draft-ready.json`、终稿编排之间的衔接都已恢复到可用状态。
3. 收尾自动链基线：提交 Claude Code 迁移改动、清理剩余历史噪声 artifacts，并决定是否正式停用 [[Antigravity]] 相关草稿路径与文档表述。
