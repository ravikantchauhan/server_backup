#!/bin/bash
#####disk spase
#!/bin/bash
# Sample script to demonstrate the creation of an HTML report using shell scripting
# Web directory
WEB_DIR=/var/www/html
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
#############################################
echo "
<table border='2'>
<tr><th class='titulo'>Memory Type</td>
<th class='titulo'>Total</td>
<th class='titulo'>Use Gb</td>
<th class='titulo'>Free</td></tr>" >> $WEB_DIR/report.html
while read line; do
echo "<tr><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk  '{print $1}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $2}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $3}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $4}' >> $WEB_DIR/report.html
echo "</td></tr>" >> $WEB_DIR/report.html
done < <(free -h | grep -v + )
#############################################
echo "
<table border='2'>
<tr><th class='titulo'>Filesystem</td>
<th class='titulo'>Size</td>
<th class='titulo'>Use %</td>
</tr>" >> $WEB_DIR/report.html

# Read the output of df -h line by line
while read line; do
echo "<tr><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $1}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $2}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $5}' >> $WEB_DIR/report.html
echo "</td></tr>" >> $WEB_DIR/report.html
done < <(df -h | grep -vi filesystem)
echo "</table></BODY></HTML>" >> $WEB_DIR/report.html
#####################################################
# TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
echo "
<table border='2'>
<tr><th class='titulo'>Memory %</td>
<th class='titulo'>CPU %</td>
<th class='titulo'>COMMAND</td>
</tr>" >> $WEB_DIR/report.html
#####################################################
# Read the output of TOP 5 MEMORY-CONSUMING PROCESSES *****\e[0m"
while read line; do
echo "<tr><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $1}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $2}' >> $WEB_DIR/report.html
echo "</td><td align='center'>" >> $WEB_DIR/report.html
echo $line | awk '{print $3}' >> $WEB_DIR/report.html
echo "</td></tr>" >> $WEB_DIR/report.html
done < <(ps -eo %mem,%cpu,comm --sort=-%mem | head -n 20)
echo "</table></BODY></HTML>" >> $WEB_DIR/report.html