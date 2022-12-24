#!/usr/bin/env ruby
# coding: utf-8

f = File.open("revision_skeleton.md")
o = File.open("book_revision.md", "w")
f.each_line{|line|
  if line =~ /revision:/ then
    message = line.gsub('- revision:','').gsub(/^ +/, '').gsub(/\n/, '')
    puts message
    command = "cd ../llvm-myriscvx120 && git log --oneline --grep=\"#{message}\""
    git_log = `#{command}`
    revision = git_log.split(' ')[0]
    puts revision
    o.puts line.gsub(/revision:.+/, "`#{revision.to_s}`")
  else
    o.puts line
  end
}
