#!/bin/bash

# This script will make the necessary modifications to Octopress 2.0 to enable
# the Outbrain recomendations widget.

# Outbrain, Inc. provides no warranties or guarantees on this script, you should
# certainly back up your site before running.

# Special thanks to Matthew Dorey <@mattischrome> who did the initial heavy
# lifting to get the widget to work properly. I just packaged and scripted it
# to make it easier to install.

# Outbrain Setup:
#
# You will first want to go to setup an Outbrain account. This allows you to
# view detailed reports and change some advanced settings.
#  https://my.outbrain.com/register
#
# Once registered, in your Dashboard:
# * Choose Manage Blogs.
# * Then choose Add Blog.
# * Under Install Widget, select yes.
# * Click on 'JavaScript' 
# * Fill in your URL, Setting and Terms, Yadda Yadda.
#
# After clicking Continue you will be given two sets of JavaScript.
#
# The first is the actual widget code.  The second is there for you to claim
# your blog with Outbrain. We need a bit of information from the second one.
#
# It will look like this:
#   <input type="hidden" name="OBKey" value="8xraPvystyYIOGKIWNGy/g=="/>
#   <script LANGUAGE="JavaScript">var OBCTm='13484456513349';
#   </script>
#   <script LANGUAGE="JavaScript" src="http://widgets.outbrain.com/claim.js">
#   </script>
#
# You want to grab the OBKey and OBCTm values and with that you are ready to run
# this script.

# Installation:
# cd to your octopress directory.
# wget https://raw.github.com/nmilford/outbrain-on-octopress/master/outbrain-on-octopress.sh
# chmod +x ./outbrain-on-octopress.sh
# ./outbrain-on-octopress.sh
# Enter the OBKey and OBCTm values
# rake generate
# rake preview

# Sanities go here.
if [ ! -f _config.yml ];then
  echo "Please run this script from your Octopress site root directory."
  exit -1
fi

echo "                         _   _               _       "
echo "                        | | | |             (_)      "
echo "              ___  _   _| |_| |__  _ __ __ _ _ _ __  "
echo "             / _ \| | | | __| '_ \| '__/ _' | | '_ \ "
echo "            | (_) | |_| | |_| |_) | | | (_| | | | | |"
echo "             \___/ \__,_|\__|_.__/|_|  \__'_|_|_| |_|"
echo "                                     on Octopress"
echo ""
echo "This script is intend to install the Outbrain recomendations widget on"
echo "installations of Octopress 2.0 only."
echo
echo "Also note that this script, as of yet, is not idempotent nor will it undo"
echo "changes made to your Octopress installation."
echo
echo "Outbrain, Inc. provides no warranties or guarantees on this script, you"
echo "should certainly back up your site before running."
echo
echo "If you find this unacceptable please press CTRL+C to exit."
echo

read -s -n 1 -p "Otherwise, press any key to continue . . ."
echo

# Grab user info.
read -p "Enter your 'OBKey' value and hit [ENTER]: " OBKey
read -p "Enter your 'OBCTm' value and hit [ENTER]: " OBCTm
echo

# This stanza will add the Outbrain config to your _config.yml
cat <<EOF >> _config.yml

# Outbrain Widget
outbrain: true
outbrain_OBKey: $OBKey
outbrain_OBCTm: $OBCTm
EOF

# Modifies the sharing.html template to include the outbrain settings. This is
# the only way it seems to place the Outbrain widget properly.
#
# THIS WILL GET OVER WRITTEN WHEN UPGRADING OCTOPRESS.
echo "*** Modifying source/_includes/post/sharing.html place the widget."
echo "    Note: This is the only change that can be overwritten when upgrading"
echo "          Octopress.  In Octopress 2.1 this will be resolved."
cat <<EOF >> source/_includes/post/sharing.html

{% comment %} Include the Outbrain widget below the sharing buttons. {% endcomment %}
{% include custom/outbrain.html %}
EOF

# Dumps the Outbrain code into a custom template that will not be overwritten.
echo "*** Creating source/_includes/custom/outbrain.html to handle the widget code."
cat <<EOF > source/_includes/custom/outbrain.html
{% comment %} Enables the Outbrain recomendation widget. {% endcomment %}
{% if site.outbrain %}
<script language='JavaScript'>
var OB_langJS = 'http://widgets.outbrain.com/lang_en.js';
var OBITm = '1348616024968';
var OB_raterMode = 'none';
var OB_recMode = 'strip'; 
var OutbrainPermaLink='{{ site.url }}{{ page.url }}'; 
if ( typeof(OB_Script)!='undefined' )OutbrainStart();
else { var OB_Script = true;
var str = unescape("%3Cscript src=\'http://widgets.outbrain.com/OutbrainRater.js\' type=\'text/javascript\'%3E%3C/script%3E");
document.write(str); }
</script>
{% endif %}
EOF

# Dumps the Outbrain Blog Claim code near the closing </body> tag.
echo "*** Modifying source/_includes/custom/footer.html to place the blog claim code."
cat <<EOF >> source/_includes/custom/footer.html

{% comment %} If you haven't used the Outbrain Widget before, the code here will
              claim your blog. {% endcomment %}
{% if site.outbrain %}
<input type="hidden" name="OBKey" value='{{ site.outbrain_OBKey }}'/> 
<script LANGUAGE="JavaScript">
var OBCTm='{{ site.outbrain_OBCTm }}';
</script>
<script LANGUAGE="JavaScript" src="http://widgets.outbrain.com/claim.js"></script>
{% endif %}
EOF

# Modifies the CSS to fix a small issue with the outbrain thumbnail widget.
echo "*** Modifying sass/custom/_styles.scss to improve the widget's look."
cat <<EOF >> sass/custom/_styles.scss

// A fix for the Outbrain thumbnail widget. 
.force-wrap {
  white-space: normal;
  word-wrap: break-word;
}
EOF

echo "*** Process is complete. Have a nice day :)"
