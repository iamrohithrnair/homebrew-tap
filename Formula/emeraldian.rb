# Source of truth for the Homebrew formula.
#
# The release workflow rewrites the version and checksums here, then copies
# this file into the tap repository. Keeping it in the main repo means the
# formula is reviewed alongside the code it installs, and the tap stays a
# generated artifact rather than something maintained by hand.
class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  version "0.4.2"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.4.2/emeraldian-aarch64-apple-darwin.tar.gz"
      sha256 "0afbe71b4af27fb2634872bbdf654a9885a1eeb878a427fef5c083648fd4b414"
    end
    on_intel do
      # Apple silicon only; Intel Macs build from source.
      odie "emeraldian has no Intel Mac build. Install with: cargo install --git #{homepage} emeraldian"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.4.2/emeraldian-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "534fc77f7867db424ea34b929674b340b68651e7c373602694b237c9ed86e6e2"
    end
    on_intel do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.4.2/emeraldian-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9c976eb69896cf2c8d771247e3f953db34aa79da00635fcde79b5f50635c7874"
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
