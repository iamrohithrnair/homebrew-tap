# Source of truth for the Homebrew formula.
#
# The release workflow rewrites the version and checksums here, then copies
# this file into the tap repository. Keeping it in the main repo means the
# formula is reviewed alongside the code it installs, and the tap stays a
# generated artifact rather than something maintained by hand.
class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  version "0.5.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.5.0/emeraldian-aarch64-apple-darwin.tar.gz"
      sha256 "5b3328bb3a97b49ab208d22a77a2d4ec7ccb322d92cb19709d45ba363eacfd28"
    end
    on_intel do
      # Apple silicon only; Intel Macs build from source.
      odie "emeraldian has no Intel Mac build. Install with: cargo install --git #{homepage} emeraldian"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.5.0/emeraldian-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "7873bd9b1c505471dfe0b1dfb8c583ec079bf4163709eb7c0b2ade891fd94bba"
    end
    on_intel do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.5.0/emeraldian-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "9926ce69dfb86e8ef604605f23f8a14e37bb59e76d9bd08b34eac63899214ad0"
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
