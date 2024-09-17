class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages and changelogs"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/ait.sh"
  version "1.1.1"
  sha256 "2902a79ec6c6c8837520b472ba2bd0edfe5f2d33720e8ac0371d3a4a2394c395"

  def install
    bin.install "ait.sh" => "ait"
    chmod 0755, bin/"ait"
  end

  test do
    system "#{bin}/ait", "review"
    system "#{bin}/ait", "commit"
  end
end