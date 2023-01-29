
all: init plan apply

init:
	terraform init

plan:
	@terraform plan -var="private_key=${PRIV_KEY}" -out=app_dev.tfplan

apply:
	terraform apply -auto-approve "app_dev.tfplan"

destroy:
	terraform destroy -auto-approve