// Created by iWeb 3.0 local-build-20090324

function writeMovie1()
{detectBrowser();if(windowsInternetExplorer)
{document.write('<object id="id3" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab" width="384" height="400" style="height: 400px; left: 158px; position: absolute; top: 0px; width: 384px; z-index: 1; "><param name="src" value="../../../../Media/12adren.m4a" /><param name="controller" value="true" /><param name="autoplay" value="false" /><param name="scale" value="tofit" /><param name="volume" value="100" /><param name="loop" value="false" /></object>');}
else if(isiPhone)
{document.write('<object id="id3" type="video/quicktime" width="384" height="400" style="height: 400px; left: 158px; position: absolute; top: 0px; width: 384px; z-index: 1; "><param name="src" value="13_12_Adrenergic_Transmission_files/12adren.jpg"/><param name="target" value="myself"/><param name="href" value="../../../../../Media/12adren.m4a"/><param name="controller" value="true"/><param name="scale" value="tofit"/></object>');}
else
{document.write('<object id="id3" type="video/quicktime" width="384" height="400" data="../../../../Media/12adren.m4a" style="height: 400px; left: 158px; position: absolute; top: 0px; width: 384px; z-index: 1; "><param name="src" value="../../../../Media/12adren.m4a"/><param name="controller" value="true"/><param name="autoplay" value="false"/><param name="scale" value="tofit"/><param name="volume" value="100"/><param name="loop" value="false"/></object>');}}
setTransparentGifURL('../../../../Media/transparent.gif');function hostedOnDM()
{return false;}
function onPageLoad()
{dynamicallyPopulate();loadMozillaCSS('13_12_Adrenergic_Transmission_files/13_12_Adrenergic_TransmissionMoz.css')
adjustLineHeightIfTooBig('id1');adjustFontSizeIfTooBig('id1');adjustLineHeightIfTooBig('id2');adjustFontSizeIfTooBig('id2');adjustLineHeightIfTooBig('id5');adjustFontSizeIfTooBig('id5');adjustLineHeightIfTooBig('id6');adjustFontSizeIfTooBig('id6');Widget.onload();fixupPodcast('id3','id4');BlogFixupPreviousNext();performPostEffectsFixups()}
function onPageUnload()
{Widget.onunload();}
