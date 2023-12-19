
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
  local directory=${1:-"/var/nginx/"}
  local password=7307969xd
  
  sshpass -p $password ssh -o StrictHostKeyChecking=no -t $user@$ip "cd $directory; exec \$SHELL"
  # ssh -t $user@$ip "cd $directory; exec \$SHELL"
}
