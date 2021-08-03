
#! /usr/bin/ruby

MESSAGE = ARGV.first

system('git status -s')
puts "----> Start upload to github"
system('git commit -am "${MESSAGE}"')
system("git pull --rebase && git push origin main")
