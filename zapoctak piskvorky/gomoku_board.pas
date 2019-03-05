unit gomoku_board;

{$mode objfpc}{$H+}

interface

uses
  options, Default_AI, global,

  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, Buttons, LCLType, dateutils;

type

  { TgomokuBoardForm }

  TgomokuBoardForm = class(TForm)
    BigColonLabel: TLabel;
    BlankPanel: TPanel;
    InfoButton: TButton;
    Player1ScoreLabel: TLabel;
    OnPlayNameLabel: TLabel;
    Player2ScoreLabel: TLabel;
    QuitButton: TButton;
    NewGameButton: TButton;
    SurrenderButton: TButton;
    TieButton: TButton;
    GameFieldPanel: TPanel;
    IndividualTimerLabel: TLabel;
    OptionsButton: TButton;
    MainTimerLabel: TLabel;
    OnPlayGroupBox: TGroupBox;
    StartButton: TButton;
    CaptionLabel: TLabel;
    GamePanel: TPanel;
    MainTimer: TTimer;
    IndividualTimer: TTimer;
    WhoLabel: TLabel;
    Player1NameEdit: TEdit;
    MenuPanel: TPanel;
    Player1ComboBox: TComboBox;
    Player2NameEdit: TEdit;
    Player1StartRadioButton: TRadioButton;
    Player2ComboBox: TComboBox;
    Player2StartRadioButton: TRadioButton;
    TypeLabel: TLabel;
    NameLabel: TLabel;
    StartsLabel: TLabel;
    OnPlaySymbolPanel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure GameFieldPanelClick(Sender: TObject);
    procedure GameFieldPanelMouseLeave(Sender: TObject);
    procedure GameFieldPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure IndividualTimerTimer(Sender: TObject);
    procedure InfoButtonClick(Sender: TObject);
    procedure MainTimerTimer(Sender: TObject);
    procedure NewGameButtonClick(Sender: TObject);
    procedure OptionsButtonClick(Sender: TObject);
    procedure PaintGameField(Sender: TObject);
    procedure Player1ComboBoxSelect(Sender: TObject);
    procedure Player1NameEditChange(Sender: TObject);
    procedure PlayerStartRadioButtonClick(Sender: TObject);
    procedure Player2ComboBoxSelect(Sender: TObject);
    procedure Player2NameEditChange(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure SurrenderButtonClick(Sender: TObject);
    procedure SymbolPanelPaint(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure DefocusControls(Sender: TObject);
    procedure TieButtonClick(Sender: TObject);

    procedure StartNewGame;
    procedure ProcessMove;
    procedure EndGame;
    procedure TerminateGame(whowon: Byte);
  private
    {%Region Common game variables}
      {The game field (grid)}
      GameField: GameFieldArray;

      {Coords of most recently placed symbol - For Painting}
      GameLastSymbolX: Integer;
      GameLastSymbolY: Integer;

      {Determines if the game has processed last turn}
      GamePlayerTurnProcessed: Boolean;

      {Coords of the symbol placed in last turn waiting to be processed}
      GamePlayerX: Integer;
      GamePlayerY: Integer;

      {Determines the player which will play first in the next game (1-t, 2-f)}
      GameIsP1ToStart: Boolean;

      {Coords of winning sequence - For Painting}
      GameVictoryX1: Integer; 
      GameVictoryY1: Integer;
      GameVictoryX2: Integer;
      GameVictoryY2: Integer;

      {Zero of the timer stopwacth}
      MainTimeZero: TDateTime;
      IndividualTimeZero: TDateTime;
    {%EndRegion}

    {%Region property store vars}
      _gameCursorX: Integer;
      _gameCursorY: Integer;
      _gamestate: Boolean; 
      _onplay: Byte;
      _player1score: Integer;
      _player2score: Integer;
      _maintime: TDateTime;
      _individualtime: TDateTime;

      _player1type: Byte;
      _player2type: Byte;
      _player1name: String;
      _player2name: String;
      _player1begins: Boolean;
      _player1aidiff: Byte;
      _player2aidiff: Byte;
      _turntimelimit: Byte;
      _nexttostartstrat: Byte;
    {%EndRegion}


    {%Region Game State Properties}
      {Current coords of the cursor in the game field}
      procedure ChangeGameCursorX(newX: Integer);
      property GameCursorX: Integer read _gameCursorX write ChangeGameCursorX;
      procedure ChangeGameCursorY(newY: Integer);
      property GameCursorY: Integer read _gameCursorY write ChangeGameCursorY;

      {Determines, whether the form is focused on main menu (f) or game (t)}
      procedure ChangeGameState(newstate: Boolean);
      property GameState: Boolean read _gamestate write ChangeGameState;

      {Number of the player which is on move (0-nobody, 1..2)}
      procedure ChangeOnPlay(newplay: Byte);
      property OnPlay: Byte read _onplay write ChangeOnPlay;

      {Player scores}
      procedure ChangePlayer1Score(newscore: Integer);
      property Player1Score: Integer read _player1score write ChangePlayer1Score;
      procedure ChangePlayer2Score(newscore: Integer);
      property Player2Score: Integer read _player2score write ChangePlayer2Score;

      {Timer values}
      procedure ChangeMainTime(newtime: TDateTime);
      property MainTime: TDateTime read _maintime write ChangeMainTime;
      procedure ChangeIndividualTime(newtime: TDateTime);
      property IndividualTime: TDateTime read _individualtime write ChangeIndividualTime;
    {%EndRegion}

    {%Region Game Settings Properties}
      {Player types (0-human, 1.. -ai from tcombobox}
      procedure ChangePlayer1Type(newtype: Byte);
      property Player1Type: Byte read _player1type write ChangePlayer1Type;
      procedure ChangePlayer2Type(newtype: Byte);
      property Player2Type: Byte read _player2type write ChangePlayer2Type;
      
      {Player names, if nothing, uses placeholder text from respective tedit}
      procedure ChangePlayer1Name(newname: String);
      property Player1Name: String read _player1name write ChangePlayer1Name;
      procedure ChangePlayer2Name(newname: String);
      property Player2Name: String read _player2name write ChangePlayer2Name;

      {Determines player, which will play first in the first game (1-t, 0-f)}
      procedure ChangePlayer1Begins(newbegins: Boolean);
      property Player1Begins: Boolean read _player1begins write ChangePlayer1Begins;
      
      {Player AI difficulty settings (0..2)}
      procedure ChangePlayer1Aidiff(newdiff: Byte);
      property Player1Aidiff: Byte read _player1aidiff write ChangePlayer1Aidiff;
      procedure ChangePlayer2Aidiff(newdiff: Byte);
      property Player2Aidiff: Byte read _player2aidiff write ChangePlayer2Aidiff;

      {Time limit of each player's turn (0..5 - values from tcombobox}
      procedure ChangeTurnTimeLimit(newlimit: Byte);
      property TurnTimeLimit: Byte read _turntimelimit write ChangeTurnTimeLimit;

      {Next game's first player selection strategy (0..4 - values from tcombobox}
      procedure ChangeNextToStartStrat(newstrat: Byte);
      property NextToStartStrat: Byte read _nexttostartstrat write ChangeNextToStartStrat;
    {%EndRegion}


    {%Region Constants}
      {Colors of player symbols in enabled and disabled state}
      const XEnColor: TColor = clBlue;
      const XDsColor: TColor = clNavy;
      const OEnColor: TColor = clRed;
      const ODsColor: TColor = clMaroon;

      {Background color of currently focused and unfocused panel}
      const EnabledPnlColor: TColor = TColor($F2FFF2);
      const DisabledPnlColor: TColor = clWhite;
    {%EndRegion}

  public

  end;

  { TgomokuBoardForm }

var
  gomokuBoardForm: TgomokuBoardForm;
implementation

{$R *.lfm}

{%Region Game State Property Setters}
  procedure TgomokuBoardForm.ChangeGameState(newstate: Boolean);
  var
    enpnl, dspnl: TPanel;
  begin
    _gamestate := newstate;

    {%Region assign panels}
    if gamestate then
    begin
      enpnl := GamePanel;
      dspnl := MenuPanel;
    end
    else
    begin
      enpnl := MenuPanel;
      dspnl := GamePanel;
    end;
    {%EndRegion}

    {%Region assign panel props}
    enpnl.Enabled := True;
    enpnl.BevelInner := bvRaised;
    enpnl.Color := EnabledPnlColor;

    dspnl.Enabled := False;
    dspnl.BevelInner := bvNone;
    dspnl.Color := DisabledPnlColor;
    {%Endregion}

    {Focus the enabled panel - while constructing, this handler is called,
    but invisible control can't get focus and would raise exception}
    if enpnl.IsVisible then FocusControl(enpnl);
  end;

  procedure TgomokuBoardForm.ChangeGameCursorX(newX: Integer);
  var
    callrepaint: Boolean;
  begin
    callrepaint := false;
    if newX <> _gameCursorX then callrepaint := true;

    _gameCursorX := newX;

    if callrepaint then GameFieldPanel.Invalidate;
  end;

  procedure TgomokuBoardForm.ChangeGameCursorY(newY: Integer);
  var
    callrepaint: Boolean;
  begin
    callrepaint := false;
    if newY <> _gameCursorY then callrepaint := true;

    _gameCursorY := newY;

    if callrepaint then GameFieldPanel.Invalidate;
  end;

  procedure TgomokuBoardForm.ChangeOnPlay(newplay: Byte);
  var
    callrepaint: Boolean;
  begin
    callrepaint := false;
    if _onplay <> newplay then callrepaint := true;

    _onplay := newplay;
    case _onplay of
      1: OnPlayNameLabel.Caption := Player1Name;
      2: OnPlayNameLabel.Caption := Player2Name;
      else OnPlayNameLabel.Caption := '';
    end;

    if callrepaint then OnPlaySymbolPanel.Invalidate;
  end;

  procedure TGomokuBoardForm.ChangePlayer1Score(newscore: Integer);
  begin
    _player1score := newscore;
    Player1ScoreLabel.Caption := IntToStr(_player1score);
  end;

  procedure TGomokuBoardForm.ChangePlayer2Score(newscore: Integer);
  begin
    _player2score := newscore;
    Player2ScoreLabel.Caption := IntToStr(_player2score);
  end;

  {Auxiliary procedure to change the label displaying time value}
  procedure ChangeTimerLabel(actualtime, zerotime: TDateTime;
                             var changedlabel: TLabel; showhours: Boolean);
  var
    totalms: LongInt;
    h,m,s,ts:Integer;
  begin
    totalms := MilliSecondsBetween(actualtime, zerotime);

    h  := Trunc(totalms / 3600000);
    m  := Trunc((totalms - (h*3600000)) / 60000);
    s  := Trunc((totalms - (h*3600000) - (m*60000)) / 1000);
    ts := Trunc((totalms - (h*3600000) - (m*60000) - (s*1000)) / 100);

    changedlabel.Caption := '';
    if showhours then changedlabel.Caption := IntToStr(h) + ':';

    changedlabel.Caption :=
      changedLabel.Caption + IntToStr(m) + ':' + IntToStr(s) + '.' + IntToStr(ts);
  end;

  procedure TGomokuBoardForm.ChangeMainTime(newtime: TDateTime);
  begin
    _maintime := newtime;
    ChangeTimerLabel(_maintime, MainTimeZero, MainTimerLabel, True);
  end;

  procedure TGomokuBoardForm.ChangeIndividualTime(newtime: TDateTime);
  var
    slashstr: String;
  begin
    _individualtime := newtime;
    ChangeTimerLabel(_individualtime, IndividualTimeZero, IndividualTimerLabel, False);

    if TurnTimeLimit > 0 then
    begin
      case TurnTimeLimit of
        1: slashstr := ' / 0:10';
        2: slashstr := ' / 0:20';
        3: slashstr := ' / 0:30';
        4: slashstr := ' / 1:00';
        5: slashstr := ' / 2:00';
      end;

      IndividualTimerLabel.Caption := IndividualTimerLabel.Caption + slashstr;
    end;
  end;
{%EndRegion}

{%Region Game Settings Propery Setters}
  procedure TgomokuBoardForm.ChangePlayer1Type(newtype: Byte);
  begin
    _player1type := newtype;
  end;

  procedure TgomokuBoardForm.ChangePlayer2Type(newtype: Byte);
  begin
    _player2type := newtype;
  end;

  procedure TgomokuBoardForm.ChangePlayer1Name(newname: String);
  begin
    _player1name := newname;
    if Trim(_player1name) = '' then _player1name := Player1NameEdit.TextHint;
  end;

  procedure TgomokuBoardForm.ChangePlayer2Name(newname: String);
  begin
    _player2name := newname;
    if Trim(_player2name) = '' then _player2name := Player2NameEdit.TextHint;
  end;

  procedure TgomokuBoardForm.ChangePlayer1Aidiff(newdiff: Byte);
  begin
    _player1aidiff := newdiff;
  end;

  procedure TgomokuBoardForm.ChangePlayer2Aidiff(newdiff: Byte);
  begin
    _player2aidiff := newdiff;
  end;

  procedure TgomokuBoardForm.ChangePlayer1Begins(newbegins: Boolean);
  begin
    _player1begins := newbegins;
  end;
  
  procedure TgomokuBoardForm.ChangeTurnTimeLimit(newlimit: Byte);
  begin
    _turntimelimit := newlimit;
  end;
                                                                 
  procedure TgomokuBoardForm.ChangeNextToStartStrat(newstrat: Byte);
  begin
    _nexttostartstrat := newstrat;
  end;
{%EndRegion}


{%Region Window Handlers}
  procedure TgomokuBoardForm.FormCreate(Sender: TObject);
  var
    i, j: Integer;
  begin
    {%Region Prepare Game Field}
      SetLength(gamefield,15,15);
      for i := 0 to 14 do for j := 0 to 14 do gamefield[i][j] := 0;

      GameState := False;
      GamePlayerTurnProcessed := True;
      OnPlay := 0;
      GamePlayerX := -1;
      GamePlayerY := -1;
      GameLastSymbolX := -1;
      GameLastSymbolY := -1;
      GameCursorX := -1;
      GameCursorY := -1;
      GameVictoryX1 := -1;
      GameVictoryY1 := -1;
      GameVictoryX2 := -1;
      GameVictoryY2 := -1;
      Player1Score := 0;  
      Player2Score := 0;
    {%EndRegion}

    {%Region Load game settings to Controls}
    Player1ComboBox.Items.Add(Default_AI.GetAIName);
    Player2ComboBox.Items.Add(Default_AI.GetAIName);

    for i := 0 to High(global.Configuration) do
    begin
      case i of
        0:
          begin
            Player1Type := StrToInt(global.Configuration[i]);
            Player1ComboBox.ItemIndex := StrToInt(global.Configuration[i]);
          end;
        1:
          begin
            Player2Type := StrToInt(global.Configuration[i]);
            Player2ComboBox.ItemIndex := StrToInt(global.Configuration[i]);
          end;
        2:
          begin
            Player1Name := global.Configuration[i];
            Player1NameEdit.Text := global.Configuration[i];
          end;
        3:
          begin
            Player2Name := global.Configuration[i];
            Player2NameEdit.Text := global.Configuration[i];
          end;
        4:
          begin
            if global.Configuration[i] = '1' then
              Player1StartRadioButton.Checked := true
            else
              Player2StartRadioButton.Checked := true;

            Player1Begins := global.Configuration[i] = '1';
          end;

        5: NextToStartStrat := StrToInt(global.Configuration[i]);
        6: TurnTimeLimit := StrToInt(global.Configuration[i]);
        7: Player1Aidiff := StrToInt(global.Configuration[i]);
        8: Player2Aidiff := StrToInt(global.Configuration[i]);
      end;
    end;
    {%EndRegion}
  end;

  procedure TgomokuBoardForm.DefocusControls(Sender: TObject);
  begin
    FocusControl(BlankPanel);
  end;
{%EndRegion}

{%Region OnPaint Handlers}
  procedure TgomokuBoardForm.SymbolPanelPaint(Sender: TObject);
  var
    Xx1, Xy1, Ox1, Oy1: Integer;
    scale: Real;
    pnl: TPanel;
  begin
    pnl := TPanel(Sender);

    {%Region Assign coords}
    Xx1 := -50;
    Xy1 := -50;
    Ox1 := -50;
    Oy1 := -50;
    scale := 1;

    if pnl.Name = 'MenuPanel' then
    begin
      Xx1 := 30;
      Xy1 := 76;
      Ox1 := 28;
      Oy1 := 34;
    end

    else if pnl.Name = 'GamePanel' then
    begin
      Xx1 := 537;
      Xy1 := 240;
      Ox1 := 448;
      Oy1 := 236;
    end

    else if (pnl.Name = 'OnPlaySymbolPanel') and (OnPlay = 1) then
    begin
      Ox1 := 56;
      Oy1 := 3;
      scale := 1.8;
    end

    else if (pnl.Name = 'OnPlaySymbolPanel') and (OnPlay = 2) then
    begin
      Xx1 := 58;
      Xy1 := 3;
      scale := 1.8
    end;
    {%EndRegion}

    {%Region Paint Symbols}
    pnl.Canvas.Brush.Style := bsClear;
    pnl.Canvas.Pen.Cosmetic := False;
    pnl.Canvas.Pen.Width := Trunc(4*scale);

    if pnl.Enabled then pnl.Canvas.Pen.Color := OEnColor
    else pnl.Canvas.Pen.Color := ODsColor;
    pnl.Canvas.Ellipse(Ox1,Oy1,Ox1 + Round(29*scale),Oy1 + Round(29*scale));

    if pnl.Enabled then pnl.Canvas.Pen.Color := XEnColor
    else pnl.Canvas.Pen.Color := XDsColor;
    pnl.Canvas.Line(Xx1,Xy1,Xx1 + Round(25*scale),Xy1 + Round(25*scale));
    pnl.Canvas.Line(Xx1,Xy1 + Round(25*scale),Xx1 + Round(25*scale),Xy1);
    {%EndRegion}
  end;

  procedure TgomokuBoardForm.PaintGameField(Sender: TObject);
  var
    i, j: Integer;
    pnl: TPanel;
  begin
    pnl := TPanel(Sender);

    {%Region Paint Grid}
    if GameState then pnl.Canvas.Pen.Color := RGBToColor(64,217,254)
    else pnl.Canvas.Pen.Color := RGBToColor(1,103,119);

    pnl.Canvas.Pen.Style := psSolid;

    for i := 1 to High(gamefield) do
      pnl.Canvas.Line(
        i*(pnl.Width div Length(gamefield)),1,
        i*(pnl.Width div Length(gamefield)),pnl.Height - 1);

    for i := 1 to High(gamefield[0]) do
      pnl.Canvas.Line(
        1,i*(pnl.Height div Length(gamefield[0])),
        pnl.Width - 1,i*(pnl.Height div Length(gamefield[0])));
    {%EndRegion}

    {%Region Paint Colored Rects}
    if (GameCursorX >= 0) and (GameCursorY >= 0) then
    begin
      pnl.Canvas.Pen.Style := psClear;
      pnl.Canvas.Pen.Width := 0;
      pnl.Canvas.Brush.Color := RGBToColor(239, 239, 239);
      pnl.Canvas.Rectangle(
        GameCursorX*(pnl.Width div Length(gamefield)) + 1,
        GameCursorY*(pnl.Height div Length(gamefield[0])) + 1,
        GameCursorX*(pnl.Width div Length(gamefield)) +
          (pnl.Width div Length(gamefield)) + 1,
        GameCursorY*(pnl.Height div Length(gamefield[0])) +
          (pnl.Height div Length(gamefield[0])) + 1);
    end;

    if (GameLastSymbolX >= 0) and (GameLastSymbolY >= 0)
       and (((GameVictoryX1 < 0) and (GameVictoryY1 < 0))
       or ((GameVictoryX2 < 0) and (GameVictoryY2 < 0))) then
    begin
      pnl.Canvas.Pen.Style := psClear;
      pnl.Canvas.Pen.Width := 0;
      pnl.Canvas.Brush.Color := RGBToColor(255, 251, 140);
      pnl.Canvas.Rectangle(
        GameLastSymbolX*(pnl.Width div Length(gamefield)) + 1,
        GameLastSymbolY*(pnl.Height div Length(gamefield[0])) + 1,
        GameLastSymbolX*(pnl.Width div Length(gamefield)) +
          (pnl.Width div Length(gamefield)) + 1,
        GameLastSymbolY*(pnl.Height div Length(gamefield[0])) +
          (pnl.Height div Length(gamefield[0])) + 1);
    end;
    {%EndRegion}

    {%Region Paint Symbols}
    pnl.Canvas.Pen.Style := psSolid;
    pnl.Canvas.Pen.Width := 2;
    pnl.Canvas.Brush.Style := bsClear;

    pnl.Canvas.Pen.Color := OEnColor;
    for i := 0 to High(gamefield) do for j := 0 to High(gamefield[0]) do
      if GameField[i][j] = 1 then
      begin
        pnl.Canvas.Ellipse(
          i*(pnl.Width div Length(gamefield)) + 3,
          j*(pnl.Height div Length(gamefield[0])) + 3,
          (i + 1)*(pnl.Width div Length(gamefield)) - 2,
          (j + 1)*(pnl.Height div Length(gamefield[0])) - 2);
      end;

    pnl.Canvas.Pen.Color := XEnColor;
    for i := 0 to High(gamefield) do for j := 0 to High(gamefield[0]) do
      if gamefield[i][j] = 2 then
      begin
        pnl.Canvas.Line(
          i*(pnl.Width div Length(gamefield)) + 4,
          j*(pnl.Height div Length(gamefield[0])) + 4,
          (i + 1)*(pnl.Width div Length(gamefield)) - 5,
          (j + 1)*(pnl.Height div Length(gamefield[0])) - 5);

        pnl.Canvas.Line(
          i*(pnl.Width div Length(gamefield)) + 4,
          (j + 1)*(pnl.Height div Length(gamefield[0])) - 5,
          (i + 1)*(pnl.Width div Length(gamefield)) - 5,
          j*(pnl.Height div Length(gamefield[0])) + 4);
      end;
    {%EndRegion}

    {%Region Paint VictoryLine}
    if (GameVictoryX1 >= 0) and (GameVictoryX1 >= 0) and
       (GameVictoryX1 >= 0) and (GameVictoryX1 >= 0) then
    begin
      pnl.Canvas.Pen.Width := 4;
      pnl.Canvas.Pen.Color := clBlack;

      if (GameVictoryX1 > GameVictoryX2) or
         ((GameVictoryX1 = GameVictoryX2) and
         (GameVictoryY1 > GameVictoryY2)) then
      begin
        i := GameVictoryX1;
        GameVictoryX1 := GameVictoryX2;
        GameVictoryX2 := i;
        i := GameVictoryY1;
        GameVictoryY1 := GameVictoryY2;
        GameVictoryY2 := i;
      end;


      if GameVictoryX1 = GameVictoryX2 then
        pnl.Canvas.Line(
          GameVictoryX1*(pnl.Width div Length(gamefield)) +
            (pnl.Width div (2*Length(gamefield))) + 1,
          GameVictoryY1*(pnl.Height div Length(gamefield[0])) + 3,
          GameVictoryX2*(pnl.Width div Length(gamefield)) +
            (pnl.Width div (2*Length(gamefield))) + 1,
          (GameVictoryY2 + 1)*(pnl.Height div Length(gamefield[0])) - 3)

      else if GameVictoryY1 = GameVictoryY2 then
        pnl.Canvas.Line(
          GameVictoryX1*(pnl.Width div Length(gamefield)) + 3,
          GameVictoryY1*(pnl.Height div Length(gamefield[0])) +
            (pnl.Height div (2*Length(gamefield[0]))) + 1,
          (GameVictoryX2 + 1)*(pnl.Width div Length(gamefield)) - 3,
          GameVictoryY2*(pnl.Height div Length(gamefield[0])) +
            (pnl.Height div (2*Length(gamefield[0]))) + 1)

      else if GameVictoryY1 < GameVictoryY2 then
        pnl.Canvas.Line(
          GameVictoryX1*(pnl.Width div Length(gamefield)) + 3,
          GameVictoryY1*(pnl.Height div Length(gamefield[0])) + 3,
          (GameVictoryX2 + 1)*(pnl.Width div Length(gamefield)) - 3,
          (GameVictoryY2 + 1)*(pnl.Height div Length(gamefield[0])) - 3)

      else
        pnl.Canvas.Line(
          GameVictoryX1*(pnl.Width div Length(gamefield)) + 3,
          (GameVictoryY1 + 1)*(pnl.Height div Length(gamefield[0])) - 3,
          (GameVictoryX2 + 1)*(pnl.Width div Length(gamefield)) - 3,
          GameVictoryY2*(pnl.Height div Length(gamefield[0])) + 3);
    end;
    {%EndRegion}

    pnl.Canvas.Pen.Width := 1;
    pnl.Canvas.Pen.Color := clBlack;
  end;
{%EndRegion}


{%Region Menu Controls Click Handlers}
  procedure TgomokuBoardForm.InfoButtonClick(Sender: TObject);
  begin
    Application.MessageBox(
      PChar(global.AboutMessage), 'O programu Piškvorky', MB_ICONINFORMATION);
  end;

  procedure TgomokuBoardForm.Player1ComboBoxSelect(Sender: TObject);
  begin
    Player1Type := Player1ComboBox.ItemIndex;
  end;

  procedure TgomokuBoardForm.Player1NameEditChange(Sender: TObject);
  begin
    Player1Name := Player1NameEdit.Text;
  end;

  procedure TgomokuBoardForm.PlayerStartRadioButtonClick(Sender: TObject);
  begin
    if Player1StartRadioButton.Checked then Player1Begins := true
    else Player1Begins := false;
  end;

  procedure TgomokuBoardForm.Player2ComboBoxSelect(Sender: TObject);
  begin  
    Player2Type := Player2ComboBox.ItemIndex;
  end;

  procedure TgomokuBoardForm.Player2NameEditChange(Sender: TObject);
  begin
    Player2Name := Player2NameEdit.Text;
  end;

  procedure TgomokuBoardForm.OptionsButtonClick(Sender: TObject);
  var
    i: Integer;
  begin
    i := OptionsForm.ShowModal;
    if i = 6 then
    begin
      NextToStartStrat := OptionsForm.StartStrategyComboBox.ItemIndex;
      TurnTimeLimit := OptionsForm.PlayTimeComboBox.ItemIndex;
      Player1Aidiff := OptionsForm.Player1AIComboBox.ItemIndex;
      Player2Aidiff := OptionsForm.Player2AIComboBox.ItemIndex;
    end

    else
    begin                                                      
      OptionsForm.StartStrategyComboBox.ItemIndex := NextToStartStrat;
      OptionsForm.PlayTimeComboBox.ItemIndex := TurnTimeLimit;
      OptionsForm.Player1AIComboBox.ItemIndex := Player1Aidiff;
      OptionsForm.Player2AIComboBox.ItemIndex := Player2Aidiff;
    end;
  end;

  procedure TgomokuBoardForm.StartButtonClick(Sender: TObject);
  begin
    GameState := True;
    GameIsP1ToStart := Player1Begins;
    StartNewGame;
  end;
{%EndRegion}
 
{%Region Game Controls Click Handlers}
  procedure TgomokuBoardForm.TieButtonClick(Sender: TObject);
  var
    result: Integer;
    proposer, proposed: string;
  begin
    case OnPlay of
      1:
        begin
          proposer := Player1Name;
          proposed := Player2Name;
        end;
                  
      2:
        begin                     
          proposer := Player2Name;
          proposed := Player1Name;
        end;
    end;
         
    IndividualTimer.Enabled := False;

    result := Application.MessageBox(
      PChar('Hráč ' + proposer + ' vám nabízí remízu. Přijetím bude ' +
      'kolo ihned ukončeno bez bodových změn. Jinak bude opět na tahu hráč ' +
      proposer + '.'), PChar('Zpráva pro hráče ' + proposed),
      MB_ICONQUESTION + MB_OKCANCEL + MB_DEFBUTTON2);

    if result = 1 then TerminateGame(0)
    else
    begin  
      IndividualTimeZero := IndividualTimeZero + Now - IndividualTime;
      IndividualTimer.Enabled := true;
    end;
  end;

  procedure TgomokuBoardForm.SurrenderButtonClick(Sender: TObject);
  var
    result: Integer;
  begin
    IndividualTimer.Enabled := False;

    result := Application.MessageBox(
      'Opravdu se chcete vzdát? Kolo bude ihned ukončeno a soupeř získá body.',
      'Vzdát se?', MB_ICONQUESTION + MB_OKCANCEL + MB_DEFBUTTON1);

    if result = 1 then TerminateGame(3 - OnPlay)
    else
    begin
      IndividualTimeZero := IndividualTimeZero + Now - IndividualTime;
      IndividualTimer.Enabled := true;
    end;
  end;

  procedure TgomokuBoardForm.NewGameButtonClick(Sender: TObject);
  begin
    StartNewGame;
  end;

  procedure TgomokuBoardForm.QuitButtonClick(Sender: TObject);
  begin
    MainTimer.Enabled := False;
    MainTimeZero := Now;                  
    IndividualTimer.Enabled := False;
    IndividualTimeZero := Now;
    OnPlay := 0;
    Player1Score := 0;
    Player2Score := 0; 
    GameState := False;
  end;
{%EndRegion}


{%Region GameFieldPanel Mouse Handlers}
  procedure TgomokuBoardForm.GameFieldPanelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  begin
    GameCursorX := Trunc(X / Trunc(GameFieldPanel.Width / Length(GameField)));
    GameCursorY := Trunc(Y / Trunc(GameFieldPanel.Height / Length(GameField[0])));
  end;

  procedure TgomokuBoardForm.GameFieldPanelMouseLeave(Sender: TObject);
  begin
    GameCursorX := -1;
    GameCursorY := -1;
  end;

  procedure TgomokuBoardForm.GameFieldPanelClick(Sender: TObject);
  begin
    if (((OnPlay = 1) and (Player1Type = 0)) or
       ((OnPlay = 2) and (Player2Type = 0))) and
       (not GamePlayerTurnProcessed) and
       (GamePlayerX < 0) and
       (GamePlayerY < 0) then
      begin
        GamePlayerX := GameCursorX;
        GamePlayerY := GameCursorY;
      end;
  end;
{%EndRegion}


{%Region Timer Handlers}
  procedure TgomokuBoardForm.MainTimerTimer(Sender: TObject);
  begin
    MainTime := Now;
    if (not GamePlayerTurnProcessed) and
       (GamePlayerX >= 0) and (GamePlayerX >= 0) then
    begin
      GamePlayerTurnProcessed := True;
      ProcessMove;
    end;
  end;

  procedure TgomokuBoardForm.IndividualTimerTimer(Sender: TObject);
  var
    diff: Int64;
    lost: Boolean;
    wholost: String;

  begin
    IndividualTime := Now;

    if (((OnPlay = 1) and (Player1Type = 0)) or
       ((OnPlay = 2) and (Player2Type = 0))) and
       (TurnTimeLimit > 0) then
    begin
      diff := MilliSecondsBetween(IndividualTime, IndividualTimeZero);
      lost := false;

      case TurnTimeLimit of
        1: if diff >= 10000  then lost := true;
        2: if diff >= 20000  then lost := true;
        3: if diff >= 30000  then lost := true;
        4: if diff >= 60000  then lost := true;
        5: if diff >= 120000 then lost := true;
      end;

      if lost then
      begin       
        MainTimer.Enabled := False;
        IndividualTimer.Enabled := False;

        if OnPlay = 1 then wholost := Player1Name
        else wholost := Player2Name;

        Application.MessageBox(PChar(
          'Hráč ' + wholost + ' nestihl odehrát včas, takže prohrává!'),
          'Kontumační prohra', MB_ICONINFORMATION + MB_OK);

        TerminateGame(3 - OnPlay);
      end;
    end;
  end;
{%EndRegion}

{%Region Game Flow Procedures}
  {Starts new game, anticipates correct setting of GameIsP1ToStart}
  {Has to be called at the begining of the game, right before the first move}
  procedure TgomokuBoardForm.StartNewGame;
  var
    i,j: Integer;
  begin
    for i := 0 to High(GameField) do for j := 0 to High(Gamefield[0]) do
      gamefield[i][j] := 0;

    GameCursorX := -1;
    GameCursorY := -1;
    GameLastSymbolX := -1;
    GameLastSymbolY := -1;
    GameVictoryX1 := -1;
    GameVictoryY1 := -1;
    GameVictoryX2 := -1;
    GameVictoryY2 := -1;
    GamePlayerX := -1;
    GamePlayerY := -1;
    GamePlayerTurnProcessed := false;

    TieButton.Enabled := False;
    if (Player1Type = 0) and (Player2Type = 0) then TieButton.Enabled := True;

    SurrenderButton.Enabled := True;
    NewGameButton.Enabled := False;  
    QuitButton.Enabled := False;

    if GameIsP1ToStart then OnPlay := 1
    else OnPlay := 2;

    MainTimeZero := Now;           
    MainTimer.Enabled := True;

    IndividualTimeZero := Now;
    IndividualTimer.Enabled := True;

    GameFieldPanel.Invalidate;

    if ((OnPlay = 1) and (Player1Type > 0)) then
      Default_AI.Move(GameField, 1, 2, Player1Aidiff, GamePlayerX, GamePlayerY)

    else if (OnPlay = 2) and (Player2Type > 0) then
      Default_AI.Move(GameField, 2, 1, Player2Aidiff, GamePlayerX, GamePlayerY);
  end;

  {Processes player move, checks for wins, advances game}
  {Has to be called manually after player picked coords to GamePlayerX & Y}
  procedure TgomokuBoardForm.ProcessMove;          
  var
    i,j,x1,y1,x2,y2: Integer;
    foundfreespot: Boolean;
  begin
    {%Region Accept move and swap players}
    if GameField[GamePlayerX][GamePlayerY] = 0 then
    begin
      GameField[GamePlayerX][GamePlayerY] := OnPlay;

      GameLastSymbolX := GamePlayerX;
      GameLastSymbolY := GamePlayerY;
      IndividualTimer.Enabled := false;
      GameFieldPanel.Invalidate;
                                  
      {%Region WinCheck - j0 Left-Right, j1 Up-Down, j2 TopL-BotR, j3 BotL-TopR}

      for j := 0 to 3 do
      begin
        x1 := -1;
        y1 := -1;

        if (GameVictoryX1 < 0) and (GameVictoryY1 < 0) then
        begin
          for i := (-4) to 4 do
          begin
            case j of
              0:
                begin
                  x2 := GameLastSymbolX + i;
                  y2 := GameLastSymbolY;
                end;
              1:
                begin
                  x2 := GameLastSymbolX;
                  y2 := GameLastSymbolY + i;
                end;
              2:
                begin
                  x2 := GameLastSymbolX + i;
                  y2 := GameLastSymbolY + i;
                end;
              3:
                begin
                  x2 := GameLastSymbolX + i;
                  y2 := GameLastSymbolY - i;
                end;
            end;
            if (x2 >= 0) and (x2 <= High(GameField)) and
               (y2 >= 0) and (y2 <= High(GameField[0])) then
            begin
              if GameField[x2][y2] = OnPlay then
              begin
                if (x1 < 0) or (y1 < 0) then
                begin
                  x1 := x2;
                  y1 := y2;
                end

                else if (abs(x1 - x2) >= 4) or (abs(y1 - y2) >= 4) then
                begin
                  GameVictoryX1 := x1;
                  GameVictoryY1 := y1;
                  GameVictoryX2 := x2;
                  GameVictoryY2 := y2;
                end;
              end

              else if (GameVictoryX1 >= 0) or (GameVictoryY1 >= 0) then
                Break

              else
              begin
                x1 := -1;
                y1 := -1;
              end;
            end;
          end;
        end;
      end;
      {%EndRegion}

      if (GameVictoryX1 < 0) and (GameVictoryY1 < 0) then
        OnPlay := 3 - OnPlay;
    end;
    {%EndRegion}

    {%Region Check empty spots availability}
    foundfreespot := false;

    for i := 0 to High(GameField) do
    begin
      for j := 0 to High(GameField[i]) do
      begin
        if GameField[i][j] = 0 then
        begin
          foundfreespot := true;
          Break;
        end;
      end;

      if foundfreespot then Break;
    end;

    if not foundfreespot then
    begin
      MainTimer.Enabled := False;
      Application.MessageBox(
        'Zaplnili jste celé pole, aniž by někdo vyhrál. Remíza!',
        'Automatická remíza', MB_ICONINFORMATION + MB_OK);

      TerminateGame(0);
    end;

    {%EndRegion}

    {%Region Call Next Player or End Game}
    if (GameVictoryX1 < 0) and (GameVictoryY1 < 0) and foundfreespot then
    begin
      GamePlayerX := -1;
      GamePlayerY := -1;
      GamePlayerTurnProcessed := false;

      IndividualTimeZero := Now;
      IndividualTimer.Enabled := True;

      if ((OnPlay = 1) and (Player1Type > 0)) then
        Default_AI.Move(GameField, 1, 2, Player1Aidiff, GamePlayerX, GamePlayerY)

      else if (OnPlay = 2) and (Player2Type > 0) then
        Default_AI.Move(GameField, 2, 1, Player2Aidiff, GamePlayerX, GamePlayerY);
    end

    else EndGame;
    {%Endregion}
  end;

  {Finishes the game, sets GameIsP1ToStart for the next game}
  procedure TgomokuBoardForm.EndGame;
  begin
    MainTimer.Enabled := False;;
    IndividualTimeZero := Now;
    IndividualTimer.Enabled := False;

    case OnPlay of
      1: Player1Score := Player1Score + 1;
      2: Player2Score := Player2Score + 1;
    end;

    case NextToStartStrat of
      0: GameIsP1ToStart := Player1Begins;
      1: GameIsP1ToStart := not GameIsP1ToStart;
      2: GameIsP1ToStart := (OnPlay = 1);
      3: GameIsP1ToStart := (OnPlay = 2);
      4: GameIsP1ToStart := (Random(2) = 0);
    end;

    OnPlay := 0;

    TieButton.Enabled := False;
    SurrenderButton.Enabled := False;
    NewGameButton.Enabled := True;
    QuitButton.Enabled := True;
  end;

  {Ends the game immediatelly, before one player wins}
  {param0: A player who technically won and shall get points}
  procedure TgomokuBoardForm.TerminateGame(whowon: Byte);
  begin
    OnPlay := whowon;
    EndGame;
  end;
{%EndRegion}

end.
