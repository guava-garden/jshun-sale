#! /bin/bash

#echo "input DB_PASS: "
read -s -p "input DB_PASS: " DB_PASS
cat <<EOF > kustomization.yaml.sample
secretGenerator:
- name: mysql-pass
  literals:
  - password=$DB_PASS
resources:
  - mysql-deployment.yaml
EOF
echo
echo "--- deploy with command below ---"
echo "mv kustomization.yaml kustomization.yaml.bak"
echo "mv kustomization.yaml.sample kustomization.yaml"
echo "kubectl apply -k ./"
echo
echo "--- delete with command below ---"
echo "kubectl delete -k ./"

