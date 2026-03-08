#!/bin/sh
#
# Script to install the dashboard module and apply the post-login 
# JavaScript redirect fix for white screen errors on the bare /cgi-bin/luci/ path.
#

DASH_DIR="/www/luci-static/resources/view/dashboard"
JS_FILE="$DASH_DIR/index.js"

echo "--- Starting LuCI Dashboard Fix Script ---"

# 1. Install the required dashboard package
echo "Attempting to install luci-mod-dashboard..."
apk update
apk add luci-mod-dashboard

# 2. Check if the target directory exists
if [ ! -d "$DASH_DIR" ]; then
    echo "ERROR: Dashboard directory not found at $DASH_DIR."
    echo "Please ensure luci-mod-dashboard was installed successfully."
    exit 1
fi

echo "Target directory $DASH_DIR found. Proceeding with file replacement..."
sleep 3

# 3. Write the new index.js file with the fix
# The JavaScript code forces a redirect to '/admin/dashboard' if the user lands on the bare '/cgi-bin/luci/' path after login, 
# preventing the broken UI state (white screen error).

cat << 'EOF_JS' > "$JS_FILE"
'use strict';
'require view';
'require dom';
'require poll';
'require fs';
'require network';

document.querySelector('head').appendChild(E('link',{'rel':'stylesheet','type':'text/css','href':L.resource('view/dashboard/css/custom.css')}));

// --- DYNAMIC CLICK FIX: Safe JavaScript Navigation ---
// Check if the current URL path is the bare LuCI root after login.
var currentPath = window.location.pathname;

if (currentPath.match(/\/cgi-bin\/luci\/?$/)) {
    console.log("LuCI Redirect Fix: Detected bare root URL, forcing navigation to dashboard...");
    // Construct the correct dashboard path
    var dashboardPath = currentPath.replace(/\/$/, '') + '/admin/dashboard';
    
    // Use standard window assignment to force navigation/redirect.
    window.location.href = dashboardPath;
    
    // Stop further script execution if we are redirecting
    return view.extend({});
}
// --------------------------------------------------

function invokeIncludesLoad(includes){
    var tasks=[],has_load=false;
    for(var i=0;i<includes.length;i++){
        if(typeof(includes[i].load)=='function'){
            tasks.push(includes[i].load().catch(L.bind(function(){this.failed=true;},includes[i])));
            has_load=true;
        }
        else{
            tasks.push(null);
        }
    }
    return has_load?Promise.all(tasks):Promise.resolve(null);
}

function startPolling(includes,containers){
    var step=function(){
        return network.flushCache().then(function(){
            return invokeIncludesLoad(includes);
        }).then(function(results){
            for(var i=0;i<includes.length;i++){
                var content=null;
                if(includes[i].failed)
                    continue;
                if(typeof(includes[i].render)=='function')
                    content=includes[i].render(results?results[i]:null);
                else if(includes[i].content!=null)
                    content=includes[i].content;

                if(content!=null){
                    if(i>1){
                        dom.append(containers[1],content);
                    } else {
                        containers[i].parentNode.style.display='';
                        containers[i].parentNode.classList.add('fade-in');
                        containers[i].parentNode.classList.add('Dashboard');
                        dom.content(containers[i],content);
                    }
                }
            }
            var ssi=document.querySelector('div.includes');
            if(ssi){
                ssi.style.display='';
                ssi.classList.add('fade-in');
            }
        });
    };
    
    // Perform the initial render step.
    return step().then(function(){
        poll.add(step);
    });
}

return view.extend({
    load:function(){
        return L.resolveDefault(fs.list('/www'+L.resource('view/dashboard/include')),[]).then(function(entries){
            return Promise.all(entries.filter(function(e){
                return(e.type=='file'&&e.name.match(/\.js$/));
            }).map(function(e){
                return'view.dashboard.include.'+e.name.replace(/\.js$/,'');
            }).sort().map(function(n){
                return L.require(n);
            }));
        });
    },
    render:function(includes){
        var rv=E([]),containers=[];
        for(var i=0;i<includes.length-1;i++){
            var container=E('div',{'class':'section-content'});
            rv.appendChild(E('div',{'class':'cbi-section-'+i,'style':'display:none'},[container]));
            containers.push(container);
        }
        return startPolling(includes,containers).then(function(){return rv;});
    },
    handleSaveApply:null,
    handleSave:null,
    handleReset:null
});
EOF_JS

echo "Successfully wrote new JavaScript file to $JS_FILE"

# 4. Clean up cache and restart services
echo "Clearing LuCI cache and restarting web server..."
rm -f /tmp/luci-indexcache
/etc/init.d/uhttpd restart

echo "--- Script finished. Please hard refresh your browser (Ctrl+Shift+R or Cmd+Shift+R) --- reboot router if Glitches"

