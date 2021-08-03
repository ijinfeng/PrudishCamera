
#! /usr/bin/ruby

MESSAGE = ARGV.first

if MESSAGE.nil?
    MESSAGE = "update"
end

system('git status -s')
puts "----> Start upload to github \n"
system('git add .')
system("git commit -m '${MESSAGE}'")
system("git pull --rebase && git push origin main")
