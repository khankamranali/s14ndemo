RM=/bin/rm -f
RMD=/bin/rm -Rf

.helm-bin-install:
	curl https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-rc.2-linux-amd64.tar.gz | tar -xzv
	sudo cp linux-amd64/helm /usr/local/bin
	${RMD} linux-amd64
	helm home

.helm-bin-delete:
	-sudo ${RM} /usr/local/bin/helm

.helm-install: .helm-bin-install
	kubectl -n kube-system create serviceaccount tiller
	kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
	helm init --service-account=tiller

.helm-delete: 
	-helm reset
	-${RMD} ~/.helm
	-kubectl -n kube-system delete deployment tiller-deploy 
	-kubectl delete clusterrolebinding tiller
	-kubectl -n kube-system delete serviceaccount tiller
	-make .helm-bin-delete
	-echo 'helm deleted.'
	
