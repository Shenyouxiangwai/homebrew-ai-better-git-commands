class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages and changelogs"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/main.sh"
  version "1.0.0"
  sha256 "43aff44ad030b22fd2281acdf24e63640e14224eda020dedcb5b34ca5d3847da"

  def install
    bin.install "main.sh" => "ait" # 将主要脚本安装为 ait
    chmod 0755, bin/"ait" # 确保脚本是可执行的
  end

  test do
    system "#{bin}/ait", "review" # 测试变更日志命令
    system "#{bin}/ait", "commit" # 测试提交信息命令
  end
end