class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands" # 替换为你的主页 URL
  url "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands/auto-commit.sh" # 替换为你的脚本 URL
  version "1.0.0"
  sha256 "af8b26ec4a02147be4bc5e4b3be7bd19348edaa364f3bb6a3b73ab714de68587" # 替换为你的脚本的 SHA256 校验和

  def install
    bin.install "auto-commit.sh" => "ait" # 将脚本安装为 ait
    chmod 0755, bin/"ait" # 确保脚本是可执行的
  end

  test do
    system "#{bin}/ait", "--version" # 测试命令
  end
end