unit BVNItem;

interface

uses System.SysUtils, System.Classes, Vcl.Dialogs;

type
  TBvnItem = class
  private
    TextContent:TStringList;
    long:integer;
    partnumber:String;
    comment:String;
  public
    constructor Create(inputlist:TStringList);
    destructor Destroy; override;
    procedure getTextContent(tcc:TStrings);
    function getPartNumber:String;
    function getComment:String;
  end;

implementation

//Конструктор класса-изделия
constructor TBVNItem.Create(inputlist: TStringList);
/////////////////////////////////////////////////////////////////////////////////
///     вспомогательные процедуры конструктора
/////////////////////////////////////////////////////////////////////////////////

   ///разбивка первой строки
   procedure splitfirstline(sinp:String);
   begin
     delete(sinp,1,7);
     showmessage('='+sinp);
     partnumber:=copy(sinp,1,20);
     delete(sinp,1,20);
     //8 символов непонятно что - пробелы
     //10 символов - последняя строка К2, тип - пока нам не нужно
     //потом пробел идёт
     //два символа - профиль, если добавить в поле больше, два символа в первой строке остаются, а остальные
     //сносятся в операцию с кодом 3200, где всего 29 символов
     //три символа крыша, они нам не нужны пока
     //три символа сорт, при большом заполнении превращаются в косяк, сносятся в 3202 - 31 символ
     //пять символов - пакет, со сноской в 3201, если не влезли, 31 символ в 3201
     //10 символов сорт, дублируется почему то, если больше 8, то сносится в 3202

     //поэтому удаляем 42 символа, которые пока не пользуем
     delete(sinp,1,42);
     //ну и наконец 40 символов комментарий
     comment:=copy(sinp,0,40);
     showmessage('='+partnumber+'='+comment+'=');
   end;

/////////////////////////////////////////////////////////////////////////////////
begin
  TextContent:=TStringList.Create;
  TextContent.Assign(inputlist);
  splitfirstline(TextContent[0]);
end;
//конец конструктора
/////////////////////////////////////////////////////////////////////////////////


//деструктор
destructor TBVNItem.Destroy;
begin
  TextContent.Free;
end;

//геттеры и сеттеры TBVNItem
procedure TBVNItem.getTextContent(tcc: TStrings);
begin
  if assigned(TextContent) then tcc.Assign(TextContent);
end;

function TBVNItem.getPartNumber: string;
begin
  Result:=partnumber;
end;

function TBVNItem.getComment: string;
begin
  Result:=comment;
end;

end.
