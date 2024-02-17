#! /bin/bash

#echo "input DB_PASS: "
read -s -p "input DB_PASS: " DB_PASS
export DB_PASS

cat <<EOF > kustomization.yaml.sample
secretGenerator:
- name: mysql-pass
  literals:
  - password=$DB_PASS
resources:
  - mysql-deployment.yaml
EOF

echo
echo "------------------"
echo "command cheatsheet"
echo "------------------"
echo

echo "--- deploy mysql service ---"
echo "mv kustomization.yaml kustomization.yaml.bak"
echo "mv kustomization.yaml.sample kustomization.yaml"
echo "kubectl apply -k ./"
echo

echo "--- delete mysql service ---"
echo "kubectl delete -k ./"
echo

echo "--- init DB with saledb-init.sql ---"
cat <<EOF
export POD__=\$( kubectl get pods -l "app=wordpress,tier=mysql" -o jsonpath="{.items[0].metadata.name }" )
kubectl exec -it \$POD__ -- mysql -u root -p\$DB_PASS < saledb-init.sql
EOF
echo

echo "--- check DB.customer table ---"
cat <<EOF
export POD__=\$( kubectl get pods -l "app=wordpress,tier=mysql" -o jsonpath="{.items[0].metadata.name }" )
kubectl exec -it \$POD__ -- mysql --default-character-set=utf8 -u root -p\$DB_PASS -D saledb -e 'select * from customer;'
EOF
# alternative way
# export POD_IP__=\$( kubectl get pods -l "app=wordpress,tier=mysql" -o jsonpath="{.items[0].status.podIP}" )
# kubectl run mysqlclient --rm -it --restart=Never --image=mysql:8.0 --overrides='{"spec":{"tolerations":[{"key":"kubernetes.io/arch","value":"arm64","effect":"NoSchedule"}]}}' --command -- mysql --default-character-set=utf8 -h \$POD_IP__ -u root -p\$DB_PASS -D saledb -e 'select * from customer;'
echo
