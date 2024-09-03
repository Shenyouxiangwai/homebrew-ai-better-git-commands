class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/auto-commit.sh"
  version "1.0.0"
  sha256 "af8b26ec4a02147be4bc5e4b3be7bd19348edaa364f3bb6a3b73ab714de68587"

  def install
    bin.install "auto-commit.sh" => "ait" # 将脚本安装为 ait
    chmod 0755, bin/"ait" # 确保脚本是可执行的
  end

  test do
    system "#{bin}/ait", "--version" # 测试命令
  end
end