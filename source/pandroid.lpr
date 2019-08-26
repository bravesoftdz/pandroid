{**********************************************************
Copyright (C) 2012-2016
Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com) &
Miran Horjak usbdoo@gmail.com
***********************************************************}
program pandroid;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,  mainform, FNewProject, MainUnit, Dialogs
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);

  if (Paramcount = 5) and (ParamStr(1) = 'R') then begin
     //tAppName,  tJavaPackageName, tRJava, tRJavaPAs
     BuildRJavaFiles(ParamStr(2), ParamStr(3), ParamStr(4), ParamStr(5));
  end else

  if (Paramcount = 6) and (ParamStr(1) = 'B') then
             //ACompPath,    AProjPath,  AJavaPackageName, AProjFile  , AFPCSrcDir
     Build_Apk(ParamStr(2), ParamStr(3), ParamStr(4),      ParamStr(5), ParamStr(6)) //Build apk

  else

    Application.Run ;
end.

