class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/68/99/3289fa0b446357afbfac7288865ed947884e880ee766600ef5fd920c43ce/pongogo-0.3.29.tar.gz"
  sha256 "1ac8f96b1b9323902204826bd71d0e77846f06aad6a508ff6b89143644534190"
  license "MIT"

  depends_on "python@3.12"

  def install
    python3 = "python3.12"

    # Create virtualenv
    system python3, "-m", "venv", libexec

    # Install package with all dependencies from PyPI
    system libexec/"bin/pip", "install", "pongogo==#{version}"

    # Remove unused cryptography Rust extension to prevent Homebrew
    # dylib fixup errors on macOS (insufficient Mach-O header padding).
    # Dependency chain: fastmcp -> authlib -> cryptography.
    # Pongogo does not use any authentication features from fastmcp.
    system libexec/"bin/pip", "uninstall", "-y",
      "cryptography", "cffi", "pycparser"

    # Move Python native extension .so files OUT of the Cellar tree
    # to prevent Homebrew's dylib fixup from processing them.
    # Homebrew scans ALL files by Mach-O magic bytes (not extension),
    # so files must be physically outside the Cellar during fixup.
    # PyPI wheels (esp. Rust-built pydantic_core) have minimal
    # Mach-O header padding; Homebrew's long Cellar path rewrite fails.
    # Python uses dlopen() so dylib IDs are irrelevant.
    # Restored in post_install (which runs after fixup).
    staging = Pathname.new(Dir.tmpdir)/"pongogo-brew-staging-#{version}"
    staging.mkpath
    Dir.glob(libexec/"lib/**/*.so") do |f|
      rel = Pathname.new(f).relative_path_from(libexec)
      target = staging/rel
      target.dirname.mkpath
      FileUtils.mv(f, target)
    end

    # Link the entry point scripts to bin
    bin.install_symlink Dir[libexec/"bin/pongogo*"]
  end

  def post_install
    # Restore .so files from staging (moved out during install
    # to bypass Homebrew's Mach-O dylib fixup)
    staging = Pathname.new(Dir.tmpdir)/"pongogo-brew-staging-#{version}"
    if staging.exist?
      Dir.glob(staging/"**/*.so") do |f|
        rel = Pathname.new(f).relative_path_from(staging)
        target = libexec/rel
        target.dirname.mkpath
        FileUtils.mv(f, target)
      end
      staging.rmtree
    end
  end

  test do
    system "#{bin}/pongogo", "--version"
  end
end
