<!DOCTYPE html>
<html class="ima-sdk-frame ima-sdk-frame-native">
<head>
<meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
<title></title>
<script type="text/javascript">
// Copyright 2011 Google Inc. All Rights Reserved.
(function(){var b=this,e=function(){};var g=String.prototype.trim?function(a){return a.trim()}:function(a){return a.replace(/^[\s\xa0]+|[\s\xa0]+$/g,"")},l=function(a){return null==a?"":String(a)},m=function(a,c){return a<c?-1:a>c?1:0};var n=Array.prototype.indexOf?function(a,c,d){return Array.prototype.indexOf.call(a,c,d)}:function(a,c,d){d=null==d?0:0>d?Math.max(0,a.length+d):d;if("string"==typeof a)return"string"==typeof c&&1==c.length?a.indexOf(c,d):-1;for(;d<a.length;d++)if(d in a&&a[d]===c)return d;return-1},p=Array.prototype.forEach?function(a,c,d){Array.prototype.forEach.call(a,c,d)}:function(a,c,d){for(var r=a.length,t="string"==typeof a?a.split(""):a,f=0;f<r;f++)f in t&&c.call(d,t[f],f,a)};var q;a:{var u=b.navigator;if(u){var v=u.userAgent;if(v){q=v;break a}}q=""};var x=function(a,c){var d=w;Object.prototype.hasOwnProperty.call(d,a)||(d[a]=c(a))};var y=-1!=q.indexOf("Opera"),z=-1!=q.indexOf("Trident")||-1!=q.indexOf("MSIE"),A=-1!=q.indexOf("Edge"),B=-1!=q.indexOf("Gecko")&&!(-1!=q.toLowerCase().indexOf("webkit")&&-1==q.indexOf("Edge"))&&!(-1!=q.indexOf("Trident")||-1!=q.indexOf("MSIE"))&&-1==q.indexOf("Edge"),C=-1!=q.toLowerCase().indexOf("webkit")&&-1==q.indexOf("Edge"),D=function(){var a=b.document;return a?a.documentMode:void 0},E;
a:{var F="",G=function(){var a=q;if(B)return/rv:([^\);]+)(\)|;)/.exec(a);if(A)return/Edge\/([\d\.]+)/.exec(a);if(z)return/\b(?:MSIE|rv)[: ]([^\);]+)(\)|;)/.exec(a);if(C)return/WebKit\/(\S+)/.exec(a);if(y)return/(?:Version)[ \/]?(\S+)/.exec(a)}();G&&(F=G?G[1]:"");if(z){var H=D();if(null!=H&&H>parseFloat(F)){E=String(H);break a}}E=F}
var I=E,w={},J=function(a){x(a,function(){for(var c=0,d=g(String(I)).split("."),r=g(String(a)).split("."),t=Math.max(d.length,r.length),f=0;0==c&&f<t;f++){var h=d[f]||"",k=r[f]||"";do{h=/(\d*)(\D*)(.*)/.exec(h)||["","","",""];k=/(\d*)(\D*)(.*)/.exec(k)||["","","",""];if(0==h[0].length&&0==k[0].length)break;c=m(0==h[1].length?0:parseInt(h[1],10),0==k[1].length?0:parseInt(k[1],10))||m(0==h[2].length,0==k[2].length)||m(h[2],k[2]);h=h[3];k=k[3]}while(0==c)}return 0<=c})},K;var L=b.document;
K=L&&z?D()||("CSS1Compat"==L.compatMode?parseInt(I,10):5):void 0;var M;if(!(M=!B&&!z)){var N;if(N=z)N=9<=Number(K);M=N}M||B&&J("1.9.1");z&&J("9");var P=function(){this.a="";this.b=O},O={};e.a=0;e.b=0;e.c={LATEST:"3.41.1",LOCAL:"","a.3.0b5":"3.0b5","a.3.0b4":"3.0b5","a.3.0b3":"3.0b5","a.3.0b2":"3.0b5","a.3.0b1":"3.0b5","i.3.0.b1":"3.18.1","i.3.0.b2":"3.18.1","i.3.0.b3":"3.18.1","i.3.0.b4":"3.18.1","i.3.0.b5":"3.18.1","i.3.0.b6":"3.18.1","i.3.0.b7":"3.18.1","i.3.0.b8":"3.18.1","i.3.0.b9":"3.18.1","i.3.0.b10":"3.18.1","i.3.0.b11":"3.18.1","i.3.0.b12":"3.18.1"};e.l="af am ar bg bn ca cs da de el en en_gb es es_419 et eu fa fi fil fr fr_ca gl gu he hi hr hu id in is it iw ja kn ko lt lv ml mr ms nb nl no pl pt_br pt_pt ro ru sk sl sr sv sw ta te th tr uk ur vi zh_cn zh_hk zh_tw zu".split(" ");
e.g="LATEST";e.f="en";e.j="//imasdk.googleapis.com/native/core/";e.h=!1;e.i="native_bridge__";e.u=function(){return e.a};e.v=function(){return e.b};e.load=function(){var a=document.createElement("SCRIPT");var c=e.m(),d=new P;d.a=c;a.src=d instanceof P&&d.constructor===P&&d.b===O?d.a:"type_error:TrustedResourceUrl";a.type="text/javascript";document.getElementsByTagName("head")[0].appendChild(a)};e.s=function(){return e.h};
e.m=function(){var a=window.location.href.match(/\?(.*)/)||[],c={};p(l(a[1]).split("&"),function(a){a=a.split("=");c[decodeURIComponent(l(a[0]).replace(/\+/g," "))]=decodeURIComponent(l(a[1]).replace(/\+/g," "))});a=c.sdk_version;var d=c.hl;void 0!==c.enable_external_notify?e.a=1:void 0!==c.mt&&(e.a=parseInt(c.mt,10));void 0!==c.wvr?e.b=parseInt(c.wvr,10):void 0!==c.use_cp&&(e.b=1);return e.o(l(a),l(d))};
e.o=function(a,c){var d=e.c;null!==d&&a in d||(a=e.g);c=c.toLowerCase().replace("-","_");0<=n(e.l,c)||(c=e.f);a=e.j+e.c[a];return a+(/^[\s\xa0]*$/.test(a)?"":"/")+e.i+c+".js"};var Q=["google","ima","NativeLoader"],R=window||b;Q[0]in R||!R.execScript||R.execScript("var "+Q[0]);for(var S;Q.length&&(S=Q.shift());)Q.length||void 0===e?R[S]&&R[S]!==Object.prototype[S]?R=R[S]:R=R[S]={}:R[S]=e;e.load=e.load;e.getMessagingType=e.u;e.getWebViewRendering=e.v;e.getIsChinaLoader=e.s;})();

</script>
</head>
<body>
<script type="text/javascript">
window.onload = function() {
google.ima.NativeLoader.load();
};
</script>
</body>
</html>


