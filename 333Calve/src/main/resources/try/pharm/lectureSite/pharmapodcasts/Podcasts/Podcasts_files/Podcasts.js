// Created by iWeb 3.0 local-build-20090310

setTransparentGifURL('../Media/transparent.gif');function hostedOnDM()
{return false;}
function photocastSubscribe()
{photocastHelper("http://calve.massey.ac.nz/pharm/lectureSite/pharmapodcasts/Podcasts/rss.xml");}
function onPageLoad()
{loadMozillaCSS('Podcasts_files/PodcastsMoz.css')
adjustLineHeightIfTooBig('id1');adjustFontSizeIfTooBig('id1');adjustLineHeightIfTooBig('id2');adjustFontSizeIfTooBig('id2');detectBrowser();adjustLineHeightIfTooBig('id3');adjustFontSizeIfTooBig('id3');Widget.onload();fixupAllIEPNGBGs();fixAllIEPNGs('../Media/transparent.gif');fixupIECSS3Opacity('id4');performPostEffectsFixups()}
function onPageUnload()
{Widget.onunload();}
