#!/bin/bash
Environment=$1
StackName=$2
REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws secretsmanager --region ${REGION}  describe-secret --secret-id "/${Environment}/${StackName}/kotsadm/password" --no-paginate --query Tags|jq -c .[] > tags-v2
FILE=tags-v2
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


echo -n > extra_tags-v2
for key in "${!tagsArray[@]}"
do
  if [[ ! -z "$key" ]]; then
    echo Key=$key,Value=${tagsArray[$key]} >> extra_tags-v2
  fi
done
if [ -s "$FILE" ]; then
  readarray -t ARRAY < extra_tags-v2; IFS=' '
fi
  EXTRA_TAGS="${ARRAY[*]}"

echo -n "$EXTRA_TAGS"
