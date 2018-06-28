git add .
git commit -m "debug"
git push -u origin master

git add "$1"
read -p "请输入修改内容:" content
git commit -m "$content"
git push -u origin master