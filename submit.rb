
#! /usr/bin/ruby

message = ARGV.first

if message.nil?
    message = "update"
end

system('git status -s')
puts "\033[37m----> Start upload to github\033[0m"
system('git add .')
system("git commit -m \"#{message}\"")
system("git pull --rebase && git push origin main")
