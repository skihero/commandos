
# Create custom url's from the contextMenu

C:\Application Data\Mozilla\Firefox\Profiles\s7x9zo
gz.default\extensions\wallma@skihero.info

C:.
└───chrome
    ├───content
    └───locale
        └───en-US


C:\Application Data\Mozilla\Firefox\Profiles\s7x9zo
gz.default\extensions\wallma@skihero.info
 
C:.
│   chrome.manifest
│   install.rdf
│
└───chrome
    ├───content
    │       favicon.png
    │       icon.png
    │       overlay.js
    │       overlay.xul
    │
    └───locale
        └───en-US
                wallma.dtd




chrome.manifest

content wallma chrome/content/
locale  wallma en-US    chrome/locale/en-US/
overlay chrome://browser/content/browser.xul    chrome://wallma/content/overlay.xul
 


install.rdf 

<?xml version="1.0"?>

<RDF xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
     xmlns:em="http://www.mozilla.org/2004/em-rdf#">

        <Description about="urn:mozilla:install-manifest">
        <em:id>wallma@skihero.info</em:id>
                <em:name>WallMA right click open</em:name>
                <em:version>0.0.1</em:version>
                <em:creator>skihero</em:creator>
                 <em:contributor>Thanks to the internet for images</em:contributor>

                <em:description>Open the wallma image with custom string at the end </em:description>
                <em:homepageURL>github.com/skihero</em:homepageURL>
                <em:iconURL>chrome://wallma/content/icon.png</em:iconURL>
                <em:targetApplication>
                        <Description>
                                <em:id>{ec8030f7-c20a-464f-9b0e-13a3a9e97384}</em:id>
                                <em:minVersion>3.5</em:minVersion>
                                <em:maxVersion>4.0.*</em:maxVersion>
                        </Description>
                </em:targetApplication>
        </Description>
</RDF>



overlay.js 

wallma = {
init: function() {
         window.removeEventListener("load", wallma.init, false );
         document.getElementById("contentAreaContextMenu").addEventListener("popupshowing",wallma.showMenuItem, false);
},

showMenuItem: function()
  {
 
    var show = document.getElementById('context-openwallma');
    show.hidden ; 
  },



openImage: function(url, event) {

	custom_string="any_other_string_that_you_want"; 
        url = url + custom_string ; 
        
	//throw new Error(url) ; 

        var tBrowser = document.getElementById("content");
	var tab = tBrowser.addTab(url);
}


};
window.addEventListener("load", wallma.init, false);




overlay.xul 


<?xml version="1.0"?>
<!DOCTYPE overlay SYSTEM "chrome://wallma/locale/wallma.dtd">
<overlay id="wallmaOverlay"
         xmlns="http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul">

<script type="application/x-javascript" src="chrome://wallma/content/overlay.js"/>

<popup id="contentAreaContextMenu">
  <menuitem class="menuitem-iconic" image="chrome://wallma/content/favicon.png" id="context-openwallma" label="&wallma-context-menu-label;" oncommand="wallma.openImage((gContextMenu.linkURL || gContextMenu.bgImageURL), event)"/>
</popup>

</overlay>



locale/en-US/wallma.dtd 

<!ENTITY wallma-context-menu-label "Open with wallma">











