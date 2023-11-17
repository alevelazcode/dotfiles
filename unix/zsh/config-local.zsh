
function run_roger_api {
  export TWILIO_AUTH_TOKEN=6fe113093f0e40265f93d8b96f3bee16                                                                             
  export TWILIO_ACCT_SID=AC34af568071949f09acdeefacf038ad65
  export TWILIO_NUM=+15005550006
  export MAILCHIMP_API_KEY=f8e893bedcf96d4929c984bf6a6a6db8-us21
  yarn api
}

function run_roger_dashboard {
  export NODE_ENV=development                                                                                                   
  export NX_TWILIO_NUM=+15005550006
  yarn dashboard
}
