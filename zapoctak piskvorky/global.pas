unit Global;

{$mode objfpc}{$H+}

interface
  type
    GameFieldArray = Array of Array of Byte;

  var
    Configuration: Array of string;
    ResetConfig: Boolean;
    DoNotSave, ScheduleDoNotSave: Boolean;

  const
    AboutMessage: String =

      'Gomoku v1.0, vytvořil Kryštof Žucha, 2018 - 2019' + LineEnding +
      'krepsy3@centrum.cz' + LineEnding +
      'Program vzniknul jako semestrální zápočtový program na MFF UK v Praze' + LineEnding +
      'Programovací jazyk: Pascal (object pascal), Lazarus forms' + LineEnding +
      'Použité nástroje: Lazarus IDE, Microsoft Malování' + LineEnding +
      '' + LineEnding +
      '' + LineEnding +
      '' + LineEnding +
      'Piškvorky (neboli gomoku)' + LineEnding +
      '' + LineEnding +
      'Hra původem z Japonska je velmi oblíbenou kratochvílí pro všechny generace.' + LineEnding +
      'Dva hráči mají každý svůj symbol, tradičně kolečko a křížek, které postupně' + LineEnding +
      'vpisují do herního pole tvořeného čtverečkovou mřížkou. Jejich cílem je vytvořit' + LineEnding +
      'v herním poli tzv. piškvorku (a zároveň v tom zabránit soupeři). Vyhrává' + LineEnding +
      'samozřejmě ten hráč, kterému se to podaří jako první.' + LineEnding +
      '' + LineEnding +
      'Piškvorkou se rozumí nepřerušená posloupnost pěti (a více) stejných symbolů' + LineEnding +
      'v libovolném řádku či sloupci, nebo na libovolné diagonále v rámci celého pole.' + LineEnding +
      '' + LineEnding +
      '' + LineEnding +
      '' + LineEnding +
      'Ovládání programu' + LineEnding +
      '' + LineEnding +
      'Program je logicky členěn na dvě části. Nad nimi se nachází nadpis a tlačítko' + LineEnding +
      'info, které vám zobrazí tuto informační stránku. Dále se na liště okna nachází' + LineEnding +
      'klasická tlačítka pro minimalizaci a ukončení programu.' + LineEnding +
      '' + LineEnding +
      '' + LineEnding +
      'Horní část programu tvoří hlavní menu, kde je možno nastavit veškeré' + LineEnding +
      'parametry před zahájením vlastní hry. Další nastavení, konkrétně ' + LineEnding +
      'časování tahů, výběr prvního hráče či chytrost počítačem řízených hráčů, ' + LineEnding +
      'se zobrazí kliknutím na tlačítko Možnosti. Kliknutím na tlačítko Hrát! zahájíte hru.' + LineEnding +
      '' + LineEnding +
      'Popis jednotlivých parametrů nastavení se zobrazí u kurzoru myši při najetí' + LineEnding +
      'na příslušnou nastavovací kontrolku.' + LineEnding +
      '' + LineEnding +
      'Aplikace nastavení ukládá do konfiuračního souboru. Vždy se tak spustí ' + LineEnding +
      've stavu, ve kterém byla naposledy ukončena. Pokud chcete provést rychlý ' + LineEnding +
      'reset těchto nastavení, klikněte na tlačítko Reset, které se nachází ' + LineEnding +
      'na panelu rozšířených nastavení.' + LineEnding +    
      '' + LineEnding +
      'Chcete-li naopak uložit současné nastavení jako výchozí stav po každém ' + LineEnding +
      'spuštění aplikace, klikněte na tlačítko Uložit výchozí stav na panelu ' + LineEnding +
      'rozšířených nastavení. Tím se do konfiguračního souboru zapíše, že aplikace se ' + LineEnding +
      'má vždy spouštět s daným výchozím nastavením! Pokud chcete uložit nové výchozí ' + LineEnding +
      'nastavení, použijte tlačítko znova. Pokud chcete obnovit základní chování, ' + LineEnding +
      'použijte tlačítko Reset.' + LineEnding +
      '' + LineEnding +
      '' + LineEnding +
      'Dolní část programu tvoří samotné herní území. Herní pole tvoří mřížka vlevo.' + LineEnding +
      'Umístění symbolu lidského hráče do pole se provádí kliknutím levým' + LineEnding +
      'tlačítkem myši na příslušný čtvereček herního pole.' + LineEnding +
      'Naposledy umístěný symbol je vždy podbarven žlutou barvou.' + LineEnding +
      '' + LineEnding +
      'Vpravo nalezenete veškeré informace o průběhu hry. Zobrazuje se čas kola,' + LineEnding +
      'skóre hráčů z jednotlivých kol, kdo je právě na tahu a čas jeho tahu.' + LineEnding +
      'Pod těmito informacemi se nacházejí další tlačítka pro ovládání průběhu hry.' + LineEnding +
      '' + LineEnding +
      'Tlačítko Nabídnout remízu je relevantní pouze pro hru dvou lidských hráčů.' + LineEnding +
      'Pokud hráč, který je na tahu stiskne toto tlačítko, zobrazí se soupeři dotaz,' + LineEnding +
      'zdali remízu přijímá. Pokud ji přijme, kolo skončí bez připočtení bodů.' + LineEnding +
      'Pokud ji nepřijme, na tahu je opět hráč, který remízu původně nabídnul.' + LineEnding +
      '' + LineEnding +
      'Tlačítko Vzdát se předčasně ukončí kolo a hráč, který jej stisknul, dané kolo' + LineEnding +
      'prohrává, a soupeři se připočte bod.' + LineEnding +
      '' + LineEnding +
      'Tlačítko Nové kolo je možno stisknout po skončení předešlého kola.' + LineEnding +
      'Stisknutím se zahájí nové kolo. V tomto kole začíná hráč určený podle' + LineEnding +
      'zvoleného pravidla v nabídce tlačítka Možnosti v hlavním menu.' + LineEnding +
      '' + LineEnding +
      'Tlačítko Skončit je možno stisknout po skončení předešlého kola.' + LineEnding +
      'Stisknutím se ukončí hra, body se vynulují a program se navrátí' + LineEnding +
      'do hlavního menu.'
      ;

  defconfigs: array[0..8] of string = ('0','0','','','1','1','0','1','1');

implementation

end.

