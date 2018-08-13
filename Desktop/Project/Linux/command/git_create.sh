git init

read -p "请输入项目地址:" address
git add "$address"

git commit -m "first commit"

read -p "请输入远程主机地址:" remoteaddress

git remote add origin "$remoteaddress"
git push --force origin master
