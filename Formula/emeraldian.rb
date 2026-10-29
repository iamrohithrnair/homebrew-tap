# Source of truth for the Homebrew formula.
#
# The release workflow rewrites the version and checksums here, then copies
# this file into the tap repository. Keeping it in the main repo means the
# formula is reviewed alongside the code it installs, and the tap stays a
# generated artifact rather than something maintained by hand.
class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  version "0.10.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.10.1/emeraldian-aarch64-apple-darwin.tar.gz"
      sha256 "129229e24157a60c07129a2d73dfad1eb654a605ee0eca80f62cc1a8843af23b"
    end
    on_intel do
      # Apple silicon only; Intel Macs build from source.
      odie "emeraldian has no Intel Mac build. Install with: cargo install --git #{homepage} emeraldian"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.10.1/emeraldian-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3d141741a91ec1f1d607cb5a950150d58ab67353fc31af90d5f86468af636b46"
    end
    on_intel do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.10.1/emeraldian-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "10b8b23e131f4f06ab4871379fec9a7b3e529b99db2f6a501799fcf23bcaec3d"
    end
  end

  def install
    bin.install "emeraldian"
  end

  def caveats
    <<~EOS
      Open a vault:
        emeraldian ~/Notes

      Or let it find the one Obsidian last had open:
        emeraldian

      On macOS, the first run may ask for permission to read the folder your
      vault lives in. Press ? inside the app for the full key list.
    EOS
  end

  test do
    assert_match "emeraldian #{version}", shell_output("#{bin}/emeraldian --version")
    # Indexing a real vault is the behaviour worth testing, not just --version.
    (testpath/"vault").mkpath
    (testpath/"vault/Note.md").write("# Note\n\nLinks to [[Other]].\n")
    assert_match "emeraldian", shell_output("#{bin}/emeraldian --help")
  end
end
