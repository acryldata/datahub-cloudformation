import jwt
import os
import datetime
import sys

secret = os.environ['API_KEY_SECRET']
if not secret or len(secret) == 0:
  print("No secret found. Exiting..")
  sys.exit()
six_months_ms = 15778800000 # token must be re-generated after 6 months
expiration_date = datetime.datetime.now(tz=datetime.timezone.utc) + datetime.timedelta(milliseconds=six_months_ms)
payload = { "v": 0, "permissions": [ "ALLOW_ALL" ], "type": "api", "exp": expiration_date, "iss": "admin.acryl.io" }
encoded = jwt.encode(payload, secret, algorithm="HS256")
print("Successfully generated authentication token for DataHub API Gateway: {}".format(encoded))
