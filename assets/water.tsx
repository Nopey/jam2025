<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.11.1" name="water" tilewidth="16" tileheight="16" tilecount="180" columns="12">
 <image source="Water+.png" width="192" height="240"/>
 <tile id="2">
  <animation>
   <frame tileid="4" duration="100"/>
   <frame tileid="2" duration="100"/>
   <frame tileid="3" duration="100"/>
  </animation>
 </tile>
 <tile id="5">
  <animation>
   <frame tileid="5" duration="800"/>
   <frame tileid="6" duration="800"/>
  </animation>
 </tile>
 <tile id="9">
  <animation>
   <frame tileid="9" duration="600"/>
   <frame tileid="10" duration="600"/>
   <frame tileid="11" duration="600"/>
  </animation>
 </tile>
 <tile id="14">
  <animation>
   <frame tileid="14" duration="200"/>
   <frame tileid="15" duration="200"/>
   <frame tileid="16" duration="200"/>
  </animation>
 </tile>
 <tile id="17">
  <animation>
   <frame tileid="17" duration="800"/>
   <frame tileid="18" duration="800"/>
  </animation>
 </tile>
 <tile id="19">
  <animation>
   <frame tileid="19" duration="800"/>
   <frame tileid="20" duration="800"/>
  </animation>
 </tile>
 <tile id="21">
  <animation>
   <frame tileid="21" duration="800"/>
   <frame tileid="22" duration="800"/>
   <frame tileid="23" duration="1000"/>
  </animation>
 </tile>
 <tile id="26">
  <animation>
   <frame tileid="26" duration="200"/>
   <frame tileid="27" duration="200"/>
   <frame tileid="28" duration="200"/>
  </animation>
 </tile>
 <tile id="29">
  <animation>
   <frame tileid="29" duration="800"/>
   <frame tileid="30" duration="800"/>
  </animation>
 </tile>
 <tile id="31">
  <animation>
   <frame tileid="31" duration="800"/>
   <frame tileid="32" duration="800"/>
  </animation>
 </tile>
 <tile id="33">
  <animation>
   <frame tileid="33" duration="800"/>
   <frame tileid="34" duration="800"/>
   <frame tileid="35" duration="1000"/>
  </animation>
 </tile>
 <tile id="39">
  <animation>
   <frame tileid="51" duration="200"/>
   <frame tileid="39" duration="200"/>
   <frame tileid="63" duration="200"/>
  </animation>
 </tile>
 <tile id="42">
  <animation>
   <frame tileid="42" duration="200"/>
   <frame tileid="54" duration="200"/>
   <frame tileid="66" duration="200"/>
  </animation>
 </tile>
 <tile id="43">
  <animation>
   <frame tileid="43" duration="200"/>
   <frame tileid="55" duration="200"/>
   <frame tileid="67" duration="200"/>
  </animation>
 </tile>
 <tile id="52">
  <animation>
   <frame tileid="52" duration="200"/>
  </animation>
 </tile>
 <tile id="56">
  <animation>
   <frame tileid="56" duration="200"/>
   <frame tileid="55" duration="100"/>
   <frame tileid="68" duration="200"/>
  </animation>
 </tile>
 <tile id="122">
  <animation>
   <frame tileid="9" duration="800"/>
   <frame tileid="10" duration="800"/>
   <frame tileid="11" duration="800"/>
  </animation>
 </tile>
 <tile id="156">
  <animation>
   <frame tileid="156" duration="150"/>
   <frame tileid="159" duration="150"/>
   <frame tileid="157" duration="150"/>
  </animation>
 </tile>
 <tile id="157">
  <animation>
   <frame tileid="157" duration="100"/>
   <frame tileid="156" duration="100"/>
  </animation>
 </tile>
 <tile id="160">
  <animation>
   <frame tileid="160" duration="100"/>
   <frame tileid="161" duration="150"/>
   <frame tileid="162" duration="100"/>
   <frame tileid="163" duration="100"/>
  </animation>
 </tile>
 <tile id="173">
  <animation>
   <frame tileid="173" duration="80"/>
   <frame tileid="174" duration="80"/>
   <frame tileid="175" duration="120"/>
   <frame tileid="176" duration="120"/>
   <frame tileid="177" duration="120"/>
   <frame tileid="178" duration="120"/>
   <frame tileid="179" duration="120"/>
  </animation>
 </tile>
 <wangsets>
  <wangset name="pipes" type="mixed" tile="-1">
   <wangcolor name="" color="#ff0000" tile="-1" probability="1"/>
   <wangtile tileid="120" wangid="0,0,1,0,0,0,0,0"/>
   <wangtile tileid="121" wangid="0,0,1,0,0,0,1,0"/>
   <wangtile tileid="122" wangid="0,0,1,0,1,0,1,0"/>
   <wangtile tileid="123" wangid="0,0,0,0,0,0,1,0"/>
   <wangtile tileid="124" wangid="0,0,0,0,1,0,0,0"/>
   <wangtile tileid="125" wangid="0,0,0,0,0,0,1,0"/>
   <wangtile tileid="132" wangid="0,0,1,0,0,0,0,0"/>
   <wangtile tileid="133" wangid="0,0,0,0,1,0,1,0"/>
   <wangtile tileid="134" wangid="1,0,0,0,1,0,0,0"/>
   <wangtile tileid="135" wangid="0,0,1,0,1,0,0,0"/>
   <wangtile tileid="136" wangid="1,0,1,0,1,0,1,0"/>
   <wangtile tileid="137" wangid="0,0,0,0,0,0,1,0"/>
   <wangtile tileid="145" wangid="1,0,1,0,0,0,0,0"/>
   <wangtile tileid="146" wangid="1,0,1,0,0,0,1,0"/>
   <wangtile tileid="147" wangid="1,0,0,0,0,0,1,0"/>
   <wangtile tileid="148" wangid="1,0,0,0,0,0,0,0"/>
  </wangset>
  <wangset name="water" type="edge" tile="-1">
   <wangcolor name="" color="#ff0000" tile="-1" probability="1"/>
   <wangtile tileid="9" wangid="1,0,1,0,1,0,1,0"/>
   <wangtile tileid="10" wangid="1,0,1,0,1,0,1,0"/>
   <wangtile tileid="11" wangid="1,0,1,0,1,0,1,0"/>
  </wangset>
  <wangset name="Unnamed Set" type="mixed" tile="-1">
   <wangcolor name="" color="#ff0000" tile="-1" probability="1"/>
  </wangset>
 </wangsets>
</tileset>
