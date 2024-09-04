class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages and changelogs"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/main.sh"
  version "1.0.0"
  sha256 "db2d25412aa418ba824c5f00a79f016f921c0fae36a74d8836175760be16c4e6" # 请替换为 main.sh 的实际 SHA256 值

  def install
    bin.install "main.sh" => "ait" # 将主要脚本安装为 ait
    bin.install "get_changelog.sh" => "get_changelog" # 安装 get_changelog.sh
    bin.install "get_commit_message.sh" => "get_commit_message" # 安装 get_commit_message.sh
    chmod 0755, bin/"ait" # 确保脚本是可执行的
    chmod 0755, bin/"get_changelog" # 确保脚本是可执行的
    chmod 0755, bin/"get_commit_message" # 确保脚本是可执行的
  end

  test do
    system "#{bin}/ait", "review" # 测试变更日志命令
    system "#{bin}/ait", "commit" # 测试提交信息命令
  end
end