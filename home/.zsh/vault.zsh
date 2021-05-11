#! /usr/local/bin/zsh
# Vault & AWS account login script
# Useage: <this_script> [username2]
#   __           _               _             _
#  /  \ ____ ___| |    ___ ___ _| |_ _ __ _  _| |_  __  _ __
# | /\ |  __| __| |___/ _ \ __|_   _| '__|_ \_   ()/__\|  _ \
# | \/ | | |  |_|  _  | __/__ \ | | | || |/  \| | | \/ | | | |
#  \__/|_|  \___|_| |_|___|___/ |_| |_| \__/|_|_|_|\__/|_| |_|
#         Last Updated: 2017-12-19             WHQ.CD.AppSrvcs

function vt() {

	vaulty_authy() {
		if [ $(command -v jq) ]; then
			export VAULT_ADDR=$(echo $2 | jq -r '.vault.address')
			export AWS_REGION=$(echo $2 | jq -r '.aws.region')
			export AWS_DEFAULT_REGION=$(echo $2 | jq -r '.aws.region')
			unset VAULT_TOKEN
			vault-login-oidc
			export VAULT_TOKEN=`cat ~/.vault-token`
		else
			printf "You must have jq installed to use this script.\n"
			$?=1
		fi

		if [ $?==0 ]; then
			data=$(vault read -format=json "$1")
			export AWS_ACCESS_KEY_ID=$(echo $data | jq -r '.data.access_key')
			export AWS_SECRET_ACCESS_KEY=$(echo $data | jq -r '.data.secret_key')
		fi
	}

	awsaccounts=(lab1 lab2 prd lab4 prd_read appsjw brdcst brdcst_dev prd_leg travel_dev travel_prd)
	bethel_values=$(<~/bethel_values.json)

	PS3='Select an account: '
	select opt in "${awsaccounts[@]}"; do
		case "$opt" in
		lab1)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.lab1')" $bethel_values
			break
			;;
		lab2)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.lab2')" $bethel_values
			break
			;;
		prd)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.prd')" $bethel_values
			break
			;;
		lab4)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.lab4')" $bethel_values
			break
			;;
		prd_read)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.prd_read')" $bethel_values
			break
			;;
		appsjw)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.appsjw')" $bethel_values
			break
			;;
		brdcst)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.brdcst')" $bethel_values
			break
			;;
		brdcst_dev)
			vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.brdcst_dev')" $bethel_values
			break
			;;
		prd_leg)
		  vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.prd_leg')" $bethel_values
			break
			;;
		travel_dev)
		  vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.travel_dev')" $bethel_values
			break
			;;
		travel_prd)
		  vaulty_authy "$(echo $bethel_values | jq -r '.vault.environment_creds.travel_prd')" $bethel_values
			break
			;;
		*)
			printf "Invalid selection. Please try again.\n"
			;;
		esac
	done

}
