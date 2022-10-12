// Created by iWeb 3.0 local-build-20090324

function writeMovie1()
{detectBrowser();if(windowsInternetExplorer)
{document.write('<object id="id3" classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab" width="512" height="400" style="height: 400px; left: 94px; position: absolute; top: 0px; width: 512px; z-index: 1; "><param name="src" value="../../../../Media/05distIpod.m4v" /><param name="controller" value="true" /><param name="autoplay" value="false" /><param name="scale" value="tofit" /><param name="volume" value="100" /><param name="loop" value="false" /></object>');}
else if(isiPhone)
{document.write('<object id="id3" type="video/quicktime" width="512" height="400" style="height: 400px; left: 94px; position: absolute; top: 0px; width: 512px; z-index: 1; "><param name="src" value="3_05_Pharmacokinetics_Distribution_files/05distIpod.jpg"/><param name="target" value="myself"/><param name="href" value="../../../../../Media/05distIpod.m4v"/><param name="controller" value="true"/><param name="scale" value="tofit"/></object>');}
else
{document.write('<object id="id3" type="video/quicktime" width="512" height="400" data="../../../../Media/05distIpod.m4v" style="height: 400px; left: 94px; position: absolute; top: 0px; width: 512px; z-index: 1; "><param name="src" value="../../../../Media/05distIpod.m4v"/><param name="controller" value="true"/><param name="autoplay" value="false"/><param name="scale" value="tofit"/><param name="volume" value="100"/><param name="loop" value="false"/></object>');}}
setTransparentGifURL('../../../../Media/transparent.gif');function hostedOnDM()
{return false;}
function onPageLoad()
{dynamicallyPopulate();loadMozillaCSS('3_05_Pharmacokinetics_Distribution_files/3_05_Pharmacokinetics_DistributionMoz.css')
adjustLineHeightIfTooBig('id1');adjustFontSizeIfTooBig('id1');adjustLineHeightIfTooBig('id2');adjustFontSizeIfTooBig('id2');adjustLineHeightIfTooBig('id4');adjustFontSizeIfTooBig('id4');adjustLineHeightIfTooBig('id5');adjustFontSizeIfTooBig('id5');Widget.onload();fixupAllIEPNGBGs();fixAllIEPNGs('../../../../Media/transparent.gif');BlogFixupPreviousNext();performPostEffectsFixups()}
function onPageUnload()
{Widget.onunload();}
