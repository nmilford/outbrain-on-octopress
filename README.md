<pre>
             _   _               _       
            | | | |             (_)      
  ___  _   _| |_| |__  _ __ __ _ _ _ __  
 / _ \| | | | __| '_ \| '__/ _` | | '_ \ 
| (_) | |_| | |_| |_) | | | (_| | | | | |
 \___/ \__,_|\__|_.__/|_|  \__,_|_|_| |_|
                         on Octopress
</pre>

A script to simplify the installation of the [Outbrain](http://www.outbrain.com/) recommendation Widget on the [Octopress](http://octopress.org/) blogging Framework.

Special thanks go out to:
* [Matthew Dorey](https://twitter.com/mattischrome) who did the initial heavy lifting to get the widget to be placed properly. 
* [Jackie Jennings](https://twitter.com/ohhijackie) who demystified the Outbrain Nano widget. 
* [Dave Kilsheimer](https://twitter.com/kilsey) who whipped up some CSS to get the widget to render correctly. 

## Outbrain Setup:

You will first want to go to [setup an Outbrain account](https://my.outbrain.com/register). This allows you to view detailed reports and change some advanced settings.  This is not mandatory but it gives you some control of the widget.

Additionally, if you have claimed your blog on a previous platform (i.e you are migrating to Octopress from elsewhere) then you do not need to 'claim' your blog again and can skip this.

Once registered with Outbrain, in your Dashboard:
* Choose Manage Blogs.
* Then choose Add Blog.
* Under Install Widget, select yes.
* Click on 'JavaScript' 
* Fill in your URL, Setting and Terms, etc.

After clicking Continue you will be given two sets of JavaScript.

The first is the actual widget code.  The second is there for you to claim your blog with Outbrain.  We need a bit of information from the second one.

It will look like this:
```javascript
<input type="hidden" name="OBKey" value="8xraPvystyYIOGKIWNGy/g=="/>
<script LANGUAGE="JavaScript">var OBCTm='13484456513349';
</script>
<script LANGUAGE="JavaScript" src="http://widgets.outbrain.com/claim.js">
</script>
```

You want to grab the _OBKey_ value and with that you are ready to run this script.

## Installation:

You need to be in your Octopress directory.

`cd to/your/octopress/directory`

Grab ths script.

`wget https://raw.github.com/nmilford/outbrain-on-octopress/master/outbrain-on-octopress.sh`

Make it executable.

`chmod +x ./outbrain-on-octopress.sh`

Run it.

`./outbrain-on-octopress.sh install`

Enter the _OBKey_ value if needed and the script will run and exit.

From here you need to do what you normally do in octopress when making a change.

`rake generate && rake preview`

## Uninstall

`./outbrain-on-octopress.sh uninstall`

This presumes your install has not changed so much.  It deletes the custom include with the outbrain code, then deletes any line from the files the install touches containing the word 'outbrain'.

## A Few Notes:

* This script is intend to install the Outbrain recomendations widget on installations of Octopress 2.0 only.

* Also note that this script, as of yet, is not idempotent so running it multiple times will apply it multiple times. However, running the install should clean it up if you do.

* There is one change made to `source/_includes/post/sharing.html` that will not survive an upgrade of Octopress, but is trivial to re-implement, just take a peek at the bash script.

* Lastly, my employer, Outbrain, Inc., provides no warranties or guarantees on this script, you should certainly back up your site before running."
