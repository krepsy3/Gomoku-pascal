program piskvorky;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Dialogs, LCLType, gomoku_board, options, Default_AI, global,
  { you can add units after this }
  Fileutil, SysUtils, LazFileUtils, character
  ;

{$R *.res}

var
  ldconfig: array of string;

const
  configs: array[0..9] of string =
    ('type1=','type2=','name1=','name2=','begins1=',
     'startstrategy=','timelimit=','difficulty1=','difficulty2=','DONOTSAVE');

  appfolder: string = 'gomoku-krepsy-mff';
  cfgname: string = 'config.txt';


{Auxiliary method to determine if string is a non-negative number}
function IsNumberString(ForCheck: String): Boolean;
var
  i: Integer;
begin
  IsNumberString := False;
  for i := 1 to Length(ForCheck) do
    if not IsNumber(ForCheck[i]) then Exit;

  IsNumberString := True;
end;

{Auxiliary method for displaying error message after file error}
procedure DisplayErrorBox(EventNo: Byte; Message: String);
var
  ConcatenatedError: PChar;
begin
  ConcatenatedError := '';

  case EventNo of
  0:
    ConcatenatedError := PChar(
      'Nastala neznámá chyba při otevírání konfiguračního souboru. ' +
      'Aplikace bude načtena ve výchozím stavu nastavení.' +
      LineEnding + 'Chybová hláška: ' + Message);

  1:
    ConcatenatedError := PChar(
      'Nastala neznámá chyba při ukládání konfiguračního souboru. ' +
      'Nastavení aplikace nebylo úspěšně uloženo. ' +
      'Konfigurační soubor byl možná omylem označen jako jen pro čtení.' +
      LineEnding + 'Chybová hláška: ' + Message);

  2:
    ConcatenatedError := PChar(
      'Varování - jedna nebo více položek konfiguračního souboru byla ' +
      'nesprávně naformátována. Příslušná nastavení byla uvedena do výchozího' +
      ' stavu a budou znovu uložena (jako obvykle) při ukončení aplikace.');
  end;

  if Length(ConcatenatedError) > 0 then
    Application.MessageBox(ConcatenatedError, 'Chyba Konfiguračního souboru',
      MB_OK + MB_ICONWARNING);
end;


{Loads in default configs and attempts to load config file}
procedure LoadOrCreateConfig;
var
  path, line: String;
  f: Text;
  i: Integer;
  cfgvalid: Boolean;

begin
  SetLength(ldconfig, Length(Global.defconfigs));
  for i := 0 to High(Global.defconfigs) do ldconfig[i] := Global.defconfigs[i];

  try
  begin
    cfgvalid := true;

    path := GetEnvironmentVariable('appdata') + PathDelim + appfolder;
    if not DirectoryExists(path) then CreateDir(path);
    path +=  PathDelim + cfgname;
    Assign(f, path);

    if FileExists(path) then
    begin
      Reset(f);

      while not EOF(f) do
      begin
        ReadLn(f, line);
        for i := 0 to High(configs) do
          if CompareStr(configs[i], Copy(line,1,Length(configs[i]))) = 0 then
          begin
            if i <= High(ldconfig) then
            begin
              ldconfig[i] :=
                Trim(Copy(line, Length(configs[i]) + 1,
                          Length(line) - Length(configs[i])));

              if ((i < 2) or (i > 3)) and (not IsNumberString(ldconfig[i])) then
              begin
                ldconfig[i] := global.defconfigs[i];
                cfgvalid := false;
              end;

              Break;

            end

            else if Trim(line) = configs[9] then global.DoNotSave := true;
          end;
      end;
    end;

    if not cfgvalid then DisplayErrorBox(2, '');
  end;

  except
    on E: Exception do DisplayErrorBox(0, E.Message);
  end;

  try
    Close(f);
  except
    
  end;
end;

{Attempts to save the configfile}
procedure SaveConfig;
var
  path, line: String;
  f: Text;
  i: Integer;

begin
  try
  begin
    if global.ResetConfig then
    begin
      global.DoNotSave := false;
      global.ScheduleDoNotSave := false;
    end;

    path := GetEnvironmentVariable('appdata') + PathDelim + appfolder;
    if not DirectoryExists(path) then CreateDir(path);
    path +=  PathDelim + cfgname;
    Assign(f, path);
    Rewrite(f);

    for i := 0 to High(global.defconfigs) do
    begin
      if (not global.ResetConfig) and (not global.DoNotSave) then
      begin
        case i of
          0: line := IntToStr(gomokuBoardForm.Player1ComboBox.ItemIndex);
          1: line := IntToStr(gomokuBoardForm.Player2ComboBox.ItemIndex);
          2: line := gomokuBoardForm.Player1NameEdit.Text;
          3: line := gomokuBoardForm.Player2NameEdit.Text;
          4: line := BoolToStr(gomokuBoardForm.Player1StartRadioButton.Checked, '1', '0');
          5: line := IntToStr(OptionsForm.StartStrategyComboBox.ItemIndex);
          6: line := IntToStr(OptionsForm.PlayTimeComboBox.ItemIndex);
          7: line := IntToStr(OptionsForm.Player1AIComboBox.ItemIndex);
          8: line := IntToStr(OptionsForm.Player2AIComboBox.ItemIndex);
        end;

        WriteLn(f, configs[i] + line);

      end
      else if global.ResetConfig then
        WriteLn(f, configs[i] + global.defconfigs[i])

      else
        WriteLn(f, configs[i] + global.Configuration[i]);
    end;

    if global.DoNotSave or global.ScheduleDoNotSave then
      WriteLn(f, configs[9]);
  end;
  except
    on E: Exception do DisplayErrorBox(1, E.Message);
  end;

  Close(f);
end;


{MAIN APPLICATION BODY}
begin
  Application.Scaled:=True;
  RequireDerivedFormResource := True;

  global.DoNotSave := false;
  global.ScheduleDoNotSave := false;
  LoadOrCreateConfig;                       
  global.Configuration := ldconfig;
  global.ResetConfig := false;
  Randomize;

  Application.Initialize;
  Application.CreateForm(TgomokuBoardForm, gomokuBoardForm);
  Application.CreateForm(TOptionsForm, OptionsForm);
  Application.Run;

  SaveConfig();
end.

