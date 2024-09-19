class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages and changelogs"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/ait.sh"
  version "1.1.2"
  sha256 "0a511c4441c1549d4aaf340b539d52c17f143bb3202ddd6e81b5616cdbf7c350"

  def install
    bin.install "ait.sh" => "ait"
    chmod 0755, bin/"ait"
  end

  test do
    system "#{bin}/ait", "review"
    system "#{bin}/ait", "commit"
  end
end