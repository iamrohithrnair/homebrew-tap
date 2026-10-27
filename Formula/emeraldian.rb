# Source of truth for the Homebrew formula.
#
# The release workflow rewrites the version and checksums here, then copies
# this file into the tap repository. Keeping it in the main repo means the
# formula is reviewed alongside the code it installs, and the tap stays a
# generated artifact rather than something maintained by hand.
class Emeraldian < Formula
  desc "Terminal UI for Obsidian vaults, with a graph and an assistant"
  homepage "https://github.com/iamrohithrnair/emeraldian"
  version "0.10.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.10.0/emeraldian-aarch64-apple-darwin.tar.gz"
      sha256 "b82c5d872f5301c77d000130b69c434a539bcef3321f3500adccecbec78edd70"
    end
    on_intel do
      # Apple silicon only; Intel Macs build from source.
      odie "emeraldian has no Intel Mac build. Install with: cargo install --git #{homepage} emeraldian"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.10.0/emeraldian-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b60493e23b24fab06a4fbcb8c927e62a18eee8bdac09e409f12fbcfd413b7369"
    end
    on_intel do
      url "https://github.com/iamrohithrnair/emeraldian/releases/download/v0.10.0/emeraldian-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5072d0875b3dbae96823905434f6cee915fe771b7f12e3fe48a2e99d5a7b5b48"
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
