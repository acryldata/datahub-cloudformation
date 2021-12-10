#!/bin/bash
Environment=$1
StackName=$2
REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws secretsmanager --region ${REGION}  describe-secret --secret-id "/${Environment}/${StackName}/kotsadm/password" --no-paginate --query Tags|jq -c .[] > tags-v3
FILE=tags-v3
declare -A tagsArray
while IFS= read -r line
  do
    key=$(echo "$line"|jq .Key|tr -d '"')
    value=$(echo "$line"|jq .Value|tr -d '"')
      if [[ "${key,,}" == *"cloudformation"* ]];then
        continue
    else
      tagsArray[$key]=$value
    fi
done <$FILE


echo -n > extra_tags-v3
for key in "${!tagsArray[@]}"
do
  if [[ ! -z "$key" ]]; then
    echo "{\"Key\":\"$key\",\"Value\":\"${tagsArray[$key]}\"}," >> extra_tags-v3
  fi
done
FILE=extra_tags-v3
if [ -s "$FILE" ]; then
  readarray -t ARRAY < extra_tags-v3;
fi
  EXTRA_TAGS="${ARRAY[*]}"
  EXTRA_TAGS_NEW=${EXTRA_TAGS::-1}

echo -n "[$EXTRA_TAGS_NEW]"
