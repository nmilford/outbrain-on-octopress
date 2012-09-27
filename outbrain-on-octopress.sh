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
# run 'curl -L https://pathtp/this.script | bash
# Enter the OBKey and OBCTm values
# rake generate
# rake preview


# This stanza will add the Outbrain config to your _config.yml
cat <<EOF >> _config.yml

# Outbrain Widget
outbrain: true
outbrain_OBKey: $OBKey
outbrain_OBCTm: $OBCTm7
EOF

# Modifies the sharing.html template to include the outbrain settings. This is
# the only way it seems to place the Outbrain widget properly.
#
# THIS WILL GET OVER WRITTEN WHEN UPGRADING OCTOPRESS.
cat <<EOF >> source/_includes/post/sharing.html

# Include the Outbrain widget below the sharing buttons.
{% include custom/outbrain.html %}
EOF

# Dumps the Outbrain code into a custom template that will not be overwritten.
cat <<EOF > source/_includes/custom/outbrain.html

# Enables the Outbrain recomendation widget.
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
cat <<EOF >> source/_includes/custom/footer.html

# If you haven't used the Outbrain Widget before, you can use the code here to
# claim your blog.
{% if site.outbrain %}
<input type="hidden" name="OBKey" value='{{ site.outbrain_OBKey }}'/> 
<script LANGUAGE="JavaScript">
var OBCTm='{{ site.outbrain_OBCTm }}';
</script>
<script LANGUAGE="JavaScript" src="http://widgets.outbrain.com/claim.js"></script>
{% endif %}
EOF

# Modifies the CSS to fix a small issue with the Outbrain thumbnail widget.
cat <<EOF >> sass/custom/_styles.scss

# A Fix for Outbrain as the defaults cause the Thumnail widget to look awkward. 
.force-wrap {
  white-space: normal;
  word-wrap: break-word;
}
EOF



