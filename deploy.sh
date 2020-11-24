git pull 

hexo generate

cd ../hassanchiang.github.io/

git reset --hard

git pull 

rsync -avz --delete /root/blog/blog/public/ /root/blog/hassanchiang.github.io/ --exclude=.git --exclude=CNAME --exclude=mind

git add . -A

git commit -m "$(date +%Y-%m-%d) $(date +%X)"

git push
