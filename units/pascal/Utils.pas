{**********************************************************
Copyright (C) 2012-2016
Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com) &
Miran Horjak usbdoo@gmail.com
***********************************************************}
unit Utils;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.units.pascal}

interface

uses
  androidr15;

function checkExistsFile(aFileName: JLString): jboolean;

//Date Utils
function FBDateTimeToString: JLString;  //Firebird Date time
function FBDateToString: JLString;  //Firebird Date
function FBTimeToString: JLString;  //Firebird Time

implementation

function checkExistsFile(aFileName: JLString): jboolean;
begin
  Result := JIFile.Create(aFileName).exists;
end;

function FBDateTimeToString: JLString;
begin
   //'2015-12-07 16:46:40'; - Firebird format
  Result := JTSimpleDateFormat.create(JLString('yyyy-MM-dd HH:mm:ss')).format(JUDate.Create);
end;

function FBDateToString: JLString;
begin
  //'2015-12-07 16:46:40'; - Firebird format
  Result := JTSimpleDateFormat.create(JLString('yyyy-MM-dd')).format(JUDate.Create);
end;

function FBTimeToString: JLString;
begin
  //'2015-12-07 16:46:40'; - Firebird format
  Result := JTSimpleDateFormat.create(JLString('HH:mm:ss')).format(JUDate.Create);
end;

end.

