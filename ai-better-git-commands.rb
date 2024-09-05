class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages and changelogs"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/ait.sh"
  version "1.1.0"
  sha256 "22958298b4f1176e96f106fd588a714c5092a2db54c564b65d35f75d3315ecf9"

  def install
    bin.install "ait.sh" => "ait"
    chmod 0755, bin/"ait"
  end

  test do
    system "#{bin}/ait", "review"
    system "#{bin}/ait", "commit"
  end
end