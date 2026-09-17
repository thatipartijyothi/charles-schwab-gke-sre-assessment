.PHONY: fmt validate deploy evidence destroy

fmt:
	terraform -chdir=terraform fmt -recursive

validate:
	terraform -chdir=terraform fmt -check -recursive
	terraform -chdir=terraform validate
	python3 -m py_compile applications/app-a/app.py applications/app-b/app.py
	bash -n scripts/*.sh
	kubectl kustomize kubernetes/base >/dev/null

deploy:
	./scripts/deploy.sh

evidence:
	./scripts/validate.sh

destroy:
	./scripts/destroy.sh

