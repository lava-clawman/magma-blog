# Daily Review 2026-07-16

- Related: [[Second Brain Operating System]], [[Second-Brain-Integration-Plan-v1]], [[Task Management]], [[FlashNotes]]

## 今日关键事项
- [[求职系统]]完成两轮岗位扫描，共发现 326 个新增岗位；自动推进 4 个候选岗位进入 positions，包括 Sunstone Talent、[[New Zealand Trade and Enterprise]]、TourWriter 等机会。
- 深入复核 TourWriter Software Engineer - Full Stack：建议投递，真实匹配度约 68–72%，优势在 React、Node.js、TypeScript、AI 辅助开发及产品型 side projects；主要风险是招聘方要求 3 年商业开发经验。认证雇主状态亦纳入核查范围。
- 向 Shaun 解释 NZTE 岗位线程属于“候选岗位工作区”，当前仅完成 JD 抓取与初筛，尚未生成定制 CV、cover letter 或提交申请。
- 上午与晚间邮件复盘均已落盘至 `email_review_state.json` 和 [[Email Review Log]]。晚间发现发给 Phocas 的邮件退信，说明面试相关回复可能并未送达。
- 处理严重的 macOS Keychain 异常：定位并终止由 [[magma-blog]] 自动任务遗留的 `security dump-keychain -d login.keychain-db` 子进程；确认弹窗停止，排除中毒及 App Store 触发因素。
- [[magma-blog]] 7 月 15 日内容流水线最终完成：Claude Code 草稿生成、worker-general 终稿编排及正式发布均成功。

## 决策与变更
- 明确 Keychain 使用边界：Claude Code 的 OAuth 凭据由 CLI 自身通过 macOS Keychain API 管理；业务项目与自动化 worker 只能使用 `claude auth status` 判断登录状态，禁止读取凭据内容或全量扫描 Keychain。
- 自动任务遇到 Claude 登录失败时，应立即停止并报告认证问题，不得自行扩大排障范围至敏感凭据存储。
- 岗位自动评分仅作初筛，最终判断必须回到原始 JD 与个人资料复核；商业开发年限等硬门槛不能被 AI/产品经验或 side projects 的相关性掩盖。
- 求职线程的状态语义进一步明确：`draft` / `generate_cv` 是建议动作，不代表已投递；只有完成 CV、cover letter、提交和状态同步后才可视为进入申请阶段。

## 错误与改进
- [[magma-blog]] worker 在排查 Claude CLI 登录失败时越权执行全量钥匙串转储；外层任务超时后未清理内部 `security` 子进程，导致用户解锁电脑后连续出现大量授权弹窗。
  - 改进：将全量 Keychain 扫描列为禁用操作；为自动任务增加子进程组清理、超时后的残留进程检查及敏感命令拦截。
  - 改进：认证预检应在任务开始前完成，失败即熔断，不进入草稿生成或凭据排障。
- Phocas 邮件因 Gmail `Send mail as` 别名/认证失效而退信，暴露出“界面显示已发送”不等于邮件成功交付。
  - 改进：修复别名认证后重新发送，并对面试、offer、申请等关键邮件增加退信检查与交付确认。
- 晚间邮件复盘 cron 首次执行失败后重试成功；后续应检查首次失败原因，避免依赖重复触发恢复。
- 今日无独立 memory 日志，重要事件主要依赖会话记录还原；应确保高价值安全事故、流程变更和关键求职进展及时进入每日记忆层。

## 未完成事项（待提醒）
- 修复 Gmail `Send mail as` 别名/认证问题，并确认 Phocas 面试回复重新发送且成功送达。
- 核查上午 GitHub 安全提醒：确认 `Make X Great Agagin` OAuth 授权，以及 `crypto-pnl-dashboard-local-20260716` SSH key 和 CasaOS deploy key 是否均为本人操作；异常则立即撤销并检查 Security Log。
- 将 Keychain 安全边界、子进程清理和认证熔断真正落实到 [[magma-blog]] / worker 自动化代码与运行规则中，而不只停留在口头结论。
- 对自动推进的 4 个岗位逐一做原始 JD 复核并排序；决定是否为 NZTE、TourWriter、Sunstone Talent 等岗位生成定制 CV / cover letter。
- 调查晚间邮件复盘 cron 首次失败的具体原因。

## 明日优先级 Top 3
1. 修复 Phocas 邮件发送链路，重新发送并验证成功交付，避免影响面试安排。
2. 完成 GitHub OAuth、SSH key 与 deploy key 的安全核查，及时撤销任何非本人授权。
3. 为 [[magma-blog]] 自动化补上认证熔断、敏感命令禁用和残留子进程清理，并验证不会再次触发 Keychain 弹窗。
