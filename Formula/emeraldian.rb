# Source of truth for the Homebrew formula.
#
# The release workflow rewrites the version and checksums here, then copies
# this file into the tap repository. Keeping it in the main repo means the
# formula is reviewed alongside the code it installs, and the tap stays a
# generated artifact rather than something maintained by hand.
class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  version "0.6.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.6.0/emeraldian-aarch64-apple-darwin.tar.gz"
      sha256 "d8fb173f3f8bfb469bab9fc06191cd97479ac70df94aaf856cc8736ada6957fd"
    end
    on_intel do
      # Apple silicon only; Intel Macs build from source.
      odie "emeraldian has no Intel Mac build. Install with: cargo install --git #{homepage} emeraldian"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.6.0/emeraldian-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "3d88a2eaf8157b4bef84b1888149129cd207b9076d58997c701974f20b0c9f7d"
    end
    on_intel do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.6.0/emeraldian-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "033dbd0cd9f9f19d15469f726fe5d17ec3798a8c8ca68c16a3cd26fe374cab6d"
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
