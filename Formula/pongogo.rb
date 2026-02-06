class Pongogo < Formula
  include Language::Python::Virtualenv

  desc "AI agent knowledge routing for Claude Code"
  homepage "https://pongogo.com"
  url "https://files.pythonhosted.org/packages/b4/ae/577ebb0d225fd1ea1252f4abe5baa176398e02eeb2e20d7bb8e1ce78041c/pongogo-0.2.3.tar.gz"
  sha256 "708cbe0c77ebe53db71476fd56df4d547ec819e733bb9b2505e494b9a4e485a1"
  license "MIT"

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/pongogo", "--version"
  end
end
