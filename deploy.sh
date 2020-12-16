noFlag="Already up-to-date."
result=`git pull | grep "Already up-to-date."`
if [ $noFlag == $result ]; then
    exit 0
fi

echo "begin deploy blog : "$date
hexo generate

cd ../hassanchiang.github.io/

git reset --hard

git pull 

rsync -avz --delete /root/blog/blog/public/ /root/blog/hassanchiang.github.io/ --exclude=.git --exclude=CNAME --exclude=mind

git add . -A

git commit -m "$(date +%Y-%m-%d) $(date +%X)"

git push
