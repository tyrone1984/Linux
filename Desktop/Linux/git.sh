read -p "请输入项目地址:" address
git add "$address"

read -p "请输入修改内容:" content
git commit -m "$content"
git push -u origin master

cp ./git.sh ./Linux/