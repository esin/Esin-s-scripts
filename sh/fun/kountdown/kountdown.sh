#!/bin/bash
DELTA_CURRENT_TIME=14400        # Delta if time on server is different from yours in secs
CURRENT_TIME=$(expr $(date +%s) + $DELTA_CURRENT_TIME)
COUNTDOWN_DATE="20120630 12:00:00"      # Date and time, `date` syntax
SAVE_FOLDER="./"
DELTA_SECS=$(expr $(date -d "$COUNTDOWN_DATE" +%s) - $CURRENT_TIME)
DELTA_DAYS=$(expr $DELTA_SECS / 86400)
DELTA_WEEKS=$(expr $DELTA_DAYS / 7)
DELTA_MONTH=$(expr $DELTA_DAYS / 30)

echo "<html><head>
<style type=\"text/css\">
ko{color:green} body{font-weight:bold;font-family:\"Verdana\",sans-serif}
table{font-family:\"Verdana\",sans-serif}
</style></head><body>
<font size=-5>It's an army</font><br>
<ko>KO</ko>untdown<br>
<table align=left cellspacing=0>
<tr><td><b>Дней</b></td><td>$DELTA_DAYS</td></tr>
<tr><td><b>Недель</b></td><td>$DELTA_WEEKS</td></tr>
<tr><td><b>Месяцев</b></td><td>$DELTA_MONTH</td></tr>
</table></body></html>" > "$SAVE_FOLDER/index.html"