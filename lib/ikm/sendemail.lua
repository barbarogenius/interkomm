module("ikm.sendemail", package.seeall)

--- this is just a sketch from an old file, not used yet

function send(options,msg)

sendemail_cmd = "sendEmail"

local cmd = [[sendEmail -t ]]..options.rcpt..[[ -o tls=yes -o fqdn=mail.plentyfact.org -u \"]]..msg.subject..[[\" 
              -f ]]..options.user..[[ -xp ]]..options.password..[[ -s ]]..options.server..[[:465 
              -m  \"]]..msg.body..[[\" ]]

os.execute(ikm.core.prepare(cmd))

end




