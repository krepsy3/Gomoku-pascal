unit options;

{$mode objfpc}{$H+}

interface

uses
  global,

  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLType;

type

  { TOptionsForm }

  TOptionsForm = class(TForm)
    BlankPanel: TPanel;
    ResetCfgButton: TButton;
    CancelButton: TButton;
    ConfirmButton: TButton;
    Player2AIComboBox: TComboBox;
    Player2AILabel: TLabel;
    KeepCfgButton: TButton;
    StartStrategyComboBox: TComboBox;
    PlayTimeComboBox: TComboBox;
    Player1AIComboBox: TComboBox;
    StartStrategyLabel: TLabel;
    PlayTimeLabel: TLabel;
    Player1AILabel: TLabel;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure KeepCfgButtonClick(Sender: TObject);
    procedure ResetCfgButtonClick(Sender: TObject);
  private

  public

  end;

var
  OptionsForm: TOptionsForm;

implementation

{$R *.lfm}

{ TOptionsForm }

procedure TOptionsForm.FormClick(Sender: TObject);
begin
  FocusControl(BlankPanel);
end;

procedure TOptionsForm.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 5 to High(global.Configuration) do
  begin
    try
      case i of
        5: StartStrategyComboBox.ItemIndex := StrToInt(global.Configuration[i]);
        6: PlayTimeComboBox.ItemIndex := StrToInt(global.Configuration[i]);
        7: Player1AIComboBox.ItemIndex := StrToInt(global.Configuration[i]);
        8: Player2AIComboBox.ItemIndex := StrToInt(global.Configuration[i]);
      end;

    except
      case i of
        5: StartStrategyComboBox.ItemIndex := StrToInt(global.defconfigs[i]);
        6: PlayTimeComboBox.ItemIndex := StrToInt(global.defconfigs[i]);
        7: Player1AIComboBox.ItemIndex := StrToInt(global.defconfigs[i]);
        8: Player2AIComboBox.ItemIndex := StrToInt(global.defconfigs[i]);
      end;
    end;
  end;
end;

procedure TOptionsForm.KeepCfgButtonClick(Sender: TObject);
var
  result: Integer;
begin
  result := Application.MessageBox(
    PChar('Tímto tlačítkem uložíte současné nastavení jako výchozí. ' +
    'Aplikace se po spuštění vždy načte s těmito nastavení. Chcete to udělat?'),
    'Uložení výchozího nastavení', MB_ICONQUESTION + MB_OKCANCEL + MB_DEFBUTTON1);

  if result = 1 then
  begin
    global.ResetConfig := false;
    global.ScheduleDoNotSave := true;
    Application.MessageBox(
      PChar('Uloženo. Od teď se aplikace vždy bude spouštět s těmito ' +
      'parametry. Nyní prosím aplikaci vypněte a znovu spusťte.'),
      'Uložení úspěšné', MB_OK + MB_ICONINFORMATION);
    Application.Terminate;
  end;
end;

procedure TOptionsForm.ResetCfgButtonClick(Sender: TObject);
var
  result: Integer;
begin
  result := Application.MessageBox(
    'Tímto tlačítkem vyresetujete nastavení aplikace na výchozí. Chcete to udělat?',
    'Reset nastavení', MB_ICONQUESTION + MB_OKCANCEL + MB_DEFBUTTON2);

  if result = 1 then
  begin
    global.ResetConfig := true;
    Application.MessageBox(
      'Reset byl proveden. Nyní prosím vypněte a znovu spusťte aplikaci.',
      'Reset úspěšný', MB_OK + MB_ICONINFORMATION);
    Application.Terminate;
  end;
end;

end.

