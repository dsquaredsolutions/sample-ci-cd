
all: init plan apply

init:
	terraform init

plan:
	@terraform plan -var="container_tag=${REPO_VERSION}" -out=app_prod.tfplan

apply:
	terraform apply -auto-approve "app_prod.tfplan"

destroy:
	terraform destroy -auto-approve