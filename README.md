#Bryan Matsuo's resume

##Generating HTML

    ./xml-resume/xml2html.sh resume.xml
    mv resume.html index.html

##Publish

    git co gh-pages
    git merge master
    git push
