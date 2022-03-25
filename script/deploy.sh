# #!/bin/bash
sam build && 
sam deploy --config-env default --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND --no-confirm-changeset
