
function run_roger_api {
  export TWILIO_AUTH_TOKEN=6fe113093f0e40265f93d8b96f3bee16                                                                             
  export TWILIO_ACCT_SID=AC34af568071949f09acdeefacf038ad65
  export TWILIO_NUM=+15005550006
  export MAILCHIMP_API_KEY=f8e893bedcf96d4929c984bf6a6a6db8-us21
  export MAILCHIMP_LIST_ID="b8c43dd0e0"
  export ADMIN_PASS="snowforever"
  export SUPER_ADMIN_PASS="81Linden"
  yarn api
}

function run_roger_dashboard {
  export NODE_ENV=development                                                                                                   
  export NX_TWILIO_NUM=+15005550006
  yarn dashboard
}

function thanos {
  local user=avelazco
  local ip=thanos
  local directory=${1:-"/var/node/"}
  local password=7307969xd
  local command=${2:-"ls -la"}  # Establece un comando por defecto si no se proporciona uno
  
  sshpass -p $password ssh -o StrictHostKeyChecking=no -t $user@$ip "cd $directory; $command; exec \$SHELL"
  # ssh -t $user@$ip "cd $directory; exec \$SHELL"
}



function tulandia {
  local directory="/var/www/html/tulandia/landing/logs"
  thanos $directory $1
}

function opratel-api {
local directory="/var/www/html/api/stable/storage/logs"
thanos $directory $1
}

function tulandia-api {
local directory="/var/www/html/tulandia/api/logs"
thanos $directory $1
}

function wsclaroch {
  local directory="/var/nginx/wsclaroch/logs"
  thanos $directory $1
}


function master-billing-dispatcher {
  local directory="/var/node/master-billing-dispatcher/logs"
  thanos $directory $1
}

# cat server_claroch.log | grep -a '2024-01-02' > test.log
# tail -n 300 | grep -a 'hello'
#
#
#
# /var/node/claroch 
#
#
# command status 0 = cobro existoso

function claroch-billing {
  local directory="/var/node/clarochBWG/logs"
  thanos $directory $1
}

function master-billing-dispatcher-logs {
  local msisdn=$1
  local date=$2
  master-billing-dispatcher "cat claroch_access.log | grep -a $date | grep $msisdn"
}
