# frozen_string_literal: true

require "tempfile"

RSpec.describe Cr::Exec do
  it "has a version number" do
    expect(Cr::Exec::VERSION).not_to be nil
  end

  it "print lines" do
    Cr::Exec.run("sudo apt update")
  end

  it "return 0" do
    expect(Cr::Exec.code("uname")).to eq 0
  end

  it "accept multi string" do
    expect(Cr::Exec.code("uname -s")).to eq 0
  end

  it "return 127" do
    expect(Cr::Exec.code("unamea")).to eq 127
  end

  it "get Linux" do
    expect(Cr::Exec.output("uname")).to eq "Linux"
  end

  it "get Linux\n" do
    expect(Cr::Exec.output("uname", chomp: false)).to eq "Linux\n"
  end

  it "log to file" do
    tempfile = Tempfile.new(["test_", ".log"])
    Cr::Exec.run("uname", out: File.open(tempfile.path, "a+"))

    expect(tempfile.readlines).to eq ["Linux\n"]
    tempfile.delete
  end

  it "list file" do
    expect(Cr::Exec.each_line("ls spec")).to eq ["cr\n", "spec_helper.rb\n"]
  end

  it "list file with option" do
    expect(Cr::Exec.each_line("ls spec", chomp: true)).to eq ["cr", "spec_helper.rb"]
  end

  it "each_line with options" do
    expect(Cr::Exec.each_line("ls", chomp: true, chdir: "spec")).to eq ["cr", "spec_helper.rb"]
  end

  it "each_line with ENV" do
    expect(Cr::Exec.each_line({ "FOO" => "bar" }, "echo $FOO", chomp: true)).to eq ["bar"]
  end

  it "answer no need input" do
    expect(Cr::Exec.answer("uname", "r+")).to eq "Linux\n"
  end

  it "answer with cmd" do
    expect(Cr::Exec.answer("bash", "r+", input: "uname")).to eq "Linux\n"
  end

  it "answer with cmd array" do
    expect(Cr::Exec.answer("bash", "r+", input: %w[uname uname])).to eq "Linux\nLinux\n"
  end

  it "answer with space included cmd array" do
    expect(Cr::Exec.answer("bash", "r+", input: ["ls spec", "uname"])).to eq "cr\nspec_helper.rb\nLinux\n"
  end

  it "answer with ruby embbed cmd" do
    expect(Cr::Exec.answer("bash", "r+", input: "echo #{Array(1..5)}")).to eq "[1, 2, 3, 4, 5]\n"
  end

  it "answer with ruby array" do
    expect(Cr::Exec.answer("bash", "r+", input: Array.new(2, "uname"))).to eq "Linux\nLinux\n"
  end

  it "always return bool" do
    p system("unamea")
    expect(Cr::Exec.system?("unamea")).to eq false
  end
end
