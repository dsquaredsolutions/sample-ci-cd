
all: init plan apply

init:
	terraform init

plan:
	@terraform plan -out=app_dev.tfplan

apply:
	terraform apply -auto-approve "app_dev.tfplan"

destroy:
	terraform destroy -auto-approve