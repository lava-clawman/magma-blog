# Daily Review 2026-03-31

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- 明确了 Discord / channel 长期职责配置策略：不把大量频道级规则塞进 main agent，而是优先用“频道绑定专门 agent / 专门 workspace”的方式保持边界清晰。
- 识别并修复了 [[Claude Code]] 在项目仓库内启动时与 SSH passphrase 提示抢占同一终端交互的问题，根因锁定为 Git SSH key 未稳定进入 `ssh-agent` / keychain 链路。
- 实际整理并重写了 `~/.ssh/config`，统一了 GitHub 多身份 host alias 与 key 映射关系，并保留了现有 GCP / Aliyun 跳板相关配置。
- 对 [[axios]] 恶意版本事件做了本机项目对照排查；当前已扫描到的项目未命中通报中的恶意版本，也未发现 `plain-crypto-js` 痕迹。

## 决策与变更
- 决定保持 main agent 轻量、通用、干净，不将其演化成承载大量频道条件分支的“路由总表”。
- 明确频道治理原则：
  - 长期固定职责、需要跨 session 稳定保留设定的频道 → 独立 agent。
  - 临时 / 综合 /轻量频道 → 继续走 main。
- SSH 配置层面完成一次实际收口：
  - 统一 `github.com`、`github-web3flashme` 等 GitHub 身份映射。
  - 补入 `IdentitiesOnly yes`、`AddKeysToAgent yes`、`UseKeychain yes` 这一类稳定项。
  - 修掉了旧配置中混杂 GitHub 与内网主机规则的脏写法。
- 针对供应链安全事件，形成了新的检查思路：先对照恶意版本号与可疑依赖，再看 lockfile / cache / 安装痕迹，而不是泛泛地做“是否用了 axios”的模糊判断。

## 错误与改进
- 问题：只靠 main agent 承载不同 channel 的长期职责，容易在 `/new`、上下文压缩、恢复或 fallback 后丢失最初设定。
  - 改进：把稳定职责下沉到专门 agent / workspace，而不是继续堆积在 main 的 md 文件中。
- 问题：[[Claude Code]] 在 SSH remote 仓库中启动时，会因底层 Git/SSH 触发 passphrase 交互，和 TUI 抢占同一终端输入。
  - 改进：通过规范 `~/.ssh/config` 与 key 管理方式，恢复 keychain / agent 的稳定行为。
- 问题：原 SSH 配置中存在 alias 命名不一致、规则块混杂、主机配置脏化的问题，导致行为不透明。
  - 改进：备份旧配置后重写，验证 `ssh -G` 输出，确保 host alias 与实际 remote 一致。
- 问题：面对 [[axios]] 安全事件，单看文章无法判断自身是否受影响。
  - 改进：已建立本机实际依赖树排查路径，并完成一轮初步核查。

## 未完成事项（待提醒）
- 继续做一轮更彻底的 [[axios]] 事件补充排查：
  - npm cache
  - 全量 lockfile
  - 历史安装痕迹 / 攻击窗口内的安装行为
- 对 Discord 现有频道做一次“是否值得拆专门 agent”的清单化判断，而不是继续停留在抽象讨论。
- 验证 SSH 新配置在新 terminal / 新 tmux pane / 不同仓库中的长期稳定性，确认问题不是仅在当前会话内暂时消失。
- 视实际使用情况决定是否为常用编码仓库补一个更顺手的启动封装（如预热 key 的 alias / function）。

## 明日优先级 Top 3
1. 完成 Discord 频道分层：明确哪些频道保留在 main，哪些拆成独立 agent。
2. 对 [[axios]] 恶意版本事件做补充排查，覆盖 lockfile、npm cache 与历史安装痕迹。
3. 复测 SSH / Git / [[Claude Code]] 链路在新终端与常用项目中的稳定性，确认修复真正闭环。
