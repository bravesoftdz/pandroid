{**********************************************************
Copyright (C) 2012-2016
Zeljko Cvijanovic www.zeljus.com (cvzeljko@gmail.com) &
Miran Horjak usbdoo@gmail.com
***********************************************************}
unit Dialogs;

{$mode objfpc}{$H+}
{$modeswitch unicodestrings}
{$namespace zeljus.com.units.dialogs}

interface

uses
  androidr15;

type
  TOnClickEvent   = procedure (para1: ACDialogInterface; para2: jint) of object;

  TTypeButton = (btNegative, btPositive, btNeutral);

  { TDialog }

  TDialog = class(AAAlertDialog, ACDialogInterface.InnerOnClickListener)
  private
   fID: integer;
   FOnClick: TOnClickEvent;
  public
    procedure onClick(para1: ACDialogInterface; para2: jint); overload;
  public
   constructor create(para1: ACContext); overload; virtual;
   procedure AddButton(aTypeButton: TTypeButton; aName: JLCharSequence);
  public
   property ID: integer read fID write fID;
   property OnClickListener: TOnClickEvent read FOnClick write FOnClick;
  end;

  { TTimePickerDialog }

  TTimePickerDialog = class(TDialog)
  private
    FTimePicker: AWTimePicker;
  public
    constructor create(para1: ACContext); override;
  public
    property TimePicker: AWTimePicker read FTimePicker;
  end;

  { TDatePickerDialog }

  TDatePickerDialog = class(TDialog)
  private
    FDatePicker: AWDatePicker;
  public
    constructor create(para1: ACContext); override;
  public
    property DatePicker: AWDatePicker read FDatePicker;
  end;

implementation

{ TDialog }

procedure TDialog.onClick(para1: ACDialogInterface; para2: jint);
begin
  if Assigned(FOnClick) then FOnClick(para1, para2);
end;

constructor TDialog.create(para1: ACContext);
begin
  inherited Create(para1);
  setTitle(AAActivity(para1).getPackageManager.getApplicationLabel(AAActivity(para1).getApplicationInfo));
  setIcon(AAActivity(para1).getPackageManager.getApplicationIcon(AAActivity(para1).getApplicationInfo));
end;

procedure TDialog.AddButton(aTypeButton: TTypeButton; aName: JLCharSequence);
begin
  case aTypeButton of
   btNegative : setButton(ACDialogInterface.BUTTON_NEGATIVE, aName, Self);
   btPositive : setButton(ACDialogInterface.BUTTON_POSITIVE, aName, Self);
   btNeutral  : setButton(ACDialogInterface.BUTTON_NEUTRAL, aName, Self);
  end;
end;

{ TDatePickerDialog }


constructor TDatePickerDialog.create(para1: ACContext);

begin
  inherited Create(para1);
  FDatePicker := AWDatePicker.create(getContext);
  Self.setView(FDatePicker);
end;

{ TTimePickerDialog }

constructor TTimePickerDialog.create(para1: ACContext);
begin
  inherited Create(para1);
  FTimePicker:= AWTimePicker.create(getContext);
  Self.setView(FTimePicker);

end;



end.

