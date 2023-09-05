#!/bin/bash
#####disk spase
# Sample script to demonstrate the creation of an HTML report using shell scripting
# Web directory
WEB_DIR=/var/www/html
Backupdir=/tmp/backup
#mkdir -p $dir
if [[ ! -e $Backupdir ]]; then
    mkdir $Backupdir
elif [[ ! -d $Backupdir ]]; then
    echo "$Backupdiralready exists but is not a directory" 1>&2
fi
# A little CSS and table layout to make the report look a little nicer
echo "<HTML>
<HEAD>
<style>
.titulo{font-size: 1em; color: white; background:#0863CE; padding: 0.1em 0.2em;}
table
{
border-collapse:collapse;
}
table, td, th
{
border:1px solid black;
}
</style>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
</HEAD>
<BODY>" > $WEB_DIR/report.html
# View hostname and insert it at the top of the html body
HOST=$(hostname)
os=$(uname -o)
# Check if connected to Internet or not
xyz=$( ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $tecreset Connected" || echo -e '\E[32m'"Internet: $tecreset Disconnected" )
# Check OS Release Version and Name
cat /etc/os-release | grep 'NAME\|VERSION' | grep -v 'VERSION_ID' | grep -v 'PRETTY_NAME' > /tmp/osrelease
#osv=$(cat/tmp/osrelease)
name=$(echo -n -e '\E[32m'"OS Name :" $tecreset  && cat /tmp/osrelease | grep -v "VERSION" | cut -f2 -d\")
name1=$(echo -n -e '\E[32m'"OS Version :" $tecreset && cat /tmp/osrelease | grep -v "NAME" | cut -f2 -d\")

# Check if connected to Internet or not

echo "Server name or Host name :<strong>$HOST</strong><br>
      Operating System Type :<strong>$os</strong><br>
      Operating System name :<strong>$name</strong><br>
      Operating System version :<strong>$name1</strong><br>
      Internet status :<strong>$xyz</strong><br> 
    
Last updated: <strong>$(date)</strong><br><br> " >> $WEB_DIR/report.html


#Free_disk= (100- $(df -H / | grep -vi filesystem |  awk '{print $2}'))
code_size=$(du -sh /var/www/ | awk '{print $1}')
code_b=$(df -H / | grep -vi filesystem |  awk '{print $2}'|cut -d "G" -f 1 )
#code_size=$(du -sh /var/ | awk '{print $1}' | cut -d "M" -f 1)
num1=100
pct=$(df -H / | grep -vi filesystem | awk '{print $5}' | cut -d "%" -f 1)
echo "
<table border='2'>
<tr><th class='titulo'>Filesystem</td>
<th class='titulo'>Total Size</td>
<th class='titulo'>Use in GB </td>
<th class='titulo'>Use %</td>
<th class='titulo'>Left in GB </td>
<th class='titulo'>Left in % </td>
<th class='titulo'>code size in GB  </td>
</tr>" >> $WEB_DIR/report.html

# # Read the output of df -h line by line
 while read line; do
 echo "<tr><td align='center'>" >> $WEB_DIR/report.html
 echo $line | awk '{print $1}' >> $WEB_DIR/report.html
 echo "</td><td align='center'>" >> $WEB_DIR/report.html
 echo $line | awk '{print $2}' >> $WEB_DIR/report.html
 echo "</td><td align='center'>" >> $WEB_DIR/report.html
 echo $line | awk '{print $3}' >> $WEB_DIR/report.html
 echo "</td><td align='center'>" >> $WEB_DIR/report.html
 echo $line | awk '{print $5}' >> $WEB_DIR/report.html
 echo "</td><td align='center'>" >> $WEB_DIR/report.html
 echo $line | awk '{print $4}' >> $WEB_DIR/report.html
 echo "</td><td align='center'>" >> $WEB_DIR/report.html
 echo  "$[num1 - pct]%"  >> $WEB_DIR/report.html
 echo "</td><td align='center'>" >> $WEB_DIR/report.html
 echo  "$code_size"  >> $WEB_DIR/report.html
 echo "</td></tr>" >> $WEB_DIR/report.html
 done < <(df -H / | grep -vi filesystem)
 echo "</table></BODY></HTML>" >> $WEB_DIR/report.html
# ####################################################

# if [[ ! -e $dir ]]; then
#     mkdir $dir
# elif [[ ! -d $dir ]]; then
#     echo "$dir already exists but is not a directory" 1>&2
# fi
left=$(df -H / | grep -vi filesystem | awk '{print $4}' |cut -d "G" -f 1|cut -d "." -f 1)


if([ $left -le $code_b ])
then
sourcePath="/var/www/"
destinationPath=$Backupdir
# destinationPath="/var/www/Backups/Code_Backup/"
#find $sourcePath -ctime -60 -type d | while IFS= read x
find $sourcePath -maxdepth 0 -type d | while IFS= read x
do
now="$(date +'%d%m%Y')"
fileName=$(basename $x)
tar -zcvf $destinationPath/$fileName-$now.tar.gz --exclude=*.tar.gz --exclude=*.zip --exclude="/var/www/html/*/*.sql" --exclude="/var/www/html/*/*.git" --exclude="/var/www/html/*/*media" --exclude="/var/www/html/*/*var" $x
done
echo "code is big plz free some Done1" >> $WEB_DIR/report.html

else
    echo "code is big plz free some space1" >> $WEB_DIR/report.html
fi
