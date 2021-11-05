#!/bin/bash
Environment=$1
StackName=$2
REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
aws secretsmanager --region ${REGION}  describe-secret --secret-id "/${Environment}/${StackName}/kotsadm/password" --no-paginate --query Tags|jq -c .[] > tags
FILE=tags
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


echo -n > extra_tags
for key in "${!tagsArray[@]}"
do
  if [[ ! -z "$key" ]]; then
    echo $key=${tagsArray[$key]} >> extra_tags
  fi
done
FILE=extra_tags
if [ -s "$FILE" ]; then
  readarray -t ARRAY < extra_tags; IFS=','
fi
  EXTRA_TAGS="${ARRAY[*]}"

echo -n "$EXTRA_TAGS"
