
#! /usr/bin/ruby

message = ARGV.first

if message.nil?
    message = "update"
end

system('git status -s')
puts "----> Start upload to github"
system('git add .')
system("git commit -m \"#{message}\"")
system("git pull --rebase && git push origin main")
