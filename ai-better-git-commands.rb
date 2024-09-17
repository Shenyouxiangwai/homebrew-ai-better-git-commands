class AiBetterGitCommands < Formula
  desc "A script to automate git commit messages and changelogs"
  homepage "https://github.com/Shenyouxiangwai/homebrew-ai-better-git-commands"
  url "https://raw.githubusercontent.com/Shenyouxiangwai/homebrew-ai-better-git-commands/main/ait.sh"
  version "1.1.1"
  sha256 "ac131fcbdd6a9cd6b3c8f7c0d0dab356b9297a9d634124ba7534f739a8d189a9"

  def install
    bin.install "ait.sh" => "ait"
    chmod 0755, bin/"ait"
  end

  test do
    system "#{bin}/ait", "review"
    system "#{bin}/ait", "commit"
  end
end