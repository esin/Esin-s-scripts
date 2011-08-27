#!/bin/bash

export CONSUMER_SECRET="KmnQGvPe2jXTGQzzzMciVJZ6W5nWWTWNOQKQfwRdg"
export CONSUMER_KEY="wgjRDmGgyZPBZVZZxnE9lA"

stupid_enc()
{
  echo $(echo -n "$1" | sed -e 's/+/%2B/g' -e 's/\//%2F/g' -e 's/\=/%3D/g')
}

secs()
{
  echo $(date +%s)
}

nonce()
{
 echo $(date +%s%N | md5sum | cut -d' ' -f1)
# echo $RANDOM$(date +%N)
}

enter_pin()
{
  echo "Open your browser at: https://api.twitter.com/oauth/authorize?oauth_token="$OAUTH_INIT_TOKEN
  echo -n "Enter PIN code from browser: "
  read pin_code
  if [ ! -n "$pin_code" ]; then enter_pin; fi
  export INIT_PIN_CODE="$pin_code"
  return 0
}

request_init_tokens()
{

  time_stamp=$(secs)
  on=$(nonce)
  sign=$(echo -en "POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Frequest_token&%3D%26oauth_callback%3Doob%26oauth_consumer_key%3D$CONSUMER_KEY%26oauth_nonce%3D$on%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D$time_stamp%26oauth_version%3D1.0" | openssl dgst -sha1 -binary -hmac  "$CONSUMER_SECRET&" | base64)

  reply=$(curl --compressed -s -N 'https://api.twitter.com/oauth/request_token' -H "Authorization: OAuth oauth_consumer_key=\"$CONSUMER_KEY\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"$(stupid_enc $sign)\", oauth_timestamp=\"$time_stamp\", oauth_nonce=\"$on\", oauth_version=\"1.0\"" -d '=&oauth_callback=oob')

  if [ $(echo "$reply" -eq 0) ]; then
   echo "Request token error: "$reply
   return 1; 
  fi

  export OAUTH_INIT_TOKEN=$(echo -n $reply | tr '&' '\n' | grep "oauth_token=" | sed -n 's/^.*=\(.*\)/\1/p')
  export OAUTH_INIT_TOKEN_SECRET=$(echo -n $reply | tr '&' '\n' | grep "oauth_token_secret=" | sed -n 's/^.*=\(.*\)/\1/p')
#  export OAUTH_INIT_CALLBACK_CONFIRMED=$(echo -n $reply | tr '&' '\n' | grep "oauth_callback_confirmed=" | sed -n 's/^.*=\(.*\)/\1/p')
  enter_pin
}

request_access_tokens()
{
  sign=$( echo -en "POST&https%3A%2F%2Fapi.twitter.com%2Foauth%2Faccess_token&%3D%26oauth_consumer_key%3D$CONSUMER_KEY%26oauth_nonce%3D$(nonce)%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D$(secs)%26oauth_token%3D$OAUTH_INIT_TOKEN%26oauth_verifier%3D$INIT_PIN_CODE%26oauth_version%3D1.0" | openssl dgst -sha1 -binary -hmac  "$CONSUMER_SECRET&$OAUTH_INIT_TOKEN_SECRET" | base64)

  reply=$(curl --compressed -s -N 'https://api.twitter.com/oauth/access_token' -H "Authorization: OAuth oauth_consumer_key=\"$CONSUMER_KEY\", oauth_token=\"$OAUTH_INIT_TOKEN\", oauth_signature_method=\"HMAC-SHA1\", oauth_signature=\"$(stupid_enc $sign)\", oauth_timestamp=\"$(secs)\", oauth_nonce=\"$(nonce)\", oauth_version=\"1.0\"" -d "=&oauth_verifier=$INIT_PIN_CODE")
  
  unset INIT_PIN_CODE
  unset OAUTH_INIT_TOKEN_SECRET 
  unset OAUTH_INIT

  export OAUTH_TOKEN=$(echo -n $reply | tr '&' '\n' | grep "oauth_token=" | sed -n 's/^.*=\(.*\)/\1/p')
  export OAUTH_TOKEN_SECRET=$(echo -n $reply | tr '&' '\n' | grep "oauth_token_secret=" | sed -n 's/^.*=\(.*\)/\1/p')
  export USER_ID=$(echo -n $reply | tr '&' '\n' | grep "user_id=" | sed -n 's/^.*=\(.*\)/\1/p')
  export SCREEN_NAME=$(echo -n $reply | tr '&' '\n' | grep "screen_name=" | sed -n 's/^.*=\(.*\)/\1/p')
  echo $OAUTH_TOKEN $OAUTH_TOKEN_SECRET
}

request_init_tokens
request_access_tokens


# enc()
# {
# url=$(echo -n "$1" | sed -e 's/%/%25/g' -e 's/ /%20/g' -e 's/!/%21/g' -e 's/"/%22/g' -e 's/#/%23/g' -e 's/\$/%24/g' -e 's/\&/%26/g' -e 's/'\''/%27/g' -e 's/(/%28/g' -e 's/)/%29/g' -e 's/\*/%2a/g' -e 's/+/%2B/g' -e 's/,/%2c/g' -e 's/-/%2d/g' -e 's/\./%2e/g' -e 's/\//%2F/g' -e 's/:/%3a/g' -e 's/;/%3b/g' -e 's//%3e/g' -e 's/?/%3f/g' -e 's/@/%40/g' -e 's/\[/%5b/g' -e 's/\\/%5c/g' -e 's/\]/%5d/g' -e 's/\^/%5e/g' -e 's/_/%5f/g' -e 's//%60/g' -e 's/{/%7b/g' -e 's/|/%7c/g' -e 's/}/%7d/g' -e 's/~/%7e/g' -e 's/\=/%3D/g')
# echo $url
# }
