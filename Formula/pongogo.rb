class Pongogo < Formula
  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/3d/fd/c6ad62dced0f55184661dfbdb27f2bdea7a4de3a177f2798cce1b7b67f7b/pongogo-0.3.76.tar.gz"
  sha256 "57118faa7a664c0b5185116976d971f74cfb85aafecd2f79e88d9dbaa27652fa"
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
