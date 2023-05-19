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
    quantity:Integer;
    cut:Integer;
    width:Integer;
    heigth:Integer;
    const LPARTNUMBER = 20;
    const LCOMMENT = 40;
    const LQUANTITY = 4;
    const LCUT = 8;
    const LWIDTH = 6;
    const LHEIGTH = 6;
    const LLONG = 6;
  public
    constructor Create(inputlist:TStringList);
    destructor Destroy; override;
    procedure getTextContent(tcc:TStrings);
    function getPartNumber:String;
    function getComment:String;
    function getLong:integer;
    function getQuantity:integer;
  end;

implementation

//Конструктор класса-изделия
constructor TBVNItem.Create(inputlist: TStringList);
/////////////////////////////////////////////////////////////////////////////////
///     вспомогательные процедуры конструктора
/////////////////////////////////////////////////////////////////////////////////

   ///разбивка первой строки
   procedure splitfirstline(sinp:String; out in_partnumber, in_comment:String);
   begin
     //6 символов номер детали + потом пробел
     delete(sinp,1,7);
     showmessage('='+sinp);
     in_partnumber:=copy(sinp,1,LPARTNUMBER);
     delete(sinp,1,LPARTNUMBER);
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
     in_comment:=copy(sinp,1,LCOMMENT);
     delete(sinp,1,LCOMMENT);
   end;
   /////////////////////////////////////////////////////////////////////////////

   //разбивка второй строки
   procedure splitsecondline(inps:String; out in_quantity, in_cut, in_width, in_heigth, in_long:integer);
   begin
     //6 символов номер детали, потом пробел
     delete(inps,1,7);
     //13 пробелов
     delete(inps,1,13);
     //4 символа - это количество изделий
     try
       in_quantity:=StrToInt(trim(copy(inps,1,LQUANTITY)));
     except
       raise EConvertError.Create('Неверное содержание BVN-файла. Код 3');
     end;
     delete(inps,1,LQUANTITY);
     //8 символов cut - видимо отпил?
     try
       in_cut:=StrToInt(trim(copy(inps,1,LCUT)));
     except
       raise EConvertError.Create('Неверное содержание BVN-файла. Код 4');
     end;
     delete(inps,1,LCUT);
     //два пробела
     delete(inps,1,2);
     //6 символов ширина бруса
     try
       in_width:=StrToInt(trim(copy(inps,1,LWIDTH)));
     except
       raise EConvertError.Create('Неверное содержание BVN-файла. Код 5');
     end;
     delete(inps,1,LWIDTH);
     //два пробела
     delete(inps,1,2);
     //6 символов высота бруса
     try
       in_heigth:=StrToInt(trim(copy(inps,1,LHEIGTH)));
     except
       raise EConvertError.Create('Неверное содержание BVN-файла. Код 6');
     end;
     delete(inps,1,LHEIGTH);
     //два пробела
     delete(inps,1,2);
     //6 символов длинна бруса
     try
       in_long:=StrToInt(trim(copy(inps,1,LLONG)));
     except
       raise EConvertError.Create('Неверное содержание BVN-файла. Код 7');
     end;
     delete(inps,1,LLONG);
   end;

/////////////////////////////////////////////////////////////////////////////////
begin
  TextContent:=TStringList.Create;
  TextContent.Assign(inputlist);
  splitfirstline(TextContent[0],partnumber,comment);
  splitsecondline(TextContent[1],quantity,cut,width,heigth,long);
  showmessage('='+inttostr(quantity)+'='+inttostr(cut)+'='+inttostr(width)+'='+inttostr(heigth)+'='+inttostr(long));
  showmessage('='+partnumber+'='+comment+'=');
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

function TBVNItem.getLong: Integer;
begin
  Result:=long;
end;

function TBVNItem.getQuantity: Integer;
begin
  Result:=quantity;
end;

end.
